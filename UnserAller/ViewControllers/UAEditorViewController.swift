//
//  UAEditorViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 01/02/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class UAEditorViewController: UIViewController {    
    
    @IBOutlet weak var textView: UITextView!
    var delegate: UAEditorDelegate! = nil
    var string: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = self.string
        
        self.textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        self.textView.resignFirstResponder()
        self.delegate!.passTextBack(self, string: self.textView.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
