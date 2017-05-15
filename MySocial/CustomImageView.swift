//
//  CustomImageView.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/14/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
@IBDesignable
class CustomImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 30 {
        didSet {
            setUpView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 2.0 {
        didSet {
            setUpView()
        }
    }
    
    func setUpView() {
        layer.cornerRadius = cornerRadius
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.masksToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    

}
