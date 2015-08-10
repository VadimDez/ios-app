//
//  UASingleLineInputCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASingleLineInputCell: UACompetenceCell {

    @IBOutlet weak var input: UITextField!
    
    func setupCell(competence: UACompetence) {
        self.contentLabel.text = "qwe"
    }
    
    override func validate() -> Bool {
        if (self.input.text.isEmpty) {
            // show error
            return false
        }
        
        return true
    }

}
