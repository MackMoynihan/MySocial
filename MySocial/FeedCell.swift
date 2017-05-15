//
//  FeedCell.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/14/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var like: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
