//
//  LoginViewController.swift
//  Hydrate
//
//  Created by Soumil Datta on 5/27/20.
//  Copyright © 2020 Soumil Datta. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var WarningLabel: UILabel!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WarningLabel.text = ""
    }
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        // TODO function to check email syntax
        if let email = EmailTextField.text, let password = PasswordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                // we dont need the guard and the weak self because it is outdated
                if let e = error {
                    self.WarningLabel.text = e.localizedDescription
                } else {
                    // print("Logged In")
                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                }
            }
        }
    }
    
}
