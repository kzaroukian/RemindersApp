//
//  AddFriendViewController.swift
//  RemindersApp
//
//  Created by Kaylin Zaroukian on 12/8/18.
//  Copyright © 2018 CIS 347. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddFriendViewController: UIViewController {
    @IBOutlet weak var addFriendTextField: UITextField!
    
    var userEmail : String = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail = Auth.auth().currentUser!.email!

        // Do any additional setup after loading the view.
    }
    @IBAction func addNewFriend(_ sender: Any) {
        
        var dID : String = ""
        if (addFriendTextField.text != "") {
            var name = addFriendTextField.text!
            db.collection("Users").whereField("email", isEqualTo: userEmail).getDocuments() { (querySnap, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    for d in querySnap!.documents {
                        dID = d.documentID
                    }
                    
                    self.db.collection("Users").document(dID).updateData(["friends" : FieldValue.arrayUnion([name])]) { error in
                        if let error = error {
                            print("Error: \(error)")
                        } else {
                            print("Succesful update")
                        }
                        
                    }
                }
                
            }
            self.navigationController?.popViewController(animated:true)
        } else {
            print("no user name entered")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
