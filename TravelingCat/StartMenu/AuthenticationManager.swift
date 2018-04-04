//
//  AuthenticationManager.swift
//  TravelingCat
//
//  Created by Sirin on 03/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager: NSObject {
    
    static let sharedInstance = AuthenticationManager()
    
    var loggedIn = false
    var userName: String?
    var userId: String?
    var email: String?
    
    func didLogIn(user: User) {
        AuthenticationManager.sharedInstance.userName = user.displayName
        AuthenticationManager.sharedInstance.loggedIn = true
        AuthenticationManager.sharedInstance.userId = user.uid
        AuthenticationManager.sharedInstance.email = email
    }
}
