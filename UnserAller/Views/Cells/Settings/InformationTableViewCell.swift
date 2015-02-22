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
    
    // address
    @IBOutlet weak var firstNameAddressInput: UITextField!
    @IBOutlet weak var lastNameAddressInput: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var addressAddressInput: UITextField!
    @IBOutlet weak var streetAddressInput: UITextField!
    @IBOutlet weak var zipAddressInput: UITextField!
    @IBOutlet weak var cityAddressInput: UITextField!
    @IBOutlet weak var updateAddressInfo: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.emailInput.enabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(object: [Dictionary<String, AnyObject>]) {
        if let firstName = object[0]["firstname"]?.objectForKey("value") as? String {
            self.firstNameInput.text = firstName
        }
        
        if let lastName = object[0]["lastname"]?.objectForKey("value") as? String {
            self.lastNameInput.text = lastName
        }
        
        if let email = object[0]["email"]?.objectForKey("value") as? String {
            self.emailInput.text = email
        }
        
        // address
        if let firstNamePost = object[1]["firstname"]?.objectForKey("value") as? String {
            self.firstNameAddressInput.text = firstNamePost
        }
        
        if let lastNamePost = object[1]["lastname"]?.objectForKey("value") as? String {
            self.lastNameAddressInput.text = lastNamePost
        }
        
        if let genderPost = object[1]["gender"]?.objectForKey("value") as? Bool {
            self.gender.selectedSegmentIndex = (genderPost) ? 0 : 1
        }
        
        if let addressPost = object[1]["address"]?.objectForKey("value") as? String {
            self.addressAddressInput.text = addressPost
        }
        
        if let streetPost = object[1]["street"]?.objectForKey("value") as? String {
            self.streetAddressInput.text = streetPost
        }
        
        if let zipCodePost = object[1]["zipCode"]?.objectForKey("value") as? String {
            self.zipAddressInput.text = zipCodePost
        }
        
        if let cityPost = object[1]["city"]?.objectForKey("value") as? String {
            self.cityAddressInput.text = cityPost
        }
    }
}
