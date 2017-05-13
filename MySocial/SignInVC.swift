//
//  SignInVC
//  MySocial
//
//  Created by Mack Moynihan on 5/12/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailButton: RoundButton!
    
    @IBOutlet weak var facebookButton: RoundButton!
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailAddressField.isHidden = true
//        passwordField.isHidden = true
//        signInButton.isHidden = true
    }

    @IBAction func emailPressed(_ sender: Any) {
        
        //toggleSignIn()
        
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true {
                print("User cancelled Facebook authentication - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
        }
        
        
    }
    
    func firebaseAuth (_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailAddressField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("User authenticated email with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error == nil {
                            print("User account successfully created with firebase")
                        } else {
                            print("Account creation failed")
                        }
                    })
                }
            })
        }
        
        
    }
    
    func toggleSignIn() {
//        if (emailButton.titleLabel?.text == "Email") {
//            emailAddressField.isHidden = false
//            passwordField.isHidden = false
//            signInButton.isHidden = false
//            emailButton.setTitle("X", for: .normal)
//            
//            
//        } else {
//            emailAddressField.isHidden = true
//            passwordField.isHidden = true
//            signInButton.isHidden = true
//            emailButton.setTitle("Email", for: .normal)
//            
//        }
    }
    

}

