//
//  CompoundSavings.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import Foundation

class CompoundSavings {
    
    var presentValue: Double
    var futureValue : Double
    var interestRate : Double
    var numberOfYears : Double
    var compoundsPerYear : Int
    var isNumberOfYearsButtonEnabled : Bool
    
    init(presentValue: Double, futureValue: Double, interestRate: Double, numberOfYears: Double, compoundsPerYear : Int, isNumberOfYearsButtonEnabled: Bool) {
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interestRate = interestRate
        self.numberOfYears = numberOfYears
        self.compoundsPerYear = compoundsPerYear
        self.isNumberOfYearsButtonEnabled = isNumberOfYearsButtonEnabled
    }
    
    // Calculates present savings value
    func calculatePresentValue() -> Double {
        let annualInterestRate = self.interestRate / 100
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears / 12
        }
        let principalValue = self.futureValue / pow(1 + (annualInterestRate / Double(self.compoundsPerYear)), Double(self.compoundsPerYear) * numberOfMonths)
        
       if principalValue < 0 || principalValue.isNaN || principalValue.isInfinite {
            self.presentValue = 0.0;
            return self.presentValue
        } else {
            self.presentValue = principalValue.roundTo2()
            return self.presentValue
        }
        
    }
    
    // Calculates future savings value
    func calculateFutureValue() -> Double {
        let annualInterestRate = self.interestRate / 100
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears / 12
        }
        let futureValue = self.presentValue * pow(1 + (annualInterestRate / Double(self.compoundsPerYear)), Double(self.compoundsPerYear) * numberOfMonths)
        
        if futureValue < 0 || futureValue.isNaN || futureValue.isInfinite {
            self.futureValue = 0.0;
            return self.futureValue
        } else {
            self.futureValue = futureValue.roundTo2()
            return self.futureValue
        }
        
    }
    
    // Calculates compound interest rate
    func calculateCompoundInterestRate() -> Double {
        var numberOfMonths = self.numberOfYears
        if isNumberOfYearsButtonEnabled {
            numberOfMonths = self.numberOfYears
        } else {
            numberOfMonths = self.numberOfYears / 12
        }
        let interestRate = Double(self.compoundsPerYear) * (pow((self.futureValue / self.presentValue), (1 / (Double(self.compoundsPerYear) * numberOfMonths))) - 1)
        
        if interestRate < 0 || interestRate.isNaN || interestRate.isInfinite {
            self.interestRate = 0.0;
            return self.interestRate
        } else {
            let annualInterestRate = interestRate * 100
            self.interestRate = annualInterestRate.roundTo2()
            return self.interestRate
        }
        
        
    }
    
    // Calculates future savings value
    func calculateNumberOfYears() -> Double {
        let annualInterestRate = self.interestRate / 100
        let years = log(self.futureValue / self.presentValue) / (Double(self.compoundsPerYear) * log(1 + (annualInterestRate / Double(self.compoundsPerYear))))
        
        if years < 0 || years.isNaN || years.isInfinite {
            self.numberOfYears = 0.0;
            return self.numberOfYears
        } else {
            if isNumberOfYearsButtonEnabled {
                self.numberOfYears = years.roundTo2()
            } else {
                self.numberOfYears = 12 * years.roundTo2()
            }
            return self.numberOfYears
        }
    }
}
