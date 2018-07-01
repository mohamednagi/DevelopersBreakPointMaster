//
//  FeedCell.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/20/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
  

    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func ConfigureCell(mail:String, content:String){
        
        self.mailLbl.text = mail
        self.contentLbl.text = content
    }
    
}
