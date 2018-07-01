//
//  GroupFeedCell.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/23/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell (email:String, content:String){
        self.emailLbl.text = email
        self.contentLbl.text = content
    }

}
