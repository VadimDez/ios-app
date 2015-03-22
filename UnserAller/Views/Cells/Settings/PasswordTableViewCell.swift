//
//  PasswordTableViewCell.swift
//  UnserAller
//
//  Created by Vadim Dez on 21/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {

    @IBOutlet weak var actualPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatNewPassword: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     *  Clear
     */
    func clear() -> Void {
        self.errorLabel.text        = ""
        self.actualPassword.text    = ""
        self.newPassword.text       = ""
        self.repeatNewPassword.text = ""
    }
}
