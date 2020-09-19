//
//  ViewController.swift
//  Messenger
//
//  Created by Nikhi on 17/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        if Auth.auth().currentUser == nil {
            let newVC = LoginViewViewController()
            let nav = UINavigationController(rootViewController: newVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    
    
}

