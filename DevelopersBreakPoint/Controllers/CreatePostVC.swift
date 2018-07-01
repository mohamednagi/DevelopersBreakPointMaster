//
//  CreatePostVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/19/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {
override var prefersStatusBarHidden: Bool {return true}
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate=self
        sendBtn.bindToKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func CloseBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendBtnWasPressed(_ sender: UIButton) {
        if textView.text != "" && textView.text != "Write SomeThing ... !!" {
            DataService.instance.UploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                if isComplete{
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print("There was an error uploading post")
                }
            })
        }
    }
}

extension CreatePostVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
