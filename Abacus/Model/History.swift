//
//  History.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import UIKit

class History {
    let type: String
    let icon: UIImage
    let conversionDetails: String
    
    init(type: String, icon: UIImage, conversionDetails: String) {
        self.type = type
        self.icon = icon
        self.conversionDetails = conversionDetails
    }
    
    func getHistoryType() -> String {
        return type
    }
    
    func getHistoryIcon() -> UIImage {
        return icon
    }
    
    func getConversionHistory() -> String {
        return conversionDetails
    }
}
