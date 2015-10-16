//
//  ProjectsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 09/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1
    var entries: [UAProject] = []
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    var selectDisabled: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nibs
        self.registerNibs()
        
        // add infinite load
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        //
        self.setupSearchView()
        
        // take first
        self.mainTable.triggerInfiniteScrolling()
        
        // delegate
        self.searchField.delegate = self
        
//        var singleTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        self.view.addGestureRecognizer(singleTapRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.refresh()
        return false
    }
    
    func registerNibs() {
        let UAProjectCellNib = UINib(nibName: "UAProjectCell", bundle: nil)
        self.mainTable.registerNib(UAProjectCellNib, forCellReuseIdentifier: "UAProjectCell")
    }
    
    func setupSearchView() {
        // hide search view
        self.searchView.hidden = true
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
        return self.entries.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.searchField.resignFirstResponder()
        
        if self.selectDisabled != -1 {
            if indexPath.row != self.selectDisabled {
                self.mainTable.deselectRowAtIndexPath(indexPath, animated: true)
            }
        } else {
            self.selectDisabled = indexPath.row
        
            let competenceService = CompetenceService()
            
            // get competences
            competenceService.getEntries(self.entries[indexPath.row].id, projectStep: 0, success: { (competences) -> Void in
                if competences.count > 0 {
                    let competenceVC = self.storyboard?.instantiateViewControllerWithIdentifier("CompetenceVC") as! CompetenceViewController
                    competenceVC.projectId = self.entries[indexPath.row].id
                    
                    self.navigationController?.pushViewController(competenceVC, animated: true)
                    
                    self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
                } else {
                    let projectViewController: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
                    
                    // set project id
                    projectViewController.projectId = self.entries[indexPath.row].id
                    
                    self.navigationController?.pushViewController(projectViewController, animated: true)
                    self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
                }
                
                self.selectDisabled = -1
                
                }) { () -> Void in
                    self.selectDisabled = -1
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UAProjectCell = self.mainTable.dequeueReusableCellWithIdentifier("UAProjectCell") as! UAProjectCell
        
        cell.setCell(self.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let base: CGFloat = 169.0
        var companyNameHeight: CGFloat = 0.0

        let projectNameHeight = self.entries[indexPath.row].name.getHeightForView(288, font: UIFont(name: "Helvetica Neue", size: 17.0)!)
        
        if let companyName = self.entries[indexPath.row].company!.name {
            companyNameHeight = companyName.getHeightForView(288, font: UIFont(name: "HelveticaNeue-Thin", size: 14.0)!)
        }
        
        return base + projectNameHeight + companyNameHeight
        
//        return 206
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
            
            print("Projects infinite load error", terminator: "")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
        })
    }
    /*
     *  Pull to refresh implementation
     */
    func refresh() {
        self.page = 0
//        self.mainTable.reloadData()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
        }, error: {() -> Void in
            print("Projects pull to refresh load error", terminator: "")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
        })
    }

    /**
     *  Load projects
     */
    func getEntries(success: () -> Void, error: () -> Void) {
        // url
        let url: String = "\(APIURL)/api/mobile/project/"
        
        Alamofire.request(.GET, url, parameters: ["page": self.page, "filter": ["searchString": self.searchField.text!]])
        .responseJSON { _, _, result -> Void in
            
            switch result {
            case .Success(let JSON):
                
                if JSON.count != 0 {
                    
                    let ProjectModelView = UAProjectViewModel()
                    
                    // get get objects from JSON
                    let array = ProjectModelView.getProjectsFromJSON(JSON.objectForKey("projects") as! [Dictionary<String, AnyObject>])
                    
                    if self.page == 0 {
                        self.entries = []
                    }
                    
                    // merge two arrays
                    self.entries = self.entries + array
                    
                    success()
                } else {
                    // error block
                    error()
                }
                
                
            case .Failure(_, let errors):
                
                // print error
                print(errors)
                // error block
                error()
            }
        }
    }
    
    // show menu
    @IBAction func showMenu(sender: AnyObject) {
        self.searchField.resignFirstResponder()
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    /**
     *  Search projects
     */
    @IBAction func searchProject(sender: AnyObject) {
        self.refresh()
    }
    
    /**
     * Toggle search
     */
    @IBAction func toggleSearch(sender: AnyObject) {
        let hide = !self.searchView.hidden
        
        self.searchView.hidden = hide
        
//        if (hide) {
//            self.mainTable.contentOffset.y = -64
//        } else {
//            self.mainTable.contentOffset.y = -105
//        }
//        
//        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
//            
//            var frame: CGRect = self.searchView.frame
//            if (hide) {
//                frame.origin.y -= 38
//            } else {
//                self.searchView.hidden = false
//                frame.origin.y += 38
//            }
//            println(frame.origin.y)
//            self.searchView.frame = frame
//        }) { (Bool) -> Void in
//            if (hide) {
//                self.searchView.hidden = true
//            }
//        }
    }
}
