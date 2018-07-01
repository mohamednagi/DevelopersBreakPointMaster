//
//  SecondViewController.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    @IBOutlet weak var groupTableView: UITableView!
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate=self
        groupTableView.dataSource=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (dataSnapshot) in
            DataService.instance.getAllGroups(handler: { (returnedgroupsArray) in
                self.groupsArray = returnedgroupsArray
                self.groupTableView.reloadData()
            })
        }
    }

}

extension GroupsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else {return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        cell.ConfigureCell(title: group.groupTitle , description: group.groupDesc , members: group.memberCount)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else {return}
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        presentDetail(groupFeedVC)
    }
}














