//
//  LoginVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate=self
        passwordField.delegate=self
    }

    @IBAction func SignInBtnWasPressed(_ sender: UIButton) {
        if emailField.text != nil && passwordField.text != nil {
        AuthService.instance.login(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "ERROR", message: "\(error!.localizedDescription)", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            AuthService.instance.register(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, error) in
                if success{
                    AuthService.instance.login(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                        print("Successfully registered user")
                        self.dismiss(animated: true, completion: nil)
                    })
                }else{
                    let alert = UIAlertController(title: "ERROR", message: "\(error!.localizedDescription)", preferredStyle: .alert )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    }
}

extension LoginVC:UITextFieldDelegate{ }
