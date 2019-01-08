//
//  ViewControllerExtension.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 02/01/2019.
//  Copyright © 2019 Jari De Graeve. All rights reserved.
//

import Foundation
import UIKit



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
