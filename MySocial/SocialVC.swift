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
import FacebookCore
import FBSDKLoginKit
import FBSDKCoreKit

class SocialVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    typealias JSON = [String: Any]
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: CustomTextField!

    @IBOutlet weak var imageView: CustomImageView!
    
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    
    var imageSelected = false
    
    var currentUser: User?
    var currentUserProfilePicture: UIImage?
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        keyboardRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP : \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        let providerRef = DataService.ds.REF_USER_CURRENT
        providerRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let provider = value?["provider"] as? String {
                if provider == "facebook.com" {
                    self.checkFB()
                }
                // check other providers to get current user
            }
            
        })
        
        
        
    }

    @IBAction func signOut(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MACK: Successfully signed out of keychain : \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createPost(_ sender: Any) {
        guard let message = messageTextField.text, message != "" else {
            print("Message field must not be empty upon posting")
            return
        }
        guard let img = imageView.image, imageSelected == true else {
            print("Must select image before posting")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase")
                } else {
                    print("Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageURL: url)
                    }
                    
                    
                }
            })
        }
    }
    
    func postToFirebase(imageURL: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": messageTextField.text! as AnyObject,
        "imageurl": imageURL as AnyObject,
        "likes": 0 as AnyObject,
        "username": currentUser?.username as AnyObject,
        "userImg": currentUser?.imageURL as AnyObject
        ]
        
        DataService.ds.REF_POSTS.childByAutoId().setValue(post)
        messageTextField.text = ""
        imageView.image = UIImage(named: "add-image")
        imageSelected = false
    }
    
    @IBAction func imagePickerPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell {
            if let img = SocialVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                print("Failed to retrieve image from cache")
                cell.configureCell(post: post)
            }
            
            return cell
        }
        return FeedCell()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = img
            imageSelected = true
        } else {
            print("A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    struct MyProfileRequest: GraphRequestProtocol {
        struct Response: GraphResponseProtocol {
            var fbImgURL: String?
            var fbName: String?
            var fbUserID: String?
            var currentUser: User?
            init(rawResponse: Any?) {
                // Decode JSON from rawResponse into other properties here.
                if rawResponse != nil {
                    
                    let responseDict = rawResponse as! Dictionary<String, AnyObject>
                    if let pic = responseDict["picture"] as? Dictionary<String, AnyObject> {
                        if let data = pic["data"] as? Dictionary<String, AnyObject> {
                            if let url = data["url"] as? String {
                                fbImgURL = url
                            } else {
                                print("could not find url")
                            }
                        } else {
                            print("could not find data")
                        }
                    } else {
                        print("could not find picture")
                    }
                    if let name = responseDict["name"] as? String {
                        fbName = name
                    } else {
                        print("Could not find name")
                    }
                    if let id = responseDict["id"] as? String {
                        fbUserID = id
                    } else {
                        print("Could not find user id")
                    }
                    //currentUser = User(username: fbName, imageurl: fbImgURL, userid: fbUserID)
                }
                print("MACK: ")
            }
        }
        
        var graphPath = "/me"
        var parameters: [String : Any]? = ["fields": "id, name, picture"]
        var accessToken = AccessToken.current
        var httpMethod: GraphRequestHTTPMethod = .GET
        var apiVersion: GraphAPIVersion = .defaultVersion
    }
    
    
    
    func checkFB(){
        
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.fbUserID!)")
                
                print("My name is \(response.fbName!)")
                print("My picture url is \(response.fbImgURL!)")
                self.currentUser = User(username: response.fbName!, imageurl: response.fbImgURL!, userid: response.fbUserID!)
                
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}


