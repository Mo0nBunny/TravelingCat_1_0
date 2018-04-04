//
//  SingUpViewController.swift
//  TravelingCat
//
//  Created by Sirin on 29/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passView: UIView!
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextView: UITextField!
    
    @IBOutlet weak var singUpButton: UIButton!
    
    @IBAction func singUpTapped(_ sender: Any) {
        
        guard let name = userTextField.text,
            let email = emailTextField.text,
            let password = passTextView.text,
            name.count > 0,
            email.count > 0,
            password.count > 0
            else {
                showAlert(message: "Enter a name, an email and a password")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.invalidEmail.rawValue {
                    self.showAlert(message: "Enter a valid email")
                } else if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.showAlert(message: "Email already in use")
                } else {
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                self.setUserName(user: user, name: name)
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(user.uid)
                let values = ["name": name, "email": email] as [String : Any]
                usersReference.updateChildValues(values, withCompletionBlock: {
                    (error, reff) in
                    if error != nil {
                        print(error ?? "no error")
                        return
                    }
                    print("User Saved")
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userView.layer.borderWidth = 1.2
        userView.layer.cornerRadius = 18
        userView.layer.borderColor = #colorLiteral(red: 0.9119769931, green: 0.9013367891, blue: 0.9190031886, alpha: 1)
        
        passView.layer.borderWidth = 1.2
        passView.layer.cornerRadius = 18
        passView.layer.borderColor = #colorLiteral(red: 0.9119769931, green: 0.9013367891, blue: 0.9190031886, alpha: 1)
        
        emailView.layer.borderWidth = 1.2
        emailView.layer.cornerRadius = 18
        emailView.layer.borderColor = #colorLiteral(red: 0.9119769931, green: 0.9013367891, blue: 0.9190031886, alpha: 1)
        
        singUpButton.layer.borderWidth = 1.2
        singUpButton.layer.cornerRadius = 18
        singUpButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        userTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8328204751, green: 0.6845467687, blue: 0.6961924434, alpha: 1)])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8328204751, green: 0.6845467687, blue: 0.6961924434, alpha: 1)])
        passTextView.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8328204751, green: 0.6845467687, blue: 0.6961924434, alpha: 1)])
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextField {
            emailTextField.becomeFirstResponder()
        } else  if textField == emailTextField {
            passTextView.becomeFirstResponder()
        } else if textField == passTextView {
            textField.resignFirstResponder()
        }
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserName(user: User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            self.performSegue(withIdentifier: "ShowTripsFromSingUp", sender: nil)
        }
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Traveling Cat", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
