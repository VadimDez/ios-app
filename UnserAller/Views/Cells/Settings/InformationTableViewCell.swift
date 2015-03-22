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
    
    // address
    @IBOutlet weak var firstNameAddressInput: UITextField!
    @IBOutlet weak var lastNameAddressInput: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var addressAddressInput: UITextField!
    @IBOutlet weak var streetAddressInput: UITextField!
    @IBOutlet weak var zipAddressInput: UITextField!
    @IBOutlet weak var cityAddressInput: UITextField!
    @IBOutlet weak var updateAddressInfo: UIButton!
    
    var language: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.emailInput.enabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(settings: Dictionary<String, AnyObject>, address: Dictionary<String, AnyObject>) {
        if let firstName = settings["firstname"]?.objectForKey("value") as? String {
            self.firstNameInput.text = firstName
        }
        
        if let lastName = settings["lastname"]?.objectForKey("value") as? String {
            self.lastNameInput.text = lastName
        }
        
        if let email = settings["email"]?.objectForKey("value") as? String {
            self.emailInput.text = email
        }
        
        if let _language = settings["language"]?.objectForKey("value") as? String {
            self.language = _language
        }
        
        // address
        if let firstNamePost = address["firstname"]?.objectForKey("value") as? String {
            self.firstNameAddressInput.text = firstNamePost
        }
        
        if let lastNamePost = address["lastname"]?.objectForKey("value") as? String {
            self.lastNameAddressInput.text = lastNamePost
        }
        
        if let genderPost = address["gender"]?.objectForKey("value") as? Bool {
            self.gender.selectedSegmentIndex = (genderPost) ? 0 : 1
        }
        
        if let addressPost = address["address"]?.objectForKey("value") as? String {
            self.addressAddressInput.text = addressPost
        }
        
        if let streetPost = address["street"]?.objectForKey("value") as? String {
            self.streetAddressInput.text = streetPost
        }
        
        if let zipCodePost = address["zipCode"]?.objectForKey("value") as? String {
            self.zipAddressInput.text = zipCodePost
        }
        
        if let cityPost = address["city"]?.objectForKey("value") as? String {
            self.cityAddressInput.text = cityPost
        }
    }
}
