//
//  RoundButton.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/12/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet{
            setUpView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.8 {
        didSet{
            setUpView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.8 {
        didSet{
            setUpView()
        }
    }
    @IBInspectable var shadowAlpha: CGFloat = 0.8 {
        didSet{
            setUpView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: shadowAlpha).cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
}
