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
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailButton: RoundButton!
    
    @IBOutlet weak var facebookButton: RoundButton!
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: RoundButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressField.delegate = self
        passwordField.delegate = self
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        self.view.addGestureRecognizer(keyboardRecognizer)
        keyboardRecognizer.cancelsTouchesInView = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(uid: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if let email = emailAddressField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("User authenticated email with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        
                        self.completeSignIn(uid: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error == nil {
                            print("User account successfully created with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(uid: user.uid, userData: userData)
                            }
                        } else {
                            print("Account creation failed")
                            
                        }
                    })
                }
            })
        }
        
        
    }
    
    func completeSignIn(uid: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: uid, userData: userData)
        let saveSuccessful: Bool = KeychainWrapper.standard.set(uid, forKey: KEY_UID)
        print("Data successfully saved to the keychain : \(saveSuccessful)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}

