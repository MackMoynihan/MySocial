//
//  User.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/15/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import Foundation

class User {
    
    private var _username: String!
    
    private var _imageURL: String!
    
    private var _userID: String!
    
    var username: String {
        return _username
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var userID: String {
        return _userID
    }
    
    init(username: String? = "No Name", imageurl: String? = "No url", userid: String? = "No ID"){
        self._username = username
        self._imageURL = imageurl
        self._userID = userid
    }
}
