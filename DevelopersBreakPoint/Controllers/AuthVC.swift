//
//  AuthVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    if Auth.auth().currentUser != nil{
        dismiss(animated: true, completion: nil)
    }
    }
    @IBAction func EmailSignInbtnWasPressed(_ sender: UIButton) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    @IBAction func GoogleSignInbtnWasPressed(_ sender: UIButton) {
    }
    @IBAction func FacebookSignInbtnWasPressed(_ sender: UIButton) {
    }
    
 

}
