//
//  LoanViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 27/03/2022.
//

import UIKit

let USER_DEFAULTS_KEY_LOAN = "loanHistory"

class LoanViewController: UIViewController {
    
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var numberOfPaymentsTextField: UITextField!
    @IBOutlet weak var monthlyPaymentTextField: UITextField!
    
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
    
    //Creation of a Loan object
    var loan: Loan = Loan(loanAmount: 0.0, interestRate: 0.0, paymentAmount: 0.0, numberOfPayments: 0, isNumberOfYearsButtonEnabled: true)
    
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
        if !(loanAmountTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(interestRateTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(numberOfPaymentsTextField.text?.isEmpty)! {
            counter += 1
        }
        if !(monthlyPaymentTextField.text?.isEmpty)! {
            counter += 1
        }
        return counter
    }
    
    // Resetting the text feilds
    func resetTextFields() {
        loanAmountTextField.text = ""
        interestRateTextField.text = ""
        numberOfPaymentsTextField.text = ""
        monthlyPaymentTextField.text = ""
    }
    
    // Calculate missing text field value
    @IBAction func performClaculation(_ sender: UIButton) {
        if (paymentTermChangeButton.isOn) {
            loan.isNumberOfYearsButtonEnabled = true
        } else {
            loan.isNumberOfYearsButtonEnabled = false
        }
        
        if (loanAmountTextField.text?.isEmpty)! {
            loan.interestRate = Double(interestRateTextField.text!)!
            loan.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            loan.paymentAmount = Double(monthlyPaymentTextField.text!)!
            
            loanAmountTextField.text = String(loan.calculateLoanAmount())
            
        } else if (interestRateTextField.text?.isEmpty)! {
            loan.loanAmount = Double(loanAmountTextField.text!)!
            loan.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            loan.paymentAmount = Double(monthlyPaymentTextField.text!)!
            
            interestRateTextField.text = String(loan.calculateAnnualInterestRate())
            
        } else if (numberOfPaymentsTextField.text?.isEmpty)! {
            loan.loanAmount = Double(loanAmountTextField.text!)!
            loan.interestRate = Double(interestRateTextField.text!)!
            loan.paymentAmount = Double(monthlyPaymentTextField.text!)!
            
            numberOfPaymentsTextField.text = String(loan.calculateNumberOfPayments())
            
        } else {
            loan.loanAmount = Double(loanAmountTextField.text!)!
            loan.interestRate = Double(interestRateTextField.text!)!
            loan.numberOfYears = Double(numberOfPaymentsTextField.text!)!
            
            monthlyPaymentTextField.text = String(loan.calculateMonthlyPayment())
            
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
            calculation = "Loan Amount = \(loanAmountTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nMonthly Payment = \(monthlyPaymentTextField.text!) \nNumber of Years = \(numberOfPaymentsTextField.text!)"
        } else {
            calculation = "Loan Amount = \(loanAmountTextField.text!)  \nInterest Rate = \(interestRateTextField.text!) \nMonthly Payment = \(monthlyPaymentTextField.text!) \nNumber of Payments = \(numberOfPaymentsTextField.text!)"
        }
            
        var arr = UserDefaults.standard.array(forKey: USER_DEFAULTS_KEY_LOAN) as? [String] ?? []
        
        if arr.count >= USER_DEFAULTS_MAX_COUNT {
            arr = Array(arr.suffix(USER_DEFAULTS_MAX_COUNT - 1))
        }
        
        arr.append(calculation)
        UserDefaults.standard.set(arr, forKey: USER_DEFAULTS_KEY_LOAN)
        
        showAlertMessage(message: "You Loan Conversion has been saved. Check history section for saved conversions", title: "Saved Successfully")
    }
    
    // Set button status when text value changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        checkButtonStatus()
        storeTextFieldValues()
    }
    
    // repopulates the appropriate textfields with previously used values
    func populateTextFields() {
        loanAmountTextField.text =  UserDefaults.standard.string(forKey: "loanAmountTextField")
        interestRateTextField.text =  UserDefaults.standard.string(forKey: "loanInterestRateTextField")
        monthlyPaymentTextField.text =  UserDefaults.standard.string(forKey: "loanMonthlyPaymentTextField")
        numberOfPaymentsTextField.text =  UserDefaults.standard.string(forKey: "loanNumberOfPaymentsTextField")
    }
    
    // Stores all the textfield values for their default key
    func storeTextFieldValues() {
        UserDefaults.standard.set(loanAmountTextField.text, forKey: "loanAmountTextField")
        UserDefaults.standard.set(interestRateTextField.text, forKey: "loanInterestRateTextField")
        UserDefaults.standard.set(monthlyPaymentTextField.text, forKey: "loanMonthlyPaymentTextField")
        UserDefaults.standard.set(numberOfPaymentsTextField.text, forKey: "loanNumberOfPaymentsTextField")
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
