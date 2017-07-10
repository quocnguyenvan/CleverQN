//
//  UserScreenController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/6/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit

class UserController: UIViewController {

    var userName: [String] = ["Admin01", "user", "ABC"]
    var permission : [String] = ["Admin", "User", "ABC"]
    @IBOutlet weak var tblUser: UITableView!
    @IBOutlet weak var btnBackView: UIButton!
    @IBOutlet weak var cstHeightOfTbl: NSLayoutConstraint!
    
    @IBAction func btnBackTap(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblUser.dataSource = self
        tblUser.delegate = self
        tblUser.layer.cornerRadius = 10
        tblUser.layer.masksToBounds = true
        
        btnBackView.layer.cornerRadius = btnBackView.frame.size.width/2
        btnBackView.layer.borderWidth = 1.5
        btnBackView.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        tableViewAlignCenter()
//        tblUser.reloadData()
    }
    
    // canh table view giua man hinh
    func tableViewAlignCenter() {
//        tblUser.frame = CGRect(x: tblUser.frame.origin.x, y: tblUser.frame.origin.y, width: tblUser.frame.size.width, height: tblUser.contentSize.height)
//        let width = self.tblUser.bounds.width //view.frame.size.width;
//        let height = self.view.frame.size.height;
//        let tableHeight = tblUser.frame.size.height
//        self.tblUser.frame = CGRect(x: 0, y: (height-tableHeight)/2,width: width, height: tableHeight);
    }
}

extension UserController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.setHeightOfTbl(num: userName.count)
        return userName.count
    }
    
    func setHeightOfTbl(num: Int) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3) {
                self.cstHeightOfTbl.constant = CGFloat(num * 84)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        // get ky tu dau tien
//        let stringInput = "First Last"
//        print(stringInput.characters.first)
        
        cell.lblUserName.text = userName[indexPath.row]
        cell.lblPermission.text = "Permissions: \(permission[indexPath.row])"
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 120/255, green: 121/255, blue: 122/255, alpha: 1)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
}

extension UserController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginScreen = storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginScreenController
        loginScreen.userName = userName[indexPath.row]
        navigationController?.pushViewController(loginScreen, animated: true)
    }
}

