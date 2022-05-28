//
//  Double+RoundConversion.swift
//  Abacus
//
//  Created by Chamika Perera on 27/03/2022.
//

import UIKit

extension Double {
    
    func roundTo2() -> Double {
        let divisor = pow(10.0, 2.0)
        let rounded = (self * divisor).rounded() / divisor
        return rounded
    }
    
}

