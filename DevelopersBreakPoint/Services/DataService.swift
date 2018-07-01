//
//  DataService.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService{

    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    var REF_USERS : DatabaseReference {
        return _REF_USERS
    }
    var REF_GROUPS : DatabaseReference {
        return _REF_GROUPS
    }
    var REF_FEED : DatabaseReference {
        return _REF_FEED
    }
    
    ////////////////////////////////////////////////
    var imageReference : StorageReference{
        return Storage.storage().reference(forURL: "gs://developersbreakpoint-4a403.appspot.com")
    }
    ////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////
    
    // get image from storage
    func setUserImage(url:String , imageholder:UIImageView){
        let postImageRef = imageReference.child(url)
        postImageRef.getData(maxSize: 8*1024*1024) { (data, error) in
            if let error = error {
                print("this is my download error in DataService : setUserImage\(error.localizedDescription)")
            }else{
                imageholder.image = UIImage(data: data!)
            }
        }
    }
    func loadImageFromFirebase(userUID:String , imageholder:UIImageView){
        let ref = Database.database().reference()
        ref.child("users").child(userUID).observe(.value) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postKey = snap.key as? String{
                        if postKey == "userImagePath" {
                            let userImage = snap.value as! String
                            self.setUserImage(url: "UsersImages/\(userImage)" , imageholder: imageholder)
                        }
                    }
                }
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////
    
    
    func CreateDBUser(uid:String , userData:Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func UploadPost(withMessage message:String, forUID uid:String, withGroupKey groupKey:String?, sendComplete: @escaping (_ status:Bool)->()){
        if groupKey != nil {
            // send to custom group
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content":message, "senderID":uid])
            sendComplete(true)
        }else {
            REF_FEED.childByAutoId().updateChildValues(["content" : message, "senderID" : uid])
            sendComplete(true)
        }
    }
    
    func getUsername(forUID uid : String, handler: @escaping (_ Username:String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "Email").value as! String)
                }
            }
        }
    }
    
    func getUserimage(forUID uid : String, handler: @escaping (_ Userimagepath:String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "userImagePath").value as! String)
                }
            }
        }
    }
    
    
    func getAllFeeds(handler: @escaping (_ messages: [Message]) -> ()){
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for message in feedMessageSnapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderID: senderId)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    
    func getAllMessagesfor(desiredgroup:Group , handler:@escaping (_ groupMessage:[Message])->()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredgroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for groupMessage in groupMessageSnapshot{
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderID: senderId)
                groupMessageArray.append(message)
            }
            handler(groupMessageArray)
        }
    }
    
    func getEmail(forSearchQuery query:String, handler: @escaping (_ emailArray: [String])->()){
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "Email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsername usernames:[String], handler: @escaping (_ uidArray : [String])->()){
        var idArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "Email").value as! String
                if usernames.contains(email){
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmailsfor(group:Group , handler: @escaping (_ emailsArray:[String])->()){
        var emailsArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "Email").value as! String
                emailsArray.append(email)
            }
        }
            handler(emailsArray)
    }
    }
    
    func CreateGroup(withTitle title:String, andDescription description:String, forUserids ids:[String], handler: @escaping (_ created:Bool)->()){
        REF_GROUPS.childByAutoId().updateChildValues(["title" : title, "description" : description, "members" : ids])
        handler(true)
        
    }
    
    func getAllGroups(handler: @escaping (_ groupArray:[Group])->()){
        
        var groupArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapshot{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                let title = group.childSnapshot(forPath: "title").value as! String
                let description = group.childSnapshot(forPath: "description").value as! String
                let group = Group(title: title, desc: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                groupArray.append(group)
            }
        }
        handler(groupArray)
    }
    }
}

