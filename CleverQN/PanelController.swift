//
//  PanelController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/7/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class PanelController: UIViewController {

    let menuText: [String] = ["USERS", "LOCK", "SETTINGS", "HISTORY", "SHARE", "INFO"]
    let menuIcon: [String] = ["user_icon", "Lock_Icon", "gear", "history", "share_icon", "ic_info"]
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var cstHeightColl: NSLayoutConstraint!
    @IBOutlet weak var collectPanel: UICollectionView!
    
    var historyTableController: HistoryTableController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transparentNavigationBar()
        navigationItem.title = "Control Panel"
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow_back"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(PanelController.backTap), for: .touchUpInside)
        let back = UIBarButtonItem(customView: button)
        navigationItem.setLeftBarButton(back, animated: true)
        
        collectPanel.dataSource = self
        collectPanel.delegate = self
        addViewController(childViewController: lockScreenController)
    }
    
    func backTap() {
        
        if let allViewController: [UIViewController] = self.navigationController?.viewControllers {
            for viewController: UIViewController in allViewController {
                // print(viewController)
                if viewController is UserController { // or viewcontroller.isKind(of: UserScreenController)
                    self.navigationController?.popToViewController(viewController, animated: true)
                }
            }
        }
    }
    
    lazy var userScreenController: UserScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let users = storyboard.instantiateViewController(withIdentifier: "Users") as! UserScreenController
        return users
    }()
    
    lazy var lockScreenController: LockScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let lock = storyboard.instantiateViewController(withIdentifier: "Lock") as! LockScreenController
        return lock
    }()
    
    lazy var settingScreenController: SettingScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let setting = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingScreenController
        return setting
    }()
    
    lazy var historyScreenController: HistoryScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let history = storyboard.instantiateViewController(withIdentifier: "History") as! HistoryScreenController
        return history
    }()
    
    lazy var shareScreenController: ShareScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let share = storyboard.instantiateViewController(withIdentifier: "Share") as! ShareScreenController
        return share
    }()
    
    lazy var infoScreenController: InfoScreenController = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let info = storyboard.instantiateViewController(withIdentifier: "Info") as! InfoScreenController
        return info
    }()
}

extension PanelController {
    
    public func addViewController(childViewController: UIViewController) {
        addChildViewController(childViewController)
        
        self.panelView.addSubview(childViewController.view)
        childViewController.view.frame = panelView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
    }
    
    public func removeViewController(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
    public func removeAllController() {
        removeViewController(childViewController: userScreenController)
        removeViewController(childViewController: lockScreenController)
        removeViewController(childViewController: settingScreenController)
        removeViewController(childViewController: historyScreenController)
        removeViewController(childViewController: shareScreenController)
        removeViewController(childViewController: infoScreenController)
    }
    
    public func removeView(view: String) {
        if (view == "users") {
            removeViewController(childViewController: userScreenController)
        } else if (view == "lock") {
            removeViewController(childViewController: lockScreenController)
        } else if (view == "setting") {
            removeViewController(childViewController: settingScreenController)
        } else if (view == "history") {
            removeViewController(childViewController: historyScreenController)
        } else if (view == "share") {
            removeViewController(childViewController: shareScreenController)
        } else if (view == "info") {
            removeViewController(childViewController: infoScreenController)
        }
    }
}

extension PanelController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // collectPanel.collectionViewLayout.collectionViewContentSize.height
        //        setHeightOfTbl(num: 3)
        return menuText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PanelCell
        let index = indexPath.row
        cell.title.text = menuText[index]
        cell.imgIcon.image = UIImage(named: menuIcon[index])
        //        cell.center.y = self.view.center.y
        
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: "button_bg_press_panel")
        cell.selectedBackgroundView = bgImage
        return cell
    }
}

extension PanelController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let choseMenu = menuText[indexPath.row]
        switch choseMenu {
            
            case "USERS":
                removeAllController()
                addViewController(childViewController: userScreenController)
                break
            
            case "LOCK":
                removeAllController()
                addViewController(childViewController: lockScreenController)
                break
            
            case "SETTINGS":
                removeAllController()
                addViewController(childViewController: settingScreenController)
                break
      
            case "HISTORY":
                removeAllController()
                addViewController(childViewController: historyScreenController)
                break
            
            case "SHARE":
                removeAllController()
                addViewController(childViewController: shareScreenController)
                break
            
            case "INFO":
                removeAllController()
                addViewController(childViewController: infoScreenController)
                break
            
            default:
                addViewController(childViewController: lockScreenController)
                break
        }
    }
}

extension PanelController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSpacing = CGFloat(1) // khoang cach cua 1 cell
        let numColumns = CGFloat(3) // so cell tren 1 dong
        let totalCellSpace = cellSpacing * (numColumns - 1) // tong khoang cach giua cac cell
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - totalCellSpace) / numColumns
        
        cstHeightColl.constant = (cellWidth + 0.5) * 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension UINavigationBar {
    // trong suot navigationbar
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

extension UINavigationItem {
    func setBackButton(named: String) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: named), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(self.backTap), for: .touchUpInside)
        let back = UIBarButtonItem(customView: button)
        self.setLeftBarButton(back, animated: true)
    }
    
    func backTap() {
        let navigationController = UINavigationController()
        navigationController.popViewController(animated: true)
    }
}

extension UINavigationController {
    // back to view previous
    func backToViewController(vc: Any) {
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
