//
//  AccountViewController.swift
//  commspro
//
//  Created by Anthony Picciano on 11/25/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

let UserDidLogOut = NSNotification.Name(rawValue: "UserDidLogOut")
let UserDidLogIn = NSNotification.Name(rawValue: "UserDidLogIn")

class AccountViewController: UIViewController {

    @IBOutlet weak var currentAccountLabel: UILabel!
    @IBOutlet weak var accountNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CommsProStyleKit.commsTan.withAlphaComponent(0.5)

        updateDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accountNameField.becomeFirstResponder()
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        updateDisplay()
    }
    
    fileprivate func clearFields() {
        accountNameField.text = nil
        passwordField.text = nil
        repeatPasswordField.text = nil
        
        accountNameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        repeatPasswordField.resignFirstResponder()
        
        updateDisplay()
    }
    
    fileprivate func updateDisplay() {
        let currentUser: BackendlessUser? = Backendless.sharedInstance().userService.currentUser
        currentAccountLabel.text = currentUser?.name as? String ?? "Not logged in."
        
        logOutButton.isEnabled = currentUser != nil
        
        if let accountName = accountNameField.text,
            let password = passwordField.text,
            accountName.characters.count > 3,
            password.characters.count > 3 {
            logInButton.isEnabled = true
            
            registerButton.isEnabled = password == repeatPasswordField.text
            
        } else {
            logInButton.isEnabled = false
            registerButton.isEnabled = false
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        Backendless.sharedInstance().userService.logout( { user in
            debugPrint("User logged out.")
            NotificationCenter.default.post(name: UserDidLogOut, object: user)
            self.clearFields()
        }, error: { (fault) -> () in
            debugPrint("Server reported an error: \(fault)")
            self.show(fault: fault)
        })
    }
    
    @IBAction func logInAction(_ sender: Any) {
        if let accountName = accountNameField.text,
            let password = passwordField.text {
            Backendless.sharedInstance().userService.login(accountName, password: password, response: { user in
                debugPrint("User has been logged in (ASYNC): \(user)")
                NotificationCenter.default.post(name: UserDidLogIn, object: user)
                self.clearFields()
            }, error: { (fault) -> () in
                debugPrint("Server reported an error: \(fault)")
                self.show(fault: fault)
            })
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if let accountName = accountNameField.text as NSString!,
            let password = passwordField.text as NSString! {
            
            let user = BackendlessUser()
            user.name = accountName
            user.password = password
            
            Backendless.sharedInstance().userService.registering(user, response: { registeredUser in
                debugPrint("User has been registered (ASYNC): \(registeredUser)")
                
                // The registration API does not login the user.
                self.logInAction(self)
            }, error: { fault in
                debugPrint("Server reported an error: \(fault)")
                self.show(fault: fault)
            })
        }
    }
    
    func show(fault: Fault?) {
        guard let fault = fault else {
            return
        }
        
        let viewController = UIAlertController(title: "Fault", message: fault.detail, preferredStyle: .alert)
        
        viewController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { action in
            self.clearFields()
        }))
        
        present(viewController, animated: true, completion: nil)
    }

}
