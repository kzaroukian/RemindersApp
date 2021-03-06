//
//  User.swift
//  RemindersApp
//
//  Created by Jamie Penzien on 11/5/18.
//  Copyright © 2018 CIS 347. All rights reserved.
//

import Foundation

// use this to hold data returned from firestore
struct User {
    var email: String
    var firstName: String
    var lastName: String
    var id: String
    var taskLists: Array<TaskList>
    var numTaskLists: Int
    var streakDate : Date
    var streakNum : Int
    var friends : [String]
    var profilePic : String
    init(email:String, firstName:String, lastName:String, id:String, taskLists: Array<TaskList>, numTaskLists: Int, streakDate: Date, streakNum: Int, friends: [String], profilePic: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.taskLists = taskLists
        self.numTaskLists = numTaskLists
        self.streakDate = streakDate
        self.streakNum = streakNum
        self.friends = friends
        self.profilePic = profilePic
    }
}




