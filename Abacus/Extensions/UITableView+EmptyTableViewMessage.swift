//
//  UITableView+EmptyTableViewMessage.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import Foundation
import UIKit

extension UITableView {
    
    // To sets an empty message on the table view.
    func setTableEmptyMessage(_ message: String,_ messageColour: UIColor) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = messageColour
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "System", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    // To removes the empty message from the table view.
    func restoreTableView() {
        self.backgroundView = nil
    }
}
