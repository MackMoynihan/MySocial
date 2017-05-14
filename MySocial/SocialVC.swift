//
//  SocialVC.swift
//  MySocial
//
//  Created by Mack Moynihan on 5/13/17.
//  Copyright © 2017 Mack Moynihan. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class SocialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MACK: Successfully signed out of keychain : \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    

    

}
