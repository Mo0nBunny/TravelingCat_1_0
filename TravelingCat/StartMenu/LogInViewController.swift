//
//  LogInViewController.swift
//  TravelingCat
//
//  Created by Sirin on 27/03/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInBttn: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = userTextField.text, let password = passTextField.text, email.count > 0, password.count > 0 else {
            showAlert(message: "No user found")
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    self.showAlert(message: "There are no users with the specified account")
                } else if error._code == AuthErrorCode.wrongPassword.rawValue {
                    self.showAlert(message: "Incorrect username or password")
                } else {
                    self.showAlert(message: "Error: \(error.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            
            if let user = user {
                AuthenticationManager.sharedInstance.didLogIn(user: user)
                self.performSegue(withIdentifier: "ShowTripsFromLogIn", sender: nil)
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
        
        logInButton.layer.borderWidth = 1.2
        logInButton.layer.cornerRadius = 18
        logInButton.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        
        userTextField.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                               attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8328204751, green: 0.6845467687, blue: 0.6961924434, alpha: 1)])
        passTextField.attributedPlaceholder = NSAttributedString(string: "Password",
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
           passTextField.becomeFirstResponder()
        } else  if textField == passTextField {
             textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Traveling Cat", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    


}
