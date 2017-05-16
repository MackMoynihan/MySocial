//
//  FeedCell.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/14/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
class FeedCell: UITableViewCell {

    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var like: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeCount: UILabel!
    
    var post: Post!
    
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        tap.isEnabled = true
        like.addGestureRecognizer(tap)
        like.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func likeTapped() {
        likesRef.observeSingleEvent(of: .value, with: { (snap) in
            if let _ = snap.value as? NSNull {
                self.like.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.like.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
            
        })
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
         likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.textView.text = post.caption
        self.likeCount.text = "\(post.likes)"
        
        self.postLbl.text = post.username
        if post.userImgURL != nil {
            let urlString = post.userImgURL!
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async {
                    self.profilePic.image = UIImage(data: data!)
                }
            }.resume()
        }
        
        
        if img != nil {
            self.img.image = img
        } else {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase Storage")
                } else {
                    print("Successfully downloaded image from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.img.image = img
                            SocialVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
                
                
            
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snap) in
            if let _ = snap.value as? NSNull {
                self.like.image = UIImage(named: "empty-heart")
            } else {
                self.like.image = UIImage(named: "filled-heart")
            }
        })
        
    }

}
