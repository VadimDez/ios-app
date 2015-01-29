//
//  UACompanyViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 20/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UACompanyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var projectsTable: UITableView!
    @IBOutlet weak var companyImage: UIImageView!
    
    // vars
    var company: UACompany!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projectsTable.delegate = self
        self.projectsTable.dataSource = self

        self.getCompanyWithProjects({ () -> Void in
            self.loadCompanyImage()
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

    
    
    // MARK: table view delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.company.projects.count
    }
    
    
    
    // MARK: load functions
    
    /**
    Load company with projects
    
    :param: success success function
    */
    func getCompanyWithProjects(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/company/get/"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["id": self.company.id])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
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
    
    func loadCompanyImage() {
        // load profile image
        
        var url = "https://\(APIURL)/media/scale/\(self.company.imageHash)/180/320";
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
//        self.companyImage.setImageWithURLRequest(request, placeholderImage: nil, success: { (_request, _response, _image) -> Void in
//            // code
//            self.companyImage.image = _image
//        }) { (_req, _res, _error) -> Void in
//            // code
//        }
//        println(request)
//        self.companyImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
//            // test
//            if let weakSelf = self {
//                weakSelf.companyImage.image = image
//            }
//            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
//                
//        }
        
//        Alamofire.request(.GET, url).responseImage() {
//            (request, _, image, error) in
//            if error == nil && image != nil {
//                if request.URLString == cell.request?.request.URLString {
//                    cell.imageView.image = image
//                }
//            }
//        
//        Alamofire.request(.GET, url).validate().responseImage() {
//            (_, _, image, error) in
//            
//            if error == nil && image != nil {
//                self.imageView.image = image
//                self.imageView.frame = self.centerFrameFromImage(image)
//                
//                self.spinner.stopAnimating()
//                
//                self.centerScrollViewContents()
//            }
//        }
    }
}
