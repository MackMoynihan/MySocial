//
//  Post.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/15/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import Foundation

class Post {
    private var _caption: String!
    private var _likes: Int!
    private var _imageURL: String!
    private var _postKey: String!
    
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
    }
}
