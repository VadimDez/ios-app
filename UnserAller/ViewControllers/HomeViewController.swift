//
//  HomeViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation

class HomeViewController : UIViewController, ECSlidingViewControllerDelegate {

    var transitions: METransitions!;
    var dynamicTransitionPanGesture: UIPanGestureRecognizer!;
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        
        var transitionData: AnyObject = self.transition().all[3];
        var transition: ECSlidingViewControllerDelegate = transitionData["transition"] as ECSlidingViewControllerDelegate;
        self.slidingViewController().delegate = transition;
        self.transitions.dynamicTransition.slidingViewController = self.slidingViewController();
        self.slidingViewController().topViewAnchoredGesture = ECSlidingViewControllerAnchoredGesture.Tapping | ECSlidingViewControllerAnchoredGesture.Custom;
        self.slidingViewController().customAnchoredGestures = [self.dynamicTransitionPanGestureFunction()];
        
        self.navigationController.view.addGestureRecognizer(self.dynamicTransitionPanGestureFunction());
    }
    
    
    
    func transition() -> METransitions {
        if(transitions) {
            return transitions;
        }
        
        transitions = METransitions();
        return transitions;
    }
    
    func dynamicTransitionPanGestureFunction() -> UIPanGestureRecognizer {
        if self.dynamicTransitionPanGesture {
            return self.dynamicTransitionPanGesture;
        }
        
        self.dynamicTransitionPanGesture = UIPanGestureRecognizer(target: self.dynamicTransitionPanGesture, action:Selector("handlePanGesture:"));
        NSLog("here2");
        return self.dynamicTransitionPanGesture;
    }
    
//    func handlePanGesture(recognizer: UIPanGestureRecognizer) -> UIPanGestureRecognizer {
//        NSLog("here");
//        var d = MEDynamicTransition();
//        d.handlePanGesture(recognizer);
//        
//        return recognizer;
//    }
    
}