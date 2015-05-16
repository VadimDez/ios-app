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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = self.string

        self.registerNotifications()        
        self.textView.becomeFirstResponder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeObservers()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        self.textView.resignFirstResponder()
        self.delegate!.passTextBack(self, string: self.textView.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            if let keyboardHeight = endFrame?.size.height {
                self.bottomConstraint.constant -= keyboardHeight
                
                UIView.animateWithDuration(duration, delay: NSTimeInterval(0), options: animationCurve, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            
            self.bottomConstraint.constant = endFrame?.size.height ?? 0.0
            self.bottomConstraint.constant += 10.0
            
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: { self.view.layoutIfNeeded() },
                completion: nil)
        }
    }
}
