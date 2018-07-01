//
//  GroupFeedVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/23/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var btnMessageView: UIView!
    @IBOutlet weak var sendBtnWasPressed: UIButton!
    @IBOutlet weak var MessageTextField: InsetTextField!
    
    var group:Group?
    var messageGroupArray = [Message]()
    
    func initData(forGroup group:Group){
        self.group = group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsfor(group: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesfor(desiredgroup: self.group!, handler: { (returnedMessageGroup) in
                self.messageGroupArray = returnedMessageGroup
                self.tableView.reloadData()
                
                // animation with new cells
                if self.messageGroupArray.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row:self.messageGroupArray.count - 1 , section:0) , at: .none , animated: true)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMessageView.bindToKeyboard()
        tableView.delegate=self
        tableView.dataSource=self
    }

    @IBAction func sendBtnWasTapped(_ sender: UIButton) {
        if MessageTextField.text != "" {
            DataService.instance.UploadPost(withMessage: MessageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (completed) in
                if completed{
                    self.MessageTextField.text = ""
                }
            })
        }
    }
    
    @IBAction func backBtnWasTapped(_ sender: UIButton) {
        dismissDetail()
    }
    
}


extension GroupFeedVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageGroupArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFeedCell", for: indexPath) as? GroupFeedCell else {return UITableViewCell()}
        let message = messageGroupArray[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderID) { (email) in
            cell.configureCell(email: email , content:message.content )
        }
        DataService.instance.getUserimage(forUID: message.senderID) { (returneduserimage) in
            DataService.instance.loadImageFromFirebase(userUID: message.senderID, imageholder: cell.profileImage)
        }
        return cell
    }
}
