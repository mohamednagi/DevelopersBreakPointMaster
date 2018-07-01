//
//  FirstViewController.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    @IBOutlet weak var tableView: UITableView!
    var messagesArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.getAllFeeds { (returnedMessageArray) in
            self.messagesArray = returnedMessageArray.reversed()
            self.tableView.reloadData()
        }
    }
}

extension FeedVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else{return UITableViewCell()}
        let message = messagesArray[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderID) { (returnedusername) in
            cell.ConfigureCell(mail: returnedusername, content: message.content)
        }
        DataService.instance.getUserimage(forUID: message.senderID) { (returneduserimage) in
            DataService.instance.loadImageFromFirebase(userUID: message.senderID, imageholder: cell.ProfileImage)
        }
        return cell
    }
}

