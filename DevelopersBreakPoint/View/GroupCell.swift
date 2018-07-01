//
//  GroupCell.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/21/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

  
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var membersCountLbl: UILabel!
    
    func ConfigureCell(title:String, description:String, members:Int){
        self.titleLbl.text = title
        self.descriptionLbl.text = description
        self.membersCountLbl.text = "\(members) members."
        
    }
    
}
