//
//  CreateGroupsVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/21/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {
    override var prefersStatusBarHidden: Bool {return true}
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var membersTextField: InsetTextField!
    @IBOutlet weak var addMembersLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DoneBtn.isHidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        membersTextField.delegate=self
        membersTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

   @objc func textFieldDidChange(){
    if membersTextField.text == "" {
        emailArray = []
        tableView.reloadData()
    }else{
        DataService.instance.getEmail(forSearchQuery: membersTextField.text!, handler: { (returnedEmailArray) in
            self.emailArray = returnedEmailArray
            self.tableView.reloadData()
        })
        
    }
    }
    
    
    @IBAction func DoneBtnWasPressed(_ sender: UIButton) {
        if titleTextField.text != "" && descriptionTextField.text != "" {
            DataService.instance.getIds(forUsername: chosenUserArray, handler: { (idsArray) in
                var idsArray = idsArray
                idsArray.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.CreateGroup(withTitle: self.titleTextField.text!, andDescription: self.descriptionTextField.text!, forUserids: idsArray, handler: { (groupCreated) in
                    if groupCreated{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("this group couldn't be created")
                    }
                })
            })
        }
    }
    
    @IBAction func CloseBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateGroupsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else {return UITableViewCell()}
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.ConfigureCell(email: emailArray[indexPath.row], isSelected: true)
        }else{
            cell.ConfigureCell(email: emailArray[indexPath.row], isSelected: false)
        }
        DataService.instance.loadImageFromFirebase(userUID: (Auth.auth().currentUser?.uid)!, imageholder: cell.profileImage)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        if !chosenUserArray.contains(cell.emailLbl.text!){
            chosenUserArray.append(cell.emailLbl.text!)
            addMembersLbl.text = chosenUserArray.joined(separator: ",")
            DoneBtn.isHidden = false
        }else{
            chosenUserArray = chosenUserArray.filter({$0 != cell.emailLbl.text})
            if chosenUserArray.count >= 1 {
                addMembersLbl.text = chosenUserArray.joined(separator: ",")
            }else{
                addMembersLbl.text = "Add Members"
                DoneBtn.isHidden=true
            }
        }
    }
}

extension CreateGroupsVC:UITextFieldDelegate{
    
}
