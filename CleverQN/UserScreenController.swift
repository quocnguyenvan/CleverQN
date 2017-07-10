//
//  UsersController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/8/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import CoreData
import SwiftMessages

class UserScreenController: UIViewController {

    var menu: [String] = ["Rename", "Change Passcode", "Fingerprints"]
//    var userManager: [String] = []
    var userManager: [NSManagedObject] = []
    var imageAvatar: UIImage?
    
    lazy var slideInTransitioningDelegate = SlideInPresentationDelegate()
    
    @IBOutlet weak var tblUser1: UITableView!
    @IBOutlet weak var tblUser2: UITableView!
    @IBOutlet weak var tblUser3: UITableView!
    
    @IBOutlet weak var cstHeightOfTblUser1: NSLayoutConstraint!
    @IBOutlet weak var cstHeightOfTblUser2: NSLayoutConstraint!
    @IBOutlet weak var cstHeightOfTblUser3: NSLayoutConstraint!
    
    @IBAction func btnAdd(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "Modal") as! AddNewUserController
        slideInTransitioningDelegate.direction = .top
        slideInTransitioningDelegate.disableCompactHeight = true
        controller.transitioningDelegate = slideInTransitioningDelegate
        controller.addNewUserDelegate = self
        controller.modalPresentationStyle = .custom
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblUser1.dataSource = self
        tblUser1.delegate = self
        tblUser2.dataSource = self
        tblUser2.delegate = self
        tblUser3.dataSource = self
        tblUser3.delegate = self
        self.tblUser1.layer.cornerRadius = 5.0
        self.tblUser2.layer.cornerRadius = 10
        self.tblUser3.layer.cornerRadius = 10
//        self.tblUser.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    func getUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        do {
            userManager = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension UserScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num: Int = 0
        if tableView == tblUser1 {
            num = 1
            self.cstHeightOfTblUser1.constant = CGFloat(95)
            
        } else if tableView == tblUser2 {
            num = menu.count
            self.cstHeightOfTblUser2.constant = CGFloat(num * 44)
            
        } else if (tableView == tblUser3) {
            num = userManager.count
            self.cstHeightOfTblUser3.constant = CGFloat(num * 58)
            
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if (tableView == tblUser1) {
            height = 95
        } else if (tableView == tblUser2) {
            height = 44
        } else if (tableView == tblUser3) {
            height = 58
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblUser1 {
            let cellUser = Bundle.main.loadNibNamed("CustomCellUser", owner: self, options: nil)?.first as! CustomCellUser
            cellUser.lbCurrentUser.text = "Current User"
            cellUser.lbUserName.text = "Admin01"
            cellUser.lbPermission.text = "Admin"
            cellUser.separatorInset = UIEdgeInsets.zero

            if cellUser.avatarImageDelegate == nil {
                cellUser.avatarImageDelegate = self
            }
                
            if (imageAvatar != nil) {
                cellUser.imgAvatar.image = imageAvatar
            }
            return cellUser
            
        } else if tableView == tblUser2 {
            let cell = Bundle.main.loadNibNamed("CustomCellUser2", owner: self, options: nil)?.first as! CustomCellUser2
            cell.accessoryType = .disclosureIndicator
            
            cell.userMenu.text = menu[indexPath.row]
            return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("CustomCellUserManager", owner: self, options: nil)?.first as! CustomCellUserManager
            cell.accessoryType = .disclosureIndicator
            
            let user = userManager[indexPath.row]
            let name = user.value(forKeyPath: "name") as? String
            
            let firstText = name?.characters.first // lay ky tu dau tien
            
            cell.imgUser.text = String(describing: firstText!)
            
            cell.lbName.text = name
            cell.lbPermission.text = "Permissions: User"
            
//            let bgColorView = UIView()
//            bgColorView.backgroundColor = UIColor(red: 200/255, green: 203/255, blue: 207/255, alpha: 1)
//            cell.selectedBackgroundView = bgColorView
            return cell
        }
    }
}

// add user
extension UserScreenController: UITableViewDelegate, AddNewUserDelegate {
    
    func addNewUser(user: String, pass: String, rePass: String) {
        if (user.isEmpty || pass.isEmpty || rePass.isEmpty) {
            showMessage(content: "Vui lòng nhập đầy đủ thông tin!", theme: .error, duration: 0.8)
        } else if (pass.caseInsensitiveCompare(rePass) == .orderedSame) {
            
            saveUser(name: user)
            tblUser3.reloadData()
            dismiss(animated: true, completion: nil)
            showMessage(content: "Tạo tài khoản thành công!", theme: .success, duration: 1.0)
        } else {
            showMessage(content: "Mật khẩu không trùng khớp!", theme: .error, duration: 0.8)
        }
    }
    
    func saveUser(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
//        user.setValue(id, forKeyPath: "id")
        user.setValue(name, forKeyPath: "name")
            
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                userManager.append(user)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func showMessage(content: String, theme: Theme, duration: TimeInterval) {
        let message = MessageView.viewFromNib(layout: .MessageView)
        message.configureTheme(theme, iconStyle: .subtle)
        message.configureDropShadow()
        message.configureContent(body: content)
        message.button?.isHidden = true
        message.titleLabel?.isHidden = true
        var messageConfig = SwiftMessages.defaultConfig
        messageConfig.presentationStyle = .top
        messageConfig.duration = .seconds(seconds: duration)
        messageConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        SwiftMessages.show(config: messageConfig, view: message)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserScreenController: AvatarImageDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tapAvatar() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alertChooseAvatar = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        alertChooseAvatar.addAction(photo)
        alertChooseAvatar.addAction(camera)
        alertChooseAvatar.addAction(cancel)
        self.present(alertChooseAvatar, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("😞: \(info)")
        }
        
        imageAvatar = selectedImage
        tblUser1.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func noCamera() {
        let alert = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present( alert, animated: true, completion: nil)
    }
}

extension UIView {
    func roundCorners(withRadius radius: CGFloat, at corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
