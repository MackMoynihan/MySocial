//
//  Post.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/15/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import Foundation
import Firebase
class Post {
    private var _caption: String!
    private var _likes: Int!
    private var _imageURL: String!
    private var _username: String?
    private var _userImgURL: String?
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _date: String!
    
    var date: String {
        return _date
    }
    var username: String? {
        return _username
    }
    var userImgURL: String? {
        return _userImgURL
    }
    var caption: String {
        return _caption
    }
    var likes: Int {
        return _likes
    }
    var imageURL: String {
        return _imageURL
    }
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageURL: String, likes: Int){
        _caption = caption
        _imageURL = imageURL
        _likes = likes
    }
    init(postKey: String, postData: Dictionary<String, AnyObject>){
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
                self._caption = caption
        }
        if let likes =  postData["likes"] as? Int {
            self._likes = likes
        }
        if let imageURL = postData["imageurl"] as? String {
            self._imageURL = imageURL
        }
        if let username = postData["username"] as? String {
            self._username = username
        }
        if let userImgURL = postData["userImg"] as? String {
            self._userImgURL = userImgURL
        }
        if let date = postData["date"] as? String {
            self._date = date
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLikes(addLike: Bool){
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
}
