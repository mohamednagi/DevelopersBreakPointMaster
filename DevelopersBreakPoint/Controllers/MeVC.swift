//
//  MeVC.swift
//  DevelopersBreakPoint
//
//  Created by Sierra on 5/19/18.
//  Copyright © 2018 Nagiz. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    @IBOutlet weak var ProfilePictureImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLbl: UILabel!
    var imagepicker:UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagepicker = UIImagePickerController()
        imagepicker?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailLbl.text = Auth.auth().currentUser?.email
        DataService.instance.loadImageFromFirebase(userUID: (Auth.auth().currentUser?.uid)!, imageholder: ProfilePictureImage)
    }
    
    ////////////////////////////////////////////////////
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ProfilePictureImage.image = image
        }
        imagepicker?.dismiss(animated: true, completion: nil)
        uploadImageToFirebase()
        saveImageToFirebase(userImagePath: (Auth.auth().currentUser?.uid)!)
    }
    // save image as database in firebase
    func saveImageToFirebase(userImagePath:String){
        DataService.instance.REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["userImagePath" : Auth.auth().currentUser?.uid])
    }
    
    // sava image to storage
    func uploadImageToFirebase(){
        guard let image = self.ProfilePictureImage.image else {return}
        guard let imageData = UIImageJPEGRepresentation(image, 1) else {return}
        let uploadImageRef = DataService.instance.imageReference.child("UsersImages").child((Auth.auth().currentUser?.uid)!)
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("upload finished")
        }
        uploadTask.resume()
    }
    
    ////////////////////////////////////////////////////

   
    @IBAction func SignOutBtnWasPressed(_ sender: UIButton) {
        let popupController = UIAlertController(title: "logout?", message: "are you sure you want to logout?", preferredStyle: .actionSheet)
        let popupAction = UIAlertAction(title: "lougout?", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as! AuthVC
                self.present(authVC, animated: true, completion: nil)
            }catch{
                print(error)
            }
        }
        popupController.addAction(popupAction)
        popupController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(popupController, animated: true, completion: nil)
    }
    
    @IBAction func imageBtnWasTapped(_ sender: UIButton) {
        present(imagepicker!, animated: true, completion: nil)
    }
    
}
