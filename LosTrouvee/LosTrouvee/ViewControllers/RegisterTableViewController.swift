//
//  RegisterTableViewController.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 02/01/2019.
//  Copyright © 2019 Jari De Graeve. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterTableViewController: UITableViewController {
    
    var navFromLostList = true
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSubmitButtonState()
        hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterToLogin" {
            //            if(segue.destination as! UINavigationController).viewControllers.count > 1 {
            //                self.dismiss(animated: false, completion: nil)
            //            }
            ((segue.destination as! UINavigationController).viewControllers[0] as! LoginTableViewController).navFromLostList = navFromLostList
        }else{
            (segue.destination as! ItemsTableViewController).isLostList = navFromLostList
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "SubmitRegisterSegue", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSubmitButtonState()
    }
    
    private func updateSubmitButtonState(){
        submitButton.isEnabled = validateInput()
    }
    
    private func validateInput() -> Bool{
        if passwordTextField.text == nil || passwordTextField.text!.length <= 6 {
            return false
        }
        if confirmPasswordTextField.text == nil || confirmPasswordTextField.text != passwordTextField.text {
            return false
        }
        if emailTextField.text == nil || !isValidEmail(testStr:  emailTextField.text!) {
            return false
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
