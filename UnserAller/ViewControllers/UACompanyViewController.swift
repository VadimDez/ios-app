//
//  UACompanyViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 20/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UACompanyViewController: UIViewController {

    @IBOutlet weak var projectCollectionView: UICollectionView!
    @IBOutlet weak var companyImage: UIImageView!
    
    // vars
    var company: UACompany!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getCompany({ () -> Void in
            
        }, error: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        toggleSideMenuView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: load functions
    /**
    *  Get projects
    */
    func getProjects(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/company/get/"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["page": 0])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil || JSON?.count == 0 || JSON?.objectAtIndex(0).count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
//                    let SuggestionModelView = UASuggestionViewModel()
                    
                    // get get objects from JSON
//                    var array = SuggestionModelView.getSuggestionsFromJSON(JSON as [Dictionary<String, AnyObject>])
                    
                    // merge two arrays
//                    self.entries = self.entries + array
                    
                    success()
                }
        }
    }
    
    func getCompany(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/company/get/"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["id": self.company.id])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    // print error
                    println("get company error")
                    // error block
                    error()
                } else {
                    self.company.setCompanyFromJSON(JSON?.objectAtIndex(0).objectForKey("company") as Dictionary<String, AnyObject>)
                    success()
                }
        }
    }
}
