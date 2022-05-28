//
//  CompoundSavingsViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 27/03/2022.
//

import UIKit

let USER_DEFAULTS_KEY_COMPOUND_SAVINGS = "compoundSavingsHistory"

class CompoundSavingsViewController: UIViewController {
    
    @IBOutlet weak var presentValueTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var compoundPerYearTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var numberOfYearsTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var payemtTermLabel: UILabel!
    @IBOutlet weak var paymentTermChangeButton: UISwitch!
    
    @IBOutlet weak var bottomButtonStack: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var contentStackTopConstraint: NSLayoutConstraint!
    var focusedTextField = UITextField()
    
    //Creation of a CompoundSavings object
    var compoundSavings: CompoundSavings = CompoundSavings(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0, numberOfYears: 0.0, compoundsPerYear: 12, isNumberOfYearsButtonEnabled: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a heght to the sroll view according to the device
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = height + 110
        scrollView.contentInset = contentInset
        
        hideKeyboardWhenTappedAround()
        populateTextFields()
        checkButtonStatus()
        bottomButtonStack.layer.cornerRadius = 20
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Obser which tracks the keyboard show event
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Finds the first responder of the keyboard
    func findFirstResponder(inView view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder {
                return subView
            }
            if let recursiveSubView = self.findFirstResponder(inView: subView) {
                return recursiveSubView
            }
        }
        return nil
    }
    
    // Add a heght to the scroll view when keyboard appear
    @objc func keyboardWillAppear(notification: NSNotification) {
        let firstResponder = findFirstResponder(inView: view)
        
        if firstResponder != nil {
            focusedTextField = firstResponder as! UITextField
            
            let activeTextFieldSuperView = focusedTextField.superview!
            
            if let info = notification.userInfo {
                let keyboard: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                let targetY = view.frame.size.height - keyboard.height - 15 - focusedTextField.frame.size.height
                let initialY = contentStack.frame.origin.y + activeTextFieldSuperView.frame.origin.y + focusedTextField.frame.origin.y
                
                if initialY > targetY {
                    let diff = targetY - initialY
                    let targetOffsetForTopConstraint = contentStackTopConstraint.constant + diff
                    view.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.contentStackTopConstraint.constant = targetOffsetForTopConstraint
                        self.view.layoutIfNeeded()
                    })
                }
                
                var contentInset: UIEdgeInsets = scrollView.contentInset
                contentInset.bottom = keyboard.size.height - 40
                scrollView.contentInset = contentInset
            }
        }
    }
    
    // Auto detecting button status
    func checkButtonStatus() {
        if checkEmptyTexFields() > 0 {
            resetButton.isEnabled = true
        } else {
            resetButton.isEnabled = false
        }
        if checkEmptyTexFields() == 3 {
            calculateButton.isEnabled = true
        } else {
            calculateButton.isEnabled = false
        }
        if checkEmptyTexFields() == 4 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    //Check empoty text fields
    func checkEmptyTexFields() -> Int {
        var counter = 0
        if !(presentValueTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(interestRateTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(futureValueTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(numberOfYearsTextField.text?.isEmpty)! {
            counter += 1
        }
        return counter
    }
    
    // Resetting the text feilds
    func resetTextFields() {
        presentValueTextField.text = ""
        interestRateTextField.text = ""
        futureValueTextField.text = ""
        numberOfYearsTextField.text = ""
    }

    // Calculate missing text field value
    @IBAction func performClaculation(_ sender: UIButton) {
        if (paymentTermChangeButton.isOn) {
            compoundSavings.isNumberOfYearsButtonEnabled = true
        } else {
            compoundSavings.isNumberOfYearsButtonEnabled = false
        }
        if (presentValueTextField.text?.isEmpty)! {
            compoundSavings.futureValue = Double(futureValueTextField.text!)!
            compoundSavings.interestRate = Double(interestRateTextField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsTextField.text!)!
            
            presentValueTextField.text = String(compoundSavings.calculatePresentValue())
            
        } else if (interestRateTextField.text?.isEmpty)! {
            compoundSavings.presentValue = Double(presentValueTextField.text!)!
            compoundSavings.futureValue = Double(futureValueTextField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsTextField.text!)!
            
            interestRateTextField.text = String(compoundSavings.calculateCompoundInterestRate())
            
        } else if (futureValueTextField.text?.isEmpty)! {
            compoundSavings.presentValue = Double(presentValueTextField.text!)!
            compoundSavings.interestRate = Double(interestRateTextField.text!)!
            compoundSavings.numberOfYears = Double(numberOfYearsTextField.text!)!
            
            futureValueTextField.text = String(compoundSavings.calculateFutureValue())
            
        } else {
            compoundSavings.presentValue = Double(presentValueTextField.text!)!
            compoundSavings.futureValue = Double(futureValueTextField.text!)!
            compoundSavings.interestRate = Double(interestRateTextField.text!)!
            
            numberOfYearsTextField.text = String(compoundSavings.calculateNumberOfYears())
            
        }
        storeTextFieldValues()
        calculateButton.isEnabled = false
        saveButton.isEnabled = true
    }
    
    // Reset button fucntion
    @IBAction func resetAllTextFields(_ sender: UIButton) {
        resetTextFields()
        storeTextFieldValues()
        checkButtonStatus()
    }
    
    // Save button function
    @IBAction func saveAllTextFields(_ sender: UIButton) {
        var calculation = ""
        if(paymentTermChangeButton.isOn) {
            calculation = "Present Value = \(presentValueTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nNumber of Compound Per Year = \(compoundPerYearTextField.text!) \nFuture Value = \(futureValueTextField.text!) \nNumber of Years = \(numberOfYearsTextField.text!)"
        } else {
            calculation = "Present Value = \(presentValueTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nNumber of Compound Per Year = \(compoundPerYearTextField.text!) \nFuture Value = \(futureValueTextField.text!) \nNumber of Payments = \(numberOfYearsTextField.text!)"
        }
        
        var arr = UserDefaults.standard.array(forKey: USER_DEFAULTS_KEY_COMPOUND_SAVINGS) as? [String] ?? []
        
        if arr.count >= USER_DEFAULTS_MAX_COUNT {
            arr = Array(arr.suffix(USER_DEFAULTS_MAX_COUNT - 1))
        }
        
        arr.append(calculation)
        UserDefaults.standard.set(arr, forKey: USER_DEFAULTS_KEY_COMPOUND_SAVINGS)
        
        showAlertMessage(message: "You Compound Saving Conversion has been saved. Check history section for saved conversions", title: "Saved Successfully")
    }
    
    // Set button status when text value changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        checkButtonStatus()
        storeTextFieldValues()
    }
    
    
    // repopulates the appropriate textfields with previously used values
    func populateTextFields() {
        presentValueTextField.text =  UserDefaults.standard.string(forKey: "compSavingspresentValueTextField")
        interestRateTextField.text =  UserDefaults.standard.string(forKey: "compSavingsinterestTextField")
        futureValueTextField.text =  UserDefaults.standard.string(forKey: "compSavingsfutureValueTextField")
        numberOfYearsTextField.text =  UserDefaults.standard.string(forKey: "compSavingsnumberOfYearsTextField")
    }
    
    // Stores all the textfield values for their default key
    func storeTextFieldValues() {
        UserDefaults.standard.set(presentValueTextField.text, forKey: "compSavingspresentValueTextField")
        UserDefaults.standard.set(interestRateTextField.text, forKey: "compSavingsinterestTextField")
        UserDefaults.standard.set(futureValueTextField.text, forKey: "compSavingsfutureValueTextField")
        UserDefaults.standard.set(numberOfYearsTextField.text, forKey: "compSavingsnumberOfYearsTextField")
    }
    
    // Payement term chnaging button function
    @IBAction func performPaymentTermChange(_ sender: UISwitch) {
        numberOfYearsTextField.text = ""
        checkButtonStatus()
        if(paymentTermChangeButton.isOn) {
            payemtTermLabel.text = "Number of Years"
        } else {
            payemtTermLabel.text = "Number of Payments"
        }
    }
}

