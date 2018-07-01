//
//  UserCell.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/21/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    var showing = false
    
    func ConfigureCell(email:String, isSelected:Bool){
        self.emailLbl.text = email
        if isSelected{
            checkImage.isHidden = false
        }else{
            checkImage.isHidden = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            if showing == false{
                checkImage.isHidden=false
                showing=true
            }else{
                checkImage.isHidden=true
                showing=false
            }
        }
    }

}
