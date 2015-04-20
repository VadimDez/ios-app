//
//  InformationTableViewCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 21/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var updateProfileInfo: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    
    var language: String!
    let languages: [String: String] = ["0": "Deutsch", "1": "English"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.emailInput.enabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(settings: Dictionary<String, AnyObject>) {
        if let firstName = settings["firstname"]?.objectForKey("value") as? String {
            self.firstNameInput.text = firstName
        }
        
        if let lastName = settings["lastname"]?.objectForKey("value") as? String {
            self.lastNameInput.text = lastName
        }
        
        if let email = settings["email"]?.objectForKey("value") as? String {
            self.emailInput.text = email
        }
        
        if let langDict = settings["language"] as? Dictionary<String, AnyObject> {

            if let _language = langDict["value"] as? UInt {
                self.updateLanguage("\(_language)")
            }
        }
    }
    
    // set language
    func updateLanguage(language: String) -> Void {
        self.language = language
        self.languageButton.setTitle(self.languages[language], forState: UIControlState.Normal)
    }
}
