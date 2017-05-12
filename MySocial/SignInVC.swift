//
//  SignInVC
//  MySocial
//
//  Created by Mack Moynihan on 5/12/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailButton: RoundButton!
    
    @IBOutlet weak var facebookButton: RoundButton!
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressField.isHidden = true
        passwordField.isHidden = true
        signInButton.isHidden = true
    }

    @IBAction func emailPressed(_ sender: Any) {
        
        toggleSignIn()
        
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        
        
    }
    
    func toggleSignIn() {
        if (emailButton.titleLabel?.text == "Email") {
            emailAddressField.isHidden = false
            passwordField.isHidden = false
            signInButton.isHidden = false
            emailButton.setTitle("X", for: .normal)
            
            
        } else {
            emailAddressField.isHidden = true
            passwordField.isHidden = true
            signInButton.isHidden = true
            emailButton.setTitle("Email", for: .normal)
            
        }
    }
    

}

