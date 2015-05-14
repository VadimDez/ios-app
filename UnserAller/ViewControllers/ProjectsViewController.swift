//
//  ProjectsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1
    var entries: [UAProject] = []
    var countEntries: Int = 0
    @IBOutlet weak var searchView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTable.tableHeaderView?.hidden = true
        
        // nibs
        self.registerNibs()

        // add infinite load
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        
        // take first
        self.mainTable.triggerInfiniteScrolling()
    }
    
    func registerNibs() {
        var UAProjectCellNib = UINib(nibName: "UAProjectCell", bundle: nil)
        self.mainTable.registerNib(UAProjectCellNib, forCellReuseIdentifier: "UAProjectCell")
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if (self.mainTable.pullToRefreshView == nil) {
            // add refresh
            self.mainTable.addPullToRefreshWithActionHandler { () -> Void in
                // activity
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.refresh()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var projectViewController: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
        
        // set project id
        projectViewController.projectId = self.entries[indexPath.row].id
        
        self.navigationController?.pushViewController(projectViewController, animated: true)
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UAProjectCell = self.mainTable.dequeueReusableCellWithIdentifier("UAProjectCell") as! UAProjectCell
        
        cell.setCell(self.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let base: CGFloat = 169.0
        var companyNameHeight: CGFloat = 0.0
        let projectNameHeight = self.getTextHeight(self.entries[indexPath.row].name, width: 288, fontSize: 17.0, fontName: "Helvetica Neue")
        
        if let companyName = self.entries[indexPath.row].company!.name {
            companyNameHeight = self.getTextHeight(companyName, width: 288, fontSize: 14.0, fontName: "Helvetica Neue Thin")
        }
        
        return base + projectNameHeight + companyNameHeight
        
//        return 206
    }
    
    func getTextHeight(string: String, width: CGFloat, fontSize: CGFloat, fontName: String) -> CGFloat {
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = width
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = string
        label.font = UIFont(name: fontName, size: fontSize)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return label.frame.size.height
    }
    
    /*
     * Infite load implementation
     */
    func infiniteLoad() {
        self.page += 1
        
        self.getEntries({ () -> Void in
            
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
        }, error: { () -> Void in
            
            println("Projects infinite load error")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
        })
    }
    /*
     *  Pull to refresh implementation
     */
    func refresh() {
        self.page = 0
        self.entries = []
        self.countEntries = 0
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
        }, error: {() -> Void in
            println("Projects pull to refresh load error")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
        })
    }

    /**
     *  Load projects
     */
    func getEntries(success: () -> Void, error: () -> Void) {
        // url
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/"

        // get entries
        Alamofire.request(.GET, url, parameters: ["page": page])
            .responseJSON { (_,_,JSON,errors) in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let ProjectModelView = UAProjectViewModel()
                    
                    // get get objects from JSON
                    var array = ProjectModelView.getProjectsFromJSON(JSON?.objectForKey("projects") as! [Dictionary<String, AnyObject>])
                    
                    // merge two arrays
                    self.entries = self.entries + array
                    self.countEntries = self.entries.count
                    
                    success()
                }
        }
    }
    
    // show menu
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    /**
     * Toggle search
     */
    @IBAction func toggleSearch(sender: AnyObject) {
        let hide = !self.searchView.hidden
        self.searchView.hidden = hide
        
        if (hide) {
            self.mainTable.contentOffset.y = -64
        } else {
            self.mainTable.contentOffset.y = -105
        }
    }
}
