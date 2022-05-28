//
//  SavingsViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import UIKit

let USER_DEFAULTS_KEY_SAVINGS = "savingsHistory"

class SavingsViewController: UIViewController {

    @IBOutlet weak var presentValueTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var compoundPerYearTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var numberOfYearsTextField: UITextField!
    @IBOutlet weak var paymentValueTextField: UITextField!
    
    
    @IBOutlet weak var calculateTime: UILabel!
    
    @IBOutlet weak var timeChangingButton: UISwitch!
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
    
    //Creation of a Savings object
    var savings: Savings = Savings(presentValue: 0.0, interestRate: 0.0, payment: 0.0, compoundsPerYear: 12, futureValue: 0.0, totalNumberOfPayments: 0.0, isNumberOfYearsButtonEnabled: true)
    
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
                contentInset.bottom = keyboard.size.height - 75
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
        if checkEmptyTexFields() == 4 {
            calculateButton.isEnabled = true
        } else {
            calculateButton.isEnabled = false
        }
        if checkEmptyTexFields() == 5 {
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
        if !(paymentValueTextField.text?.isEmpty)! {
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
        paymentValueTextField.text = ""
    }
    
    //Changes the label according to the switch movements
    @IBAction func performTimeChange(_ sender: UISwitch) {
        if(timeChangingButton.isOn) {
            calculateTime.text = "End of Month"
        } else {
            calculateTime.text = "Beginning of Month"
        }
    }
    
    // Calculate missing text field value
    @IBAction func performClaculation(_ sender: UIButton) {
        if (paymentTermChangeButton.isOn) {
            savings.isNumberOfYearsButtonEnabled = true
        } else {
            savings.isNumberOfYearsButtonEnabled = false
        }
        
        if (calculateTime.text) == "End of Month" {
            if (presentValueTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                presentValueTextField.text = String(savings.calculateEndPrincipalAmount())
                
                
            } else if (interestRateTextField.text?.isEmpty)! {
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                
                interestRateTextField.text = String(savings.calculateInterest())
                
                
            } else if (futureValueTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                futureValueTextField.text = String(savings.calculateEndFutureValue())
                
                
            } else if (numberOfYearsTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                
                numberOfYearsTextField.text = String(savings.calculateEndNumberOfPayments())
                
                
            } else{
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                paymentValueTextField.text = String(savings.calculateEndPayment())
                
                
            }
        } else {
            if (presentValueTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                presentValueTextField.text = String(savings.calculateBeginningPrincipalAmount())
                
                
            } else if (interestRateTextField.text?.isEmpty)! {
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                
                interestRateTextField.text = String(savings.calculateInterest())
                
                
            } else if (futureValueTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                futureValueTextField.text = String(savings.calculateBeginningFutureValue())
                
                
            } else if (numberOfYearsTextField.text?.isEmpty)! {
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.payment = Double(paymentValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                
                numberOfYearsTextField.text = String(savings.calculateBeginningNumberOfPayments())
                
                
            } else{
                savings.interestRate = Double(interestRateTextField.text!)!
                savings.futureValue = Double(futureValueTextField.text!)!
                savings.presentValue = Double(presentValueTextField.text!)!
                savings.totalNumberOfPayments = Double(numberOfYearsTextField.text!)!
                
                paymentValueTextField.text = String(savings.calculateBeginningPayment())
                
                
            }
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
            calculation = "Present Value = \(presentValueTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nNumber of Compound Per Year = \(compoundPerYearTextField.text!) \nFuture Value = \(futureValueTextField.text!) \nNumber of Years = \(numberOfYearsTextField.text!) \nPayment Value = \(paymentValueTextField.text!)"
        } else {
            calculation = "Present Value = \(presentValueTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nNumber of Compound Per Year = \(compoundPerYearTextField.text!) \nFuture Value = \(futureValueTextField.text!) \nNumber of Payments = \(numberOfYearsTextField.text!) \nPayment Value = \(paymentValueTextField.text!)"
        }
        
        
        var arr = UserDefaults.standard.array(forKey: USER_DEFAULTS_KEY_SAVINGS) as? [String] ?? []
        
        if arr.count >= USER_DEFAULTS_MAX_COUNT {
            arr = Array(arr.suffix(USER_DEFAULTS_MAX_COUNT - 1))
        }
        
        arr.append(calculation)
        UserDefaults.standard.set(arr, forKey: USER_DEFAULTS_KEY_SAVINGS)
        
        showAlertMessage(message: "Your Saving Conversion has been saved. Check history section for saved conversions", title: "Saved Successfully")
    }
    
    // Set button status when text value changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        checkButtonStatus()
        storeTextFieldValues()
    }
    
    // repopulates the appropriate textfields with previously used values
    func populateTextFields() {
        presentValueTextField.text =  UserDefaults.standard.string(forKey: "savingspresentValueTextField")
        interestRateTextField.text =  UserDefaults.standard.string(forKey: "savingsinterestTextField")
        paymentValueTextField.text =  UserDefaults.standard.string(forKey: "savingspaymentTextField")
        futureValueTextField.text =  UserDefaults.standard.string(forKey: "savingsfutureValueTextField")
        numberOfYearsTextField.text =  UserDefaults.standard.string(forKey: "savingstotalNoOfPaymentsTextField")
    }
    
    // Stores all the textfield values for their default key
    func storeTextFieldValues() {
        UserDefaults.standard.set(presentValueTextField.text, forKey: "savingspresentValueTextField")
        UserDefaults.standard.set(interestRateTextField.text, forKey: "savingsinterestTextField")
        UserDefaults.standard.set(paymentValueTextField.text, forKey: "savingspaymentTextField")
        UserDefaults.standard.set(futureValueTextField.text, forKey: "savingsfutureValueTextField")
        UserDefaults.standard.set(numberOfYearsTextField.text, forKey: "savingstotalNoOfPaymentsTextField")
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
