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
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var addressAddressInput: UITextField!
    @IBOutlet weak var streetAddressInput: UITextField!
    @IBOutlet weak var zipAddressInput: UITextField!
    @IBOutlet weak var cityAddressInput: UITextField!
    @IBOutlet weak var updateAddressInfo: RNLoadingButton!
    
    let genders = ["0": "Female", "1": "Male"]
    var gender: String = "1"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // set button with indicator
        self.updateAddressInfo.hideTextWhenLoading = true
        self.updateAddressInfo.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.updateAddressInfo.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
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
            self.updateGender((genderPost) ? "1" : "0")
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
    
    // set language
    func updateGender(gender: String) -> Void {
        self.gender = gender
        self.genderButton.setTitle(self.genders[gender], forState: UIControlState.Normal)
    }
}
