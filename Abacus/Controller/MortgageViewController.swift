//
//  MortgageViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import UIKit

let USER_DEFAULTS_KEY_MORTGAGE = "mortgageHistory"

class MortgageViewController: UIViewController {
    
    @IBOutlet weak var mortageAmountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var numberOfPaymentsTextField: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    
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
    
    ///Creation of a Mortgage object
    var mortgage: Mortgage = Mortgage(mortgageAmount: 0.0, interestRate: 0.0, paymentAmount: 0.0, numberOfYears: 0.0, isNumberOfYearsButtonEnabled: true)
    
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
        if !(mortageAmountTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(interestRateTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(numberOfPaymentsTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(paymentTextField.text?.isEmpty)! {
            counter += 1
        }
        return counter
    }
    
    // Resetting the text feilds
    func resetTextFields() {
        mortageAmountTextField.text = ""
        interestRateTextField.text = ""
        numberOfPaymentsTextField.text = ""
        paymentTextField.text = ""
    }
    
    // Calculate missing text field value
    @IBAction func performClaculation(_ sender: UIButton) {
        if (paymentTermChangeButton.isOn) {
            mortgage.isNumberOfYearsButtonEnabled = true
        } else {
            mortgage.isNumberOfYearsButtonEnabled = false
        }
        
        if (mortageAmountTextField.text?.isEmpty)! {
            mortgage.interestRate = Double(interestRateTextField.text!)!
            mortgage.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            mortgage.paymentAmount = Double(paymentTextField.text!)!
            
            mortageAmountTextField.text = String(mortgage.calculateLoanAmount())
            
        } else if (interestRateTextField.text?.isEmpty)! {
            mortgage.mortgageAmount = Double(mortageAmountTextField.text!)!
            mortgage.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            mortgage.paymentAmount = Double(paymentTextField.text!)!
            
            interestRateTextField.text = String(mortgage.calculateAnnualInterestRate())
            
        } else if (numberOfPaymentsTextField.text?.isEmpty)! {
            mortgage.mortgageAmount = Double(mortageAmountTextField.text!)!
            mortgage.interestRate = Double(interestRateTextField.text!)!
            mortgage.paymentAmount = Double(paymentTextField.text!)!
            
            numberOfPaymentsTextField.text = String(mortgage.calculateNumberOfYears())
            
        } else {
            mortgage.mortgageAmount = Double(mortageAmountTextField.text!)!
            mortgage.interestRate = Double(interestRateTextField.text!)!
            mortgage.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            
            paymentTextField.text = String(mortgage.calculateMonthlyPayment())
            
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
            calculation = "Mortgage Amount = \(mortageAmountTextField.text!) \nInterest Rate = \(interestRateTextField.text!) \nMonthly Payment = \(paymentTextField.text!) \nNumber of Years = \(numberOfPaymentsTextField.text!)"
        } else {
            calculation = "Mortgage Amount = \(mortageAmountTextField.text!) \nInterest Rate = \(interestRateTextField.text!) \nMonthly Payment = \(paymentTextField.text!) \nNumber of Payments = \(numberOfPaymentsTextField.text!)"
        }
        
        var arr = UserDefaults.standard.array(forKey: USER_DEFAULTS_KEY_MORTGAGE) as? [String] ?? []
        
        if arr.count >= USER_DEFAULTS_MAX_COUNT {
            arr = Array(arr.suffix(USER_DEFAULTS_MAX_COUNT - 1))
        }
        
        arr.append(calculation)
        UserDefaults.standard.set(arr, forKey: USER_DEFAULTS_KEY_MORTGAGE)
        
        showAlertMessage(message: "You Mortgage Conversion has been saved. Check history section for saved conversions", title: "Saved Successfully")
    }
    
    // Set button status when text value changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        checkButtonStatus()
        storeTextFieldValues()
    }
    
    // repopulates the appropriate textfields with previously used values
    func populateTextFields() {
        mortageAmountTextField.text =  UserDefaults.standard.string(forKey: "mortageAmountTextField")
        interestRateTextField.text =  UserDefaults.standard.string(forKey: "mortageInterestRateTextField")
        paymentTextField.text =  UserDefaults.standard.string(forKey: "mortagePaymentTextField")
        numberOfPaymentsTextField.text =  UserDefaults.standard.string(forKey: "mortageNumberOfPaymentsTextField")
    }
    
    // Stores all the textfield values for their default key
    func storeTextFieldValues() {
        UserDefaults.standard.set(mortageAmountTextField.text, forKey: "mortageAmountTextField")
        UserDefaults.standard.set(interestRateTextField.text, forKey: "mortageInterestRateTextField")
        UserDefaults.standard.set(paymentTextField.text, forKey: "mortagePaymentTextField")
        UserDefaults.standard.set(numberOfPaymentsTextField.text, forKey: "mortageNumberOfPaymentsTextField")
    }
    
    // Payement term chnaging button function
    @IBAction func performPaymentTermChange(_ sender: UISwitch) {
        numberOfPaymentsTextField.text = ""
        checkButtonStatus()
        if(paymentTermChangeButton.isOn) {
            payemtTermLabel.text = "Number of Years"
        } else {
            payemtTermLabel.text = "Number of Payments"
        }
    }
}
