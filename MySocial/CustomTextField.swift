//
//  CustomTextField.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/12/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
@IBDesignable
class CustomTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    func setUpView() {
        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        
    }
    override func prepareForInterfaceBuilder() {
        setUpView()
    }
    

}
