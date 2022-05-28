//
//  UIViewController+HideKeypad.swift
//  Abacus
//
//  Created by Chamika Perera on 26/03/2022.
//

import UIKit

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
