//
//  UASingleLineInputCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UASingleLineInputCell: UACompetenceCell, UITextFieldDelegate {

    @IBOutlet weak var input: UITextField!
    
    override func setupCell(competence: UACompetence) {
        self.input.delegate = self
        self.competence = competence
        self.contentLabel.text = competence.content
        
        // set placeholder
//        self.input.placeholder = 
    }
    
    @IBAction func didEndEditing(sender: AnyObject) {
        (self.competence as! UASingleInputCompetence).answer = self.input.text!
    }
}
