//
//  HomeViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class HomeViewController : UIViewController {

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    

    @IBAction func showMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}