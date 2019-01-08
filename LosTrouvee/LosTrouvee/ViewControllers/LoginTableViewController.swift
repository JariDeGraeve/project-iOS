//
//  LoginTableViewController.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 02/01/2019.
//  Copyright © 2019 Jari De Graeve. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController {
    var navFromLostList = true
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToRegister" {
            // (segue.destination as! LoginTableViewController).navFromLostList = navFromLostList
//            if(segue.destination as! UINavigationController).viewControllers.count > 1 {
//                self.dismiss(animated: false, completion: nil)
//            }
            ((segue.destination as! UINavigationController).viewControllers[0] as! RegisterTableViewController).navFromLostList = navFromLostList
        }else{
            (segue.destination as! ItemsTableViewController).isLostList = navFromLostList
            guard segue.identifier == "SubmitLoginSegue" else {return}
            //register with firebase
        }
        
    }
    
    private func updateSubmitButtonState(){
        submitButton.isEnabled = validateInput()
    }
    
    private func validateInput() -> Bool{
        if passwordTextField.text == nil || passwordTextField.text!.length <= 6 {
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


