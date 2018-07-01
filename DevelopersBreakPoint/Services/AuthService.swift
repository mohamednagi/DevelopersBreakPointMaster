//
//  AuthService.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/18/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    static let instance = AuthService()
    
    func register(withEmail email:String , andPassword password:String , userCreationComplete: @escaping (_ status:Bool , _ error : Error?) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
        }
            let userData = ["provider" : user.providerID , "Email" : user.email , "userImagePath" : ""]
            DataService.instance.CreateDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func login(withEmail email:String , andPassword password:String , loginComplete: @escaping (_ status:Bool , _ error: Error?)->() ){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}








