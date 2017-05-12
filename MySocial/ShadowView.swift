//
//  ShadowView.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/12/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
@IBDesignable
class ShadowView: UIView {

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        
    }
    
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    func setUpView(){
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: shadowAlpha).cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
