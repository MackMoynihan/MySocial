//
//  FeedCell.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/14/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
import FirebaseStorage
class FeedCell: UITableViewCell {

    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var like: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeCount: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage? = nil){
        self.post = post
        self.textView.text = post.caption
        self.likeCount.text = "\(post.likes)"
        
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
        
    }

}
