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
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}
