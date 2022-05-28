//
//  HelpViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 2022-04-14.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var typesStackView: UIStackView!
    @IBOutlet weak var howToStackView: UIStackView!
    @IBOutlet weak var equationsStackView: UIStackView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typesStackView.isHidden = false
        howToStackView.isHidden = true
        equationsStackView.isHidden = true
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        segmentedController.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    // Segemented controller function
    @IBAction func performSegmentedControls(_ sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            typesStackView.isHidden = false
            howToStackView.isHidden = true
            equationsStackView.isHidden = true
        case 1:
            typesStackView.isHidden = true
            howToStackView.isHidden = false
            equationsStackView.isHidden = true
        case 2:
            typesStackView.isHidden = true
            howToStackView.isHidden = true
            equationsStackView.isHidden = false
        default:
            break
        }
    }
}
