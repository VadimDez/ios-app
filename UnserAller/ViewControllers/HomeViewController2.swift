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
        
        var transitionData: AnyObject = self.transitions.all[3];
        var transition: ECSlidingViewControllerDelegate = transitionData["transition"] as ECSlidingViewControllerDelegate;
        self.slidingViewController().delegate = transition;
        self.transitions.dynamicTransition.slidingViewController = self.slidingViewController();
//        self.slidingViewController().topViewAnchoredGesture = [self.dynamicTransitionPanGesture];
        
    }
    
}