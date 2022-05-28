//
//  HistoryTableViewCell.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var historyTypeImageView: UIImageView!
    @IBOutlet weak var calculationHIstoryLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }

}
