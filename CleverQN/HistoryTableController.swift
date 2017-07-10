//
//  HistoryTableController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/20/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import Spring

class HistoryTableController: UIViewController {

    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    var timer: Timer!
    
    @IBAction func btnCancel(_ sender: UIButton) {
        removeLoadingDialog()
//        UIView.animate(withDuration: 0.5, animations: {
//            self.dialogView.center.x -= self.view.bounds.width
//            self.tblHistory.alpha = 1.0
//            self.filterView.isHidden = false
//        }, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: UIButton) {
        self.filterDialog()
//        self.showLoadingDialog()
    }

    var numberArr: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.allowsSelection = false
        
        navigationItem.title = "History List"
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow_back"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let back = UIBarButtonItem(customView: button)
        navigationItem.setLeftBarButton(back, animated: true)
        
        self.dialogView.layer.cornerRadius = 5
    }
    
    func removeLoadingDialog() {
        timer.invalidate()
        self.dialogView.duration = 1.5
        self.dialogView.animation = "fadeOut"
        self.dialogView.curve = "easeOut"
        self.dialogView.animate()
        self.tblHistory.alpha = 1.0
        self.filterView.isHidden = false
        self.dialogView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.tblHistory.alpha = 0.3
        self.filterView.isHidden = true
        self.dialogView.isHidden = true
//        self.dialogView.center.x += self.view.bounds.width
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.dialogView.isHidden = false
        self.dialogView.duration = 1.0
        self.dialogView.animation = "slideLeft"
        self.dialogView.curve = "easeIn"
        self.dialogView.animate()
        timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(loadingProgress), userInfo: nil, repeats: true)
    }
    
    func animateTable() {
        tblHistory.reloadData()
        let cells = tblHistory.visibleCells
        let tableHeight: CGFloat = tblHistory.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index: Double = 0
        for cellItem in cells {
            let cell: UITableViewCell = cellItem
            
            UIView.animate(
                withDuration: 1.5,
                delay: 0.05 * index,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            index += 3 //1
        }
    }
    
    var counter: Int = 0 {
        didSet {
            let fractionalProgress = Float(counter * 2) / 100
            let animated = counter != 0
            print("progress: \(fractionalProgress)")
            progressView.setProgress(fractionalProgress, animated: animated)
            lblProgress.text = ("\(Int(fractionalProgress * 100))%")
            
            if (fractionalProgress == 1.0) {
                self.timer.invalidate()
                self.numberArr.reverse()
                self.animateTable()
                self.removeLoadingDialog()
            }
        }
    }
    
    func showLoadingDialog() {
        let modal = NameDialogController()
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        present(modal, animated: true, completion: nil)
    }
    
    func loadingProgress() {
        self.tblHistory.alpha = 0.3
        self.numberArr.append(self.counter)
        self.counter += 1
//            OperationQueue.main.addOperation() {
//                for i in 1...100 {
//                    Thread.sleep(forTimeInterval: 0.04)
//                    self.counter += (i*2)
//                    self.numberArr.append(i)
//                }
//                self.numberArr.reverse()
//                self.animateTable()
//            }
    }
    
    func filterDialog() {
        let modal = HistoryFilterDialogController()
        modal.modalPresentationStyle = .overCurrentContext
        modal.modalTransitionStyle = .crossDissolve
        present(modal, animated: true, completion: nil)
    }
    
    func tapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberArr.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 0.3) // TransformFlip
        
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
//        cell.layer.transform = rotationTransform
//        UIView.animate(withDuration: 1.0, animations: {
//            cell.layer.transform = CATransform3DIdentity
//        })
        
        cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1) // 1.05, 1.05, 1
        }, completion: { finished in
//            UIView.animate(withDuration: 0.1, animations: {
//                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//            })
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
        
        if (indexPath.row % 2 == 0) {
            cell.lblNumber.backgroundColor = UIColor.darkGray
        } else {
            cell.lblNumber.backgroundColor = UIColor.lightGray
        }
        
        cell.lblNumber.text = "\(numberArr[indexPath.row] + 1)"
        cell.lblDateTime.text = "28-06-2017 11:22:33"
        cell.lblUser.text = "Admin"
        cell.lblAction.text = "Lock Control: LOCK BY FP"
        
        return cell
    }
}

extension HistoryTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
