//
//  HistrotyViewController.swift
//  Abacus
//
//  Created by Chamika Perera on 28/03/2022.
//

import UIKit

class HistrotyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearHistoryButton: UIBarButtonItem!
    
    var histories = [History]()
    var conversionType = USER_DEFAULTS_KEY_LOAN
    var icon: UIImage = UIImage(named: "icon_saving")!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    
            // Chnage the conversion type according to the view controller
            if let vcs = self.navigationController?.viewControllers {
                let previousVC = vcs[vcs.count - 2]
    
                if previousVC is MortgageViewController {
                    self.tableView.rowHeight = 150
                    conversionType = USER_DEFAULTS_KEY_MORTGAGE
                    icon = UIImage(named: "icon_mortgage")!
                } else if previousVC is LoanViewController {
                    self.tableView.rowHeight = 150
                    conversionType = USER_DEFAULTS_KEY_LOAN
                    icon = UIImage(named: "icon_loan")!
                } else if previousVC is CompoundSavingsViewController {
                    self.tableView.rowHeight = 160
                    conversionType = USER_DEFAULTS_KEY_COMPOUND_SAVINGS
                    icon = UIImage(named: "icon_interest")!
                } else if previousVC is SavingsViewController {
                    self.tableView.rowHeight = 175
                    conversionType = USER_DEFAULTS_KEY_SAVINGS
                    icon = UIImage(named: "icon_saving")!
                }
            }
    
            // generate the history of the initial segement
            recallHistory(type: conversionType, icon: icon)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    
            // Handle history clear button visibility
            toggleClearHistoryVisibility()
        }
    
    // Retrieve previous conversions
    func recallHistory(type: String, icon: UIImage) {
        histories = []
        let historyList = UserDefaults.standard.value(forKey: conversionType) as? [String]
        
        if historyList?.count ?? 0 > 0 {
            for calculation in historyList! {
                let history = History(type: type, icon: icon, conversionDetails: calculation)
                histories += [history]
            }
        }
    }
    
    // Handles the visibity of the history clear button
    func toggleClearHistoryVisibility() {
        if histories.count > 0 {
            clearHistoryButton.isEnabled = true
        } else {
            clearHistoryButton.isEnabled = false
        }
    }
    
    // Clear button function
    @IBAction func clearHistoryAction(_ sender: UIBarButtonItem) {
        if histories.count > 0 {
            UserDefaults.standard.set([], forKey: conversionType)
            
            showAlertMessage(message: "The saved calculations were successfully deleted!", title: "User History Cleared")
            
            recallHistory(type: conversionType, icon: icon)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            toggleClearHistoryVisibility()
        }
    }
    
    // Sets the number of sections in table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Resrtore the table view with converions history
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if histories.count == 0 {
            self.tableView.setTableEmptyMessage("No previous conversions were found", UIColor.darkGray)
        } else {
            self.tableView.restoreTableView()
        }
        
        return histories.count
    }
    
    // Table view cell styles
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        cell.calculationHIstoryLabel.lineBreakMode = .byWordWrapping
        cell.calculationHIstoryLabel.numberOfLines = 6
        cell.calculationHIstoryLabel.text = String(histories[indexPath.row].getConversionHistory())
        cell.historyTypeImageView.image = histories[indexPath.row].getHistoryIcon()
        cell.isUserInteractionEnabled = false
        cell.contentView.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1.00)
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor(red: 47 / 255, green: 61 / 255, blue: 96 / 255, alpha: 1.00).cgColor
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
    

}
