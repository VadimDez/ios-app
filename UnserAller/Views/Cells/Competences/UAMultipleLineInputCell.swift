//
//  UAMultioleLineInputCell.swift
//  UnserAller
//
//  Created by Vadym on 09/08/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAMultipleLineInputCell: UACompetenceCell, UITextViewDelegate {
    
    @IBOutlet weak var input: UITextView!

    override func setupCell(competence: UACompetence) {
        self.competence = competence
        self.input.delegate = self
        self.contentLabel.text = competence.content
        
        // set placeholder
        
        // set border
        self.input.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        self.input.layer.borderWidth = 1.0
        self.input.layer.cornerRadius = 5
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("edited!")
        (self.competence as! UAMultilineInputCompetence).answer = self.input.text
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.input.endEditing(true)
        (self.competence as! UAMultilineInputCompetence).answer = self.input.text
        println("edited")
        super.touchesBegan(touches, withEvent: event)
    }
}
