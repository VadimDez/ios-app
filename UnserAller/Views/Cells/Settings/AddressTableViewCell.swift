//
//  AddressTableViewCell.swift
//  UnserAller
//
//  Created by Vadym on 20/04/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(address: Dictionary<String, AnyObject>) {
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
