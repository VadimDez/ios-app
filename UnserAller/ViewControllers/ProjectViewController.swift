//
//  ProjectViewController.swift
//  UnserAller
//
//  Created by Vadym on 30/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var phaseCollection: UICollectionView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectCompanyName: UIButton!
    @IBOutlet weak var sendSuggestionInput: UITextField!
    @IBOutlet weak var sendSuggestionBtn: UIButton!
    @IBOutlet weak var phaseContent: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var bookmarkImage: UIImageView!

    
    var projectId: UInt = 0
    var entries: [AnyObject] = []
    var page: UInt = 0
    var actualPhaseId: UInt = 0
    var phasesArray: [UAPhase] = []
    var companyId: UInt = 0
    var bookmarked: Bool = false
    var stepId: UInt = 0
    var type: String = ""
    var active: Bool = false
    var news = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table delegates & data source
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // collection dalegate & data source
        self.phaseCollection.delegate = self
        self.phaseCollection.dataSource = self
        
        // nib
        var PhaseCellNib = UINib(nibName: "UAPhaseCell", bundle: nil)
        self.phaseCollection.registerNib(PhaseCellNib, forCellWithReuseIdentifier: "UAPhaseCell")
        
        // configure layout
        var flowLayout = UICollectionViewFlowLayout()

        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize(width: 320, height: 50)// CGSizeMake(320, 50)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        self.flowLayout = flowLayout
        self.phaseCollection.collectionViewLayout = flowLayout
        self.phaseCollection.bounces = true
        self.phaseCollection.showsHorizontalScrollIndicator = false
        self.phaseCollection.showsVerticalScrollIndicator = false
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //
        self.loadProject({ (json) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            // update project info
            self.updateProjectInfoWithDictionary(json.objectForKey("project") as Dictionary<String, AnyObject>)
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            // get phases
            self.loadPhases({ () -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                
                // check if there's at least one phase
                if (self.phasesArray.count > 0) {
                    // reload collection
                    self.phaseCollection.reloadData()
                    
                    // set first phase as actial one
                    self.actualPhaseId = self.phasesArray[0].id
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    // load phase
                    self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.updatePhase(jsonResponse)
                    }, failure: { () -> Void in
                        
                    })
                }
                
            }, error: { () -> Void in
                
            })
        }, error: { () -> Void in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    *   Update phase info
    */
    func updatePhase(jsonResponse: AnyObject) {
        //
        self.page = 0
        // get step id
        if let id = jsonResponse.objectForKey("id") as? UInt {
            self.stepId = id
        }
        
        // get step text
        var phaseText = ""
        if let shortText = jsonResponse.objectForKey("shortText") as? String {
            phaseText = "\(shortText)"
        }
        if let text = jsonResponse.objectForKey("text") as? String {
            phaseText = "\(phaseText)\(text)asd asd asd asd asd asd asd asd asda sdasd asd"
        }
        
        self.phaseContent.text = phaseText
        self.adjustTableHeader()
        
        // type
        if let type_ = jsonResponse.objectForKey("type") as? String {
            self.type = type_
        }
        
        var startDate: String = ""
        var endDate: String = ""
        
        // end date
        if (!(jsonResponse.objectForKey("endDate") is NSNull)) {
            endDate = jsonResponse.objectForKey("endDate")?.objectForKey("date") as String!
        }
        // start date
        if let start: AnyObject = jsonResponse.objectForKey("startDate") {
            startDate = start.objectForKey("date") as String!
        }
        // check active
        self.active = self.checkActive(startDate, end: endDate)
        
        // disable or enable posting suggestion
        self.sendSuggestionBtn.enabled = self.active
        self.sendSuggestionInput.enabled = self.active
        
        self.entries = []
        self.loadSuggestions({ () -> Void in
            
            }, failure: { () -> Void in
                
        })
    }

    /**
     *  Table view delegates
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    /**
     * Collection view delegates
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:UAPhaseCell = self.phaseCollection.dequeueReusableCellWithReuseIdentifier("UAPhaseCell", forIndexPath: indexPath) as UAPhaseCell
        
        if (indexPath.row == 0) {
            cell.setNewsCell()
        } else {
            cell.setPhaseName(phasesArray[indexPath.row - 1].name)
            
            let totalPhases = self.phasesArray.count
            if ((totalPhases - indexPath.row) == 0) {
                // last element
                cell.lastElement()
            }
            if ((totalPhases - indexPath.row + 1) == totalPhases) {
                // first element
                cell.firstElement()
            }
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // +1 for "NEWS"
        return phasesArray.count + 1
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size: CGSize = CGSize(width: 0, height: 50.0)
        
        if(indexPath.row == 0) {
            size.width = 70.0
        } else {
            
            // count text
            var frame: CGRect = CGRect()
            frame.size.height = 17.0
            frame.size.width = CGFloat(MAXFLOAT)
            var label: UILabel = UILabel(frame: frame)
            
            label.text = self.phasesArray[indexPath.row - 1].name
            label.font = UIFont(name: "Helvetica Neue", size: 14)
            label.numberOfLines = 1
            label.sizeToFit()
            
            
            size.width = 20.0 + label.frame.width;
        }
        return size;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            // news
            self.news = true
            self.entries = []
            
            self.loadNews({ () -> Void in
                self.mainTable.reloadData()
            })
            
        } else {
            // suggestions
            self.news = false
            // set active phase id
            self.actualPhaseId = self.phasesArray[indexPath.row - 1].id
            
            // load phase/step info
            self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                self.updatePhase(jsonResponse)
            }, failure: { () -> Void in
                
            })
        }
    }
    
    /**
     *  Get project info
     */
    func loadProject(success: (json: AnyObject) -> Void, error: () -> Void) {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/project/get/\(self.projectId)"
        
        // get entries
        Alamofire.request(.GET, url)
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println("load project error")
                    println(errors)
                    
                    error()
                } else {
                    success(json: JSON!)
                }
        }
    }
    
    /**
     * Set update project info
     */
    func updateProjectInfoWithDictionary(dictionary: Dictionary<String, AnyObject>) {
        //set the data
        if let company = dictionary["company"] as? Dictionary<String, AnyObject> {
            self.companyId = company["id"] as UInt
            
            self.projectCompanyName.setTitle(company["name"] as? String, forState: UIControlState.Normal)
        }
        self.projectName.text = dictionary["name"] as? String
        self.navigationItem.title = dictionary["name"] as? String
        
        // project image
        var imageHash: String = "new"
        if let img = dictionary["image"] as? String {
            imageHash = img
        }
        let request = NSURLRequest(URL: NSURL(string: "https://\(APIURL)/media/crop/\(imageHash)/320/188")!)

        self.projectImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            // test
            if let weakSelf = self {
                weakSelf.projectImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
        }
        
        // bookmark
        self.bookmarked = dictionary["bookmarked"] as Bool
        self.bookmarkImage.image = UIImage(named: "bookmark_32")?.tintedImageWithColor((self.bookmarked) ? UIColor.redColor() : UIColor.grayColor(), blendMode: kCGBlendModeHue)
    }
    
    /**
    *  Load phases
    */
    func loadPhases(success: () -> Void, error: () -> Void) {
        // build url
        let url: String = "https://\(APIURL)/api/mobile/project/getphases/\(self.projectId)"
        
        // get entries
        Alamofire.request(.GET, url)
            .responseJSON { (_,_,JSON,errors) in

                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println("Load phases error")
                    println(errors)
                    
                    error()
                } else {
                    let projectViewModel: UAProjectViewModel = UAProjectViewModel()

                    let array = projectViewModel.getPhasesFromJSON(JSON?.objectForKey("phases") as [Dictionary<String, AnyObject>])
                    self.phasesArray = self.phasesArray + array
                    
                    success()
                }
        }
    }
    
    /**
     *  Load phase
     */
    func loadPhase(id: UInt, success: (jsonResponse: AnyObject) -> Void, failure: () -> Void) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // build url
        let url: String = "https://\(APIURL)/api/mobile/project/getstep/\(id)"
        
        // GET
        Alamofire.request(.GET, url)
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    // print error
                    println("Load phase error")
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success(jsonResponse: JSON!)
                }
        }
    }
    
    /**
    *  Get NSDate from string
    *
    */
    func getDateFromString(string: String) -> NSDate {
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "Europe/Berlin")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.dateFromString(string)!
    }
    
    /**
     * Check active
     *
     * 3 Cases
     */
    func checkActive(start: String, end: String) -> Bool {
        let endDate: NSDate = (end.isEmpty) ? NSDate(timeIntervalSinceNow: 1000) : self.getDateFromString(end)
        let startDate: NSDate = self.getDateFromString(start)
        let now: NSDate = NSDate()
        
        if (endDate.compare(now) == NSComparisonResult.OrderedDescending && now.compare(startDate) == NSComparisonResult.OrderedDescending) {
            // end date is later than now
            return true
        } else if (endDate.compare(now) == NSComparisonResult.OrderedAscending || startDate.compare(now) == NSComparisonResult.OrderedAscending) {
            // endDate is earlier than now
            return false
        }
        // dates are the same
        return false
    }
    
    /**
     *  Adjust table view header height
     *
     */
    func adjustTableHeader() {
        var mainFrame = self.mainTable.tableHeaderView?.frame

        // count text
        var frame: CGRect = CGRect()
        frame.size.width = self.phaseContent.frame.width
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = self.phaseContent.text
        label.font = UIFont(name: "Helvetica Neue", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        // set frame height
        mainFrame?.size.height = label.frame.size.height + 290.0
        self.mainTable.tableHeaderView?.frame = mainFrame!
        self.mainTable.tableHeaderView = self.mainTable.tableHeaderView
    }
    
    /**
     * Load suggestions
     */
    func loadSuggestions(success: () -> Void, failure: () -> Void) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // build url
        let url: String = "https://\(APIURL)/api/mobile/project/suggestions"
        
        // GET
        Alamofire.request(.GET, url, parameters: ["id": self.projectId, "step": self.stepId, "order": "top", "page": self.page])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    // print error
                    println("Load suggestions error")
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    failure()
                } else {
                    let suggestionVM = UASuggestionViewModel()
                    self.entries = self.entries + suggestionVM.getSuggestionsForProjectFromJSON(JSON?.objectForKey("suggestions") as [Dictionary<String, AnyObject>], isNews: self.news, type: self.type)
                    
                    //
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    // reload table data
                    self.mainTable.reloadData()
                    
                    success()
                }
        }
    }
    
    /**
     *  Load project news
     */
    func loadNews(success: () -> Void) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // build url
        let url: String = "https://\(APIURL)/api/mobile/project/getnews"
        
        // GET
        Alamofire.request(.GET, url, parameters: ["id": self.projectId])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    // print error
                    println("Load project news error")
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                } else {
                    let newsViewModel = UANewsViewModel()
                    
                    // get news
                    self.entries = self.entries + newsViewModel.getNewsForProject(JSON as [Dictionary<String, AnyObject>])
                    //
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    // reload table data
                    self.mainTable.reloadData()
                    
                    success()
                }
        }
    }
}
