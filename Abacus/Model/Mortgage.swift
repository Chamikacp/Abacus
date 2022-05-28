//
//  Mortgage.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import Foundation

class Mortgage {
    
    var mortgageAmount: Double
    var interestRate : Double
    var paymentAmount : Double
    var numberOfYears : Double
    var isNumberOfYearsButtonEnabled : Bool
    
    init(mortgageAmount: Double, interestRate: Double, paymentAmount: Double, numberOfYears: Double, isNumberOfYearsButtonEnabled: Bool) {
        self.mortgageAmount = mortgageAmount
        self.interestRate = interestRate
        self.paymentAmount = paymentAmount
        self.numberOfYears = numberOfYears
        self.isNumberOfYearsButtonEnabled = isNumberOfYearsButtonEnabled
    }
    
    // Calculates the principal mortgage amount
    func calculateLoanAmount() -> Double {
        let monthlyInterestRate = self.interestRate / (12 * 100)
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = 12 * self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears
        }
        let loan = (self.paymentAmount * (pow((1 + monthlyInterestRate), numberOfMonths) - 1)) / (monthlyInterestRate * pow((1 + monthlyInterestRate), numberOfMonths))
        
        if loan < 0 || loan.isNaN || loan.isInfinite {
            self.mortgageAmount = 0.0;
            return self.mortgageAmount
        } else {
            self.mortgageAmount = loan.roundTo2()
            return self.mortgageAmount
        }
        
    }
    
    // Calculates the annual interest rate
    func calculateAnnualInterestRate() -> Double {
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = 12 * self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears
        }
        var x = 1 + (((self.paymentAmount*numberOfMonths/self.mortgageAmount) - 1) / 12)
        
        func F(_ x: Double) -> Double {
            let F = self.mortgageAmount * x * pow(1 + x, numberOfMonths) / (pow(1+x, numberOfMonths) - 1) - self.paymentAmount
            return F;
        }
        
        func F_Prime(_ x: Double) -> Double {
            let F_Prime = self.mortgageAmount * pow(x+1, numberOfMonths-1) * (x * pow(x+1, numberOfMonths) + pow(x+1, numberOfMonths) - (numberOfMonths*x) - x - 1) / pow(pow(x+1, numberOfMonths) - 1, 2)
            return F_Prime
        }
        
        while(abs(F(x)) > Double(0.000001)) {
            x = x - F(x) / F_Prime(x)
        }
        
        let I = Double(12 * x * 100)
        
        if I < 0 || I.isNaN || I.isInfinite {
            self.interestRate = 0.0;
            return self.interestRate
        } else {
            self.interestRate = I.roundTo2()
            return self.interestRate
        }
    }
    
    // Calculates the monthly payment value
    func calculateMonthlyPayment() -> Double {
        let monthlyInterestRate = self.interestRate / (12 * 100)
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = 12 * self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears
        }
        let monthlyPayment = (self.mortgageAmount * monthlyInterestRate) / (1 - (pow((1 + monthlyInterestRate), numberOfMonths * -1)))
        
        if monthlyPayment < 0 || monthlyPayment.isNaN || monthlyPayment.isInfinite {
            self.paymentAmount = 0.0;
            return self.paymentAmount
        } else {
            self.paymentAmount = monthlyPayment.roundTo2()
            return self.paymentAmount
        }
        
    }
    
    // Calculates the number of years
    func calculateNumberOfYears() -> Double {
        let monthlyInterestRate = self.interestRate / (12 * 100)
        let numberOfMonths = log((self.paymentAmount / monthlyInterestRate) / ((self.paymentAmount / monthlyInterestRate) - (self.mortgageAmount))) / log(1 + monthlyInterestRate)
        
        if numberOfMonths < 0 || numberOfMonths.isNaN || numberOfMonths.isInfinite {
            self.numberOfYears = 0.0;
            return self.numberOfYears
        } else {
            if isNumberOfYearsButtonEnabled {
                self.numberOfYears = (numberOfMonths / 12).roundTo2()
            } else {
                self.numberOfYears = (numberOfMonths).roundTo2()
            }
            return self.numberOfYears
        }
    }
    
}
