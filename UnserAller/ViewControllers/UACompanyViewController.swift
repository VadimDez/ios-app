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
        
        // register all nibs
        self.registerNibs()

        self.getCompanyWithProjects({ () -> Void in
            self.loadCompanyImage()
            
            self.projectsTable.reloadData()
        }, error: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    
    /**
    Register nibs
    */
    func registerNibs() {
        var UAProjectCellNib = UINib(nibName: "UAProjectCell", bundle: nil)
        self.projectsTable.registerNib(UAProjectCellNib, forCellReuseIdentifier: "UAProjectCell")
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
        var projectCell: UAProjectCell = self.projectsTable.dequeueReusableCellWithIdentifier("UAProjectCell") as UAProjectCell
        projectCell.setCell(self.company.projects[indexPath.row])
        return projectCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.company.projects.count
    }
    
    /**
    Did select project row
    
    :param: tableView
    :param: indexPath
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var projectViewController: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as ProjectViewController
        
        // set project id
        projectViewController.projectId = self.company.projects[indexPath.row].id
        
        self.navigationController?.pushViewController(projectViewController, animated: true)
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
        let url = "https://\(APIURL)/media/scale/\(self.company.imageHash)/180/320";
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
        self.companyImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            if let _weak = self {
                _weak.companyImage.image = image
            }
            }, failure: { [weak self]
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                
        })
        
    }
}
