//
//  shadowView.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/17/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit

class shadowView: UIView {

    override func awakeFromNib (){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.75
        super.awakeFromNib()
    }
}
