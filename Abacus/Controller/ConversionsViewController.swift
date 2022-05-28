//
//  ConversionsViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 25/03/2022.
//

import UIKit

let USER_DEFAULTS_MAX_COUNT = 10

class ConversionsViewController: UIViewController {
    
    @IBOutlet weak var compoundUIView: UIView!
    @IBOutlet weak var savingsUIVIew: UIView!
    @IBOutlet weak var loanUIView: UIView!
    @IBOutlet weak var mortageUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add custrom corner radius
        compoundUIView.layer.cornerRadius = 10
        savingsUIVIew.layer.cornerRadius = 10
        loanUIView.layer.cornerRadius = 10
        mortageUIView.layer.cornerRadius = 10
        
    }
    
    // MARK: - Navigation
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            if compoundUIView == touch.view{
                performSegue(withIdentifier: "openCompoundView", sender: self)
            } else if savingsUIVIew == touch.view{
                performSegue(withIdentifier: "openSavingsView", sender: self)
            } else if loanUIView == touch.view{
                performSegue(withIdentifier: "openLoanView", sender: self)
            } else if mortageUIView == touch.view{
                performSegue(withIdentifier: "openMortageView", sender: self)
            }
        }
    }
}
