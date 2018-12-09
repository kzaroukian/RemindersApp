//
//  TimelineTableViewController.swift
//  RemindersApp
//
//  Created by Kaylin Zaroukian on 12/8/18.
//  Copyright © 2018 CIS 347. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TimelineTableViewController: UITableViewController {
    var docID : String = ""
    var posts : [Post] = []
    var userEmail : String = ""
    var currentPost : Post = Post(content: "", userEmail: "", datePosted: Date(), postType: "", taskListName: "", taskName: "")
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Opened")
        let user = Auth.auth().currentUser
        userEmail = user!.email!
        tableView.dataSource = self
        tableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts()
        tableView.reloadData()
    }
    
    @IBAction func addFriendPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "addFriendSegue", sender: self)

    }
    
    func getPosts() {
        posts = []
        
        var friends : [String] = []
        db.collection("Users").whereField("email", isEqualTo: userEmail).getDocuments() { (querySnap, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                for d in querySnap!.documents {
                    friends = d.get("friends") as! [String]
                }
                let postCollection = self.db.collection("Posts")
                
                postCollection.getDocuments() { (querySnap, error) in
                    if let error = error {
                        print("There was an error getting Posts document: \(error)")
                    } else {
                        for d in querySnap!.documents {
                            let content = d.get("content") as! String
                            let userEmail = d.get("userEmail") as! String
                            let datePosted = d.get("datePosted") as! Date
                            let postType = d.get("postType") as! String
                            let taskName = d.get("taskName") as! String
                            let taskListName = d.get("taskListName") as! String
                            
                            // check here if userEmail is in friends
                            if friends.contains(userEmail) {
                                self.currentPost = Post(content: content, userEmail: userEmail, datePosted: datePosted, postType: postType, taskListName: taskListName, taskName: taskName)
                                self.posts.append(self.currentPost)
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                    
                }
            }
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell

        // Configure the cell...
        cell.contentLabel.text = self.posts[indexPath.row].content
        cell.usernameLabel.text = self.posts[indexPath.row].userEmail

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFriendSegue" {
            if let destVC = segue.destination as? AddFriendViewController {
                // do something
            }
        }
    }
 

}
