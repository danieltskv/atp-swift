//
//  LoginTVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 29.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import SVProgressHUD
import MBPhotoPicker

enum LoginMode: String {
    case Login
    case Signup
}

class LoginTVC: UITableViewController, UITextFieldDelegate {

    // MARK: - Properties

    var loginMode: LoginMode = .Login
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Actions
    
    @IBAction func selectAvatarPressed(sender: UITapGestureRecognizer)  {
        let photoPicker: MBPhotoPicker? = MBPhotoPicker()
        photoPicker?.alertTitle = nil;
        photoPicker?.alertMessage = nil
        photoPicker?.actionTitleCancel = NSLocalizedString("Cancel", comment: "")
        photoPicker?.actionTitleTakePhoto = NSLocalizedString("Take Photo", comment: "")
        photoPicker?.actionTitleLastPhoto = NSLocalizedString("Use Last Photo", comment: "")
        photoPicker?.actionTitleOther = NSLocalizedString("Other", comment: "")
        photoPicker?.actionTitleLibrary = NSLocalizedString("Library", comment: "")

        photoPicker?.photoCompletionHandler = { [weak self] (image: UIImage!) -> Void in
            print("Selected image")
            
            self?.avatarImageView.image = image
        }
        photoPicker?.cancelCompletionHandler = {
            print("Cancel Pressed")
        }
        photoPicker?.errorCompletionHandler = { (error: MBPhotoPicker.ErrorPhotoPicker!) -> Void in
            print("Error: \(error.rawValue)")
        }
        photoPicker?.present(self)
    }
    
    func dismissScreen() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        SVProgressHUD.showWithStatus(NSLocalizedString("Loading...", comment: ""))

        //@daniel: remove after demo
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()

            if self.loginMode == .Login {
                self.login()
            } else {
                self.signup()
            }
        }
    }
    
    func login() {
        guard let username = usernameTF.text, let password = passwordTF.text else {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("Please input all fields", comment: ""))
            return
        }
        
        APIClient.loginWithUsername(username, password: password) { [weak self] (user, error) in
            if error != nil {
                SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
            } else {
                DataManager.sharedInstance.currentUser = user
                DataManager.sharedInstance.saveUser()
                
                self?.dismissScreen()
            }
        }
    }
    
    func signup() {
        guard let username = usernameTF.text, let password = passwordTF.text else {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("Please input all fields", comment: ""))
            return
        }
        APIClient.signupWithUsername(username, password: password, avatar: avatarImageView.image) { [weak self] (user, error) in
            if error != nil {
                SVProgressHUD.showErrorWithStatus(error?.localizedDescription)
            } else {
                DataManager.sharedInstance.currentUser = user
                DataManager.sharedInstance.saveUser()
                
                self?.dismissScreen()
            }
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dismissScreen()
    }
    
    @IBAction func rightBarButtonPressed(sender: UIBarButtonItem) {
        if loginMode == .Login {
            title = NSLocalizedString("Sign up", comment: "")
            loginButton.setTitle(NSLocalizedString("Sign up", comment: ""), forState: .Normal)
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Login", comment: "")
            loginMode = .Signup
        } else {
            title = NSLocalizedString("Login", comment: "")
            loginButton.setTitle(NSLocalizedString("Login", comment: ""), forState: .Normal)
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("Sign up", comment: "")
            loginMode = .Login
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return (loginMode == .Login) ? 2 : 2
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameTF {
            passwordTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
