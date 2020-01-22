//
//  FirebaseManager.swift
//  AntColony
//
//  Created by Adis Mulabdic on 11/01/2020.
//  Copyright © 2020 Adis Mulabdic. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseManager {
    
    // pure helper, disable instantiation
    private init() {}
    
    static func signUpUserWith(_ email: String, _ password: String, _ fullName: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
            //For better usage, we should return in completion, correct error so we can display it to the user!
            if let _ = result?.user {
                // User successfully created
                updateProfile(fullName)
                completionBlock(true)
            } else {
                // User creation failed
                completionBlock(false)
            }
        }
    }
    
    static func signInUserWith(_ email: String, _ password: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        }
    }
    
    static func signWith(_ token: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: token)) { (result, error) in
            if error == nil {
                completionBlock(true, nil)
            } else {
                if let err = error {
                    completionBlock(false, err)
                }
            }
        }
    }
    
    private static func updateProfile(_ fullName: String) {
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = fullName
        request?.commitChanges(completion: { (error) in
            if error == nil {
                self.updateProfile(fullName)
            } else {
                print(error?.localizedDescription ?? "")
            }
        })
    }
    
    private func saveProfile(_ username: String) {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users/profile/\(userID)")
        let value = [
            "username": username
            ] as [String: Any]
        ref.setValue(value) { (error, refernce) in
            if error == nil {
                print("Profile saved")
            }
        }
    }
    
    static func post(_ text: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let profileName = Auth.auth().currentUser?.displayName else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let post = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid": uid,
                "username": profileName
            ],
            "text": text,
            "timestamp": [".sv":"timestamp"]
            ] as [String:Any]
        
        post.setValue(postObject) { (error, reference) in
            if error == nil {
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        }
    }
    
    static func observePost(completionBlock: @escaping (_ feeds: [Feed]) -> Void) {
        let postsReference = Database.database().reference().child("posts")
        postsReference.observe(.value) { (data) in
            var tempData = [Feed]()
            for item in data.children {
                if let snapshot = item as? DataSnapshot,
                    let dict = snapshot.value as? [String: Any],
                    let author = dict["author"] as? [String: Any],
                    let uid = author["uid"] as? String,
                    let name = author["username"] as? String,
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let feed = Feed(name: name, postText: text, uid: uid, time: timestamp, numberOfLikes: 0, isLiked: false)
                    tempData.append(feed)
                }
            }
            completionBlock(tempData.reversed())
        }
    }
}
