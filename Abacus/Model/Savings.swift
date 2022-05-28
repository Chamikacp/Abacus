//
//  Savings.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import Foundation

class Savings {
    
    var presentValue: Double
    var futureValue : Double
    var interestRate : Double
    var totalNumberOfPayments: Double
    var compoundsPerYear : Int
    var payment : Double
    var isNumberOfYearsButtonEnabled : Bool
    
    init(presentValue: Double, interestRate: Double, payment: Double, compoundsPerYear: Int, futureValue: Double, totalNumberOfPayments: Double, isNumberOfYearsButtonEnabled: Bool) {
        self.presentValue = presentValue
        self.interestRate = interestRate
        self.payment = payment
        self.compoundsPerYear = compoundsPerYear
        self.futureValue = futureValue
        self.totalNumberOfPayments = totalNumberOfPayments
        self.isNumberOfYearsButtonEnabled = isNumberOfYearsButtonEnabled
    }
    
    // Calculates end current savings value
    func calculateEndPrincipalAmount() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let principal = (self.futureValue - (self.payment * ((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds)))) / (pow(1+(decimalInterest/compounds), (compounds*numberOfYears)))
        
        if principal < 0 || principal.isNaN || principal.isInfinite {
            self.presentValue = 0;
            return self.presentValue
        } else {
            self.presentValue = principal.roundTo2()
            return self.presentValue
        }
        
    }
    
    // Calculates beginning current savings value
    func calculateBeginningPrincipalAmount() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let principal = (self.futureValue - (self.payment * ((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds)) * (1 + (decimalInterest/compounds)))) / (pow(1+(decimalInterest/compounds), (compounds*numberOfYears)))
        
        if principal < 0 || principal.isNaN || principal.isInfinite {
            self.presentValue = 0;
            return self.presentValue
        } else {
            self.presentValue = principal.roundTo2()
            return self.presentValue
        }
        
    }
    
    // Calculates end monthly deposit value
    func calculateEndPayment() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let pmt = (self.futureValue - (self.presentValue * (pow(1+(decimalInterest/compounds), (compounds*numberOfYears))))) / ((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds))
        
        if pmt < 0 || pmt.isNaN || pmt.isInfinite {
            self.payment = 0;
            return self.payment
        } else {
            self.payment = pmt.roundTo2()
            return self.payment
        }
    }
    
    // Calculates beginning monthly deposit value
    func calculateBeginningPayment() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let pmt = (self.futureValue - (self.presentValue * (pow(1+(decimalInterest/compounds), (compounds*numberOfYears))))) / (((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds)) * (1 + (decimalInterest/compounds)))
        
        if pmt < 0 || pmt.isNaN || pmt.isInfinite {
            self.payment = 0;
            return self.payment
        } else {
            self.payment = pmt.roundTo2()
            return self.payment
        }
    }
    
    // Calculates end future value
    func calculateEndFutureValue() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let a = (self.presentValue * (pow(1+(decimalInterest/compounds), (compounds*numberOfYears)))) + (self.payment * ((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds)))
        
        if a < 0 || a.isNaN || a.isInfinite {
            self.futureValue = 0;
            return self.futureValue
        } else {
            self.futureValue = a.roundTo2()
            return self.futureValue
        }
    }
    
    // Calculates beginning future value
    func calculateBeginningFutureValue() -> Double {
        let decimalInterest = self.interestRate/100
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let compounds = Double(self.compoundsPerYear)
        let a = (self.presentValue * (pow(1+(decimalInterest/compounds), (compounds*numberOfYears)))) + (self.payment * ((pow((1 + decimalInterest/compounds), (compounds*numberOfYears)) - 1) / (decimalInterest/compounds)) * (1 + (decimalInterest/compounds)))
        
        if a < 0 || a.isNaN || a.isInfinite {
            self.futureValue = 0;
            return self.futureValue
        } else {
            self.futureValue = a.roundTo2()
            return self.futureValue
        }
        
    }
    
    // Calculates end number of payments
    func calculateEndNumberOfPayments() -> Double {
        let decimalInterest = self.interestRate/100
        let compounds = Double(self.compoundsPerYear)
        let numberOfyears = (log(self.futureValue + ((self.payment*compounds)/decimalInterest)) - log(((decimalInterest*self.presentValue) + (self.payment*compounds)) / decimalInterest)) / (compounds * log(1+(decimalInterest/compounds)))
        
        if numberOfyears < 0 || numberOfyears.isNaN || numberOfyears.isInfinite {
            self.totalNumberOfPayments = 0;
            return self.totalNumberOfPayments
        } else {
            if isNumberOfYearsButtonEnabled {
                self.totalNumberOfPayments = numberOfyears.roundTo2()
            } else {
                self.totalNumberOfPayments = 12 * numberOfyears.roundTo2()
            }
            return self.totalNumberOfPayments
        }
    }
    
    // Calculates end number of payments
    func calculateBeginningNumberOfPayments() -> Double {
        let decimalInterest = self.interestRate/100
        let compounds = Double(self.compoundsPerYear)
        let numberOfyears = ((log(self.futureValue + self.payment + ((self.payment * compounds) / decimalInterest)) - log(self.presentValue + self.payment + ((self.payment * compounds) / decimalInterest))) / (compounds * log(1 + (decimalInterest / compounds))))
        
        if numberOfyears < 0 || numberOfyears.isNaN || numberOfyears.isInfinite {
            self.totalNumberOfPayments = 0;
            return self.totalNumberOfPayments
        } else {
            if isNumberOfYearsButtonEnabled {
                self.totalNumberOfPayments = numberOfyears.roundTo2()
            } else {
                self.totalNumberOfPayments = 12 * numberOfyears.roundTo2()
            }
            return self.totalNumberOfPayments
        }
    }
    
    // Calculates compound interest rate
    func calculateInterest() -> Double{
        var numberOfYears = self.totalNumberOfPayments
        if isNumberOfYearsButtonEnabled {
            numberOfYears = self.totalNumberOfPayments
        } else {
            numberOfYears = self.totalNumberOfPayments / 12
        }
        let interestRate = Double(self.compoundsPerYear) * (pow((self.futureValue / self.presentValue), (1 / (Double(self.compoundsPerYear) * numberOfYears))) - 1)
        
        if interestRate < 0 || interestRate.isNaN || interestRate.isInfinite {
            self.interestRate = 0.0;
            return self.interestRate
        } else {
            let annualInterestRate = interestRate * 100
            self.interestRate = annualInterestRate.roundTo2()
            return self.interestRate
        }
    }
}
