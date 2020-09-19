//
//  AppDelegate.swift
//  Messenger
//
//  Created by Nikhi on 17/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("Google SignIn failed: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else {
            return
        }
       
        print("Did signin with Google : \(user)")
        
        guard let email = user.profile.email, let firstName = user.profile.givenName, let lastName = user.profile.familyName else {
            return
        }
        DatabaseManager.shared.usersExits(with: email) { exists in
            if !exists {
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
            }
        }
        
        guard let authentication = user.authentication else {
            print("Missing Auth Objcet off of Google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, errror) in
            guard authResult != nil, error == nil else {
                print("Failed to login with Google Credential")
                return
            }
        }
        
        print("Successfully signed in with Google")
        NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google User was disconnected")
    }
    
   
    
    
}

