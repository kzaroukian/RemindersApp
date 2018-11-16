//
//  Register.swift
//  RemindersApp
//
//  Created by Jamie Penzien on 11/7/18.
//  Copyright © 2018 CIS 347. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase
// for firestore referencing: https://code.tutsplus.com/tutorials/getting-started-with-cloud-firestore-for-ios--cms-30910
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet var _email: UITextField!
    @IBOutlet var _password: UITextField!
    @IBOutlet var _passwordVerify: UITextField!
    @IBOutlet var _passwordWarning: UILabel!
    //var ref: Database!
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var users: [User] = []
    // not positive what this does
    var listener : ListenerRegistration!
    var documents: [DocumentSnapshot] = []
    var error = Error
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("Users").limit(to: 50)
    }
    
    fileprivate var query : Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _passwordWarning.isHidden = true
        self.query = baseQuery()
        listener = query?.addSnapshotListener {(documents, error) in
            guard let snapchat = documents else {
                print("Error fetching data")
                return
            }
        }
        
    }
    
    @IBAction func RegisterUser(_ sender: Any) {
        var registerSuccess: Bool = false
        if _email.text != "" {
            // TODO: CHECK EMAIL DOES NOT ALREADY EXIST
            
            if _password.text != ""  && _passwordVerify.text == _password.text {
                
                Auth.auth().createUser(withEmail: _email.text!, password: _password.text!) {(user, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            print("User signed up!")
                            registerSuccess = true
                        }
                    }
                
            } else if _password.text != _passwordVerify.text {
                // Look into implementing this for when content does not pass criteria: https://stackoverflow.com/questions/28883050/swift-prepareforsegue-cancel
                _passwordWarning.isHidden = false
            }
            else{
                print("Please enter a password")
            }
        }
        if registerSuccess == true {
            self.performSegue(withIdentifier: "finishRegistrationSegue", sender: self)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishRegistrationSegue" {
            if let destVC = segue.destination.childViewControllers[0] as? MainScreenViewController {
                // open the main screen
            }
        }
    }
}
