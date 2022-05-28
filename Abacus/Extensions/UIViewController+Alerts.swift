//
//  UIViewController+Alerts.swift
//  Abacus
//
//  Created by Chamika Perera on 27/03/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertMessage(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

