//
//  ProjectViewController.swift
//  UnserAller
//
//  Created by Vadym on 30/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate, FloatRatingViewDelegate, UAEditorDelegate {
    
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

    var project: UAProject!
    var projectId: UInt = 0
    var entries: [UACellObject] = []
    var page: UInt = 0
    var actualPhaseId: UInt = 0
    var phasesArray: [UAPhase] = []
    var stepId: UInt = 0
    var type: String = ""
    var active: Bool = false
    var news = false
    var photos: [MWPhotoObj] = []
    var votingDisabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDelegates()
        // nib
        self.registerNibs()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil)
        
        self.configureLayout()
        
        
        self.startLoad { () -> Void in
            // check if there's at least one phase
            if (self.phasesArray.count > 0) {
                // reload collection
                self.phaseCollection.reloadData()
                
                // set first phase as actial one
                self.actualPhaseId = self.phasesArray[0].id
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                // load phase
                self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                    
                    self.updatePhase(jsonResponse, success: { () -> Void in
                        
                        self.entries = []
                        self.loadSuggestions({ () -> Void in
                            
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }, failure: { () -> Void in
                                
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        })
                    })
                    }, failure: { () -> Void in
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
            }
        }
        
        // setup infinite scrolling
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
    }
    
    /**
    Set delegates and datasources
    */
    func setDelegates() {
        // table delegates & data source
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // collection dalegate & data source
        self.phaseCollection.delegate = self
        self.phaseCollection.dataSource = self
    }
    
    /**
    Register all nibs
    */
    func registerNibs() {
        var PhaseCellNib = UINib(nibName: "UAPhaseCell", bundle: nil)
        self.phaseCollection.registerNib(PhaseCellNib, forCellWithReuseIdentifier: "UAPhaseCell")
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        var UASuggestImageCellNib = UINib(nibName: "UASuggestImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestImageCellNib, forCellReuseIdentifier: "UASuggestImageCell")
        var UANewsCellNib = UINib(nibName: "UAProjectNewsCell", bundle: nil)
        self.mainTable.registerNib(UANewsCellNib, forCellReuseIdentifier: "UAProjectNewsCell")
        var UASuggestionVoteCellNib = UINib(nibName: "UASuggestionVoteCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteCellNib, forCellReuseIdentifier: "UASuggestionVoteCell")
        var UASuggestionVoteImageCellNib = UINib(nibName: "UASuggestionVoteImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteImageCellNib, forCellReuseIdentifier: "UASuggestionVoteImageCell")

    }
    
    /**
    Configure layour for phases collection view
    */
    func configureLayout() {
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
    }
    
    /**
     *  Load and update project info, load phases
     */
    func startLoad(success: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //
        self.loadProject({ (json) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            let projectViewModel = UAProjectViewModel()
            self.project = projectViewModel.getProjectForProject(json.objectForKey("project") as! Dictionary<String, AnyObject>)
            
            // update project info
            self.updateProjectInfo()
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            // get phases
            self.loadPhases({ () -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                success()
                
                }, error: { () -> Void in
                    
            })
            }, error: { () -> Void in
                
        })
    }
    
    // MARK: INFINITE LOAD & REFRESH
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if (self.mainTable.pullToRefreshView == nil) {
            // setup pull to refresh
            self.mainTable.addPullToRefreshWithActionHandler { () -> Void in
                
                // active activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.refresh()
            }
        }
    }
    
    func refresh() {
        self.page = 0
        
        self.startLoad { () -> Void in
            if (!self.news) {
                
                // load phase
                self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                    
                        self.updatePhase(jsonResponse, success: { () -> Void in
                            self.entries = []
                            self.loadSuggestions({ () -> Void in
                                
                                self.mainTable.pullToRefreshView.stopAnimating()
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }, failure: { () -> Void in
                                
                                self.mainTable.pullToRefreshView.stopAnimating()
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            })
                        })
                    }, failure: { () -> Void in
                        
                })
                
                
            } else {
                self.loadNews({ () -> Void in
                    self.mainTable.reloadData()
                    
                    self.mainTable.pullToRefreshView.stopAnimating()
                    
                    // active activity indicator
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                })
            }
        }
        
    }
    
    /**
    *  Load next page
    */
    func infiniteLoad() {
        // increment page
        self.page += 1
        
        if (!self.news) {
            self.loadSuggestions({ () -> Void in
                // reload data
                self.mainTable.reloadData()
                
                self.mainTable.infiniteScrollingView.stopAnimating()
                
                // active activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }, failure: { () -> Void in
                    println("Project infiniteload error")
                    
                    self.mainTable.infiniteScrollingView.stopAnimating()
                    // active activity indicator
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        } else {
            self.loadNews({ () -> Void in
                self.mainTable.reloadData()
                
                self.mainTable.pullToRefreshView.stopAnimating()
                
                // active activity indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    *   Update phase info
    */
    func updatePhase(jsonResponse: AnyObject, success:() -> Void) {
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
            phaseText = "\(phaseText)\(text)"
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
            endDate = jsonResponse.objectForKey("endDate")?.objectForKey("date") as! String!
        }
        // start date
        if let start: AnyObject = jsonResponse.objectForKey("startDate") {
            startDate = start.objectForKey("date") as! String!
        }
        // check active
        self.active = self.checkActive(startDate, end: endDate)
        
        // disable or enable posting suggestion
        self.sendSuggestionBtn.enabled = self.active
        self.sendSuggestionInput.enabled = self.active
        
        success()
    }

    /**
     *  MARK: Table view delegates
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var suggestionVC: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as! UASuggestionViewController
        suggestionVC.suggestion = self.entries[indexPath.row] as! UASuggestion
        
        self.navigationController?.pushViewController(suggestionVC, animated: true)
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch self.entries[indexPath.row].cellType {
            case "SuggestionCell":          return self.getSuggestCellForRow(indexPath.row)
            case "UAProjectNewsCell":       return self.getNewsCellForRow(indexPath.row)
            case "UASuggestImageCell":      return self.getSuggestImageCellForRow(indexPath.row)
            case "UASuggestionVoteCell":        return self.getVoteCellForRow(indexPath.row)
            case "UASuggestionVoteImageCell":   return self.getVoteImageCellForRow(indexPath.row)
        default: break;
        }
        return self.defaultCell(indexPath.row)
    }
    
    /**
     *  Get suggest cell without images
     */
    func getSuggestCellForRow(row: Int) -> UASuggestionCell {
        var cell: UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as! UASuggestionCell
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
    *  Get suggest cell with image
    */
    func getSuggestImageCellForRow(row: Int) -> UASuggestImageCell {
        var cell: UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as! UASuggestImageCell
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
     *  Get project news cell
     */
    func getNewsCellForRow(row: Int) -> UAProjectNewsCell {
        var cell: UAProjectNewsCell = self.mainTable.dequeueReusableCellWithIdentifier("UAProjectNewsCell") as! UAProjectNewsCell
        cell.setCellForProjectPhase(self.entries[row] as! UANews)
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteCellForRow(row: Int) -> UASuggestionVoteCell {
        var cell: UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as! UASuggestionVoteCell
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteImageCellForRow(row: Int) -> UASuggestionVoteImageCell {
        var cell: UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as! UASuggestionVoteImageCell
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    func defaultCell(row: Int) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        cell.backgroundColor = UIColor.redColor()
        cell.textLabel?.text = "\(self.entries[row].cellType) cell is not defined"
        return cell
    }
    
    /**
     * Define height for cell
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = (news) ? 45.0 : 110.0
        
        if (self.entries.count == 0) {
            return base
        }
        
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = 290
        frame.size.height = CGFloat(MAXFLOAT)
        
        var label: UILabel = UILabel(frame: frame)
        label.text = self.entries[indexPath.row].content
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        var media:CGFloat = 0.0
        if (self.entries[indexPath.row].media.count > 0) {
            media = 50.0 + CGFloat((self.entries[indexPath.row].media.count/5) * 50)
        }
        
        return base + label.frame.size.height + media
    }
    
    /**
     * Collection view delegates
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:UAPhaseCell = self.phaseCollection.dequeueReusableCellWithReuseIdentifier("UAPhaseCell", forIndexPath: indexPath) as! UAPhaseCell
        
        if (self.phasesArray.count == 0) {
            return cell
        }
        
        if (indexPath.row == 0) {
            cell.setNewsCell()
        } else {
            cell.setPhaseName(self.phasesArray[indexPath.row - 1].name)
            
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
                self.updatePhase(jsonResponse, success: { () -> Void in
                    
                    self.entries = []
                    self.loadSuggestions({ () -> Void in
                        
                        }, failure: { () -> Void in
                            
                    })
                })
            }, failure: { () -> Void in
                
            })
        }
    }
    /**
    * MWPhotoBrowser delegates
    */
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser) -> UInt {
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhoto! {
        if (Int(index) < self.photos.count) {
            return self.photos[Int(index)];
        }
        return nil;
    }
    func didSelectItemFromCollectionView(notification: NSNotification) -> Void {
        let cellData: Dictionary<String, AnyObject> = notification.object as! Dictionary<String, AnyObject>
        self.photos = []
        if (!cellData.isEmpty) {
            
            if let medias: [UAMedia] = cellData["media"] as? [UAMedia] {
                
                for media: UAMedia in medias {
                    let photo: MWPhotoObj = MWPhotoObj.photoWithURL(NSURL(string: "\(APIPROTOCOL)://\(APIURL)/media/crop/\(media.hash)/\(media.width)/\(media.height)"))
                    self.photos.append(photo)
                }
                
                var browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
                
                browser.showPreviousPhotoAnimated(true)
                browser.showNextPhotoAnimated(true)
                browser.setCurrentPhotoIndex(cellData["actual"] as! UInt)
                self.navigationController?.pushViewController(browser, animated: false)
            }
        }
    }
    
    /**
     *  Get project info
     */
    func loadProject(success: (json: AnyObject) -> Void, error: () -> Void) {
        // build URL
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/get/\(self.projectId)"
        
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
    func updateProjectInfo() {
            
        self.projectCompanyName.setTitle(self.project.company.name, forState: UIControlState.Normal)
        self.projectName.text = self.project.name
        self.navigationItem.title = self.project.name
        
        let request = NSURLRequest(URL: NSURL(string: "\(APIPROTOCOL)://\(APIURL)/media/crop/\(self.project.imageHash)/320/188")!)

        self.projectImage.setImageWithURLRequest(request, placeholderImage: nil, success: { [weak self](request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            // test
            if let weakSelf = self {
                weakSelf.projectImage.image = image
            }
            }) { [weak self](request: NSURLRequest!, response: NSURLResponse!, error: NSError!) -> Void in
        }
        
        // bookmark
        self.bookmarkImage.image = UIImage(named: "bookmark_32")?.tintedImageWithColor((self.project.bookmarked) ? UIColor.redColor() : UIColor.grayColor(), blendMode: kCGBlendModeHue)
    }
    
    /**
    *  Load phases
    */
    func loadPhases(success: () -> Void, error: () -> Void) {
        // build url
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/getphases/\(self.projectId)"
        
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

                    let array = projectViewModel.getPhasesFromJSON(JSON?.objectForKey("phases") as! [Dictionary<String, AnyObject>])
                    
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
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/getstep/\(id)"
        
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
     * Check active
     *
     * 3 Cases
     */
    func checkActive(start: String, end: String) -> Bool {
        let endDate: NSDate = (end.isEmpty) ? NSDate(timeIntervalSinceNow: 1000) : end.getDateFromString()
        let startDate: NSDate = start.getDateFromString()
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
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/suggestions"
        
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
                    self.entries = self.entries + suggestionVM.getSuggestionsForProjectFromJSON(JSON?.objectForKey("suggestions") as! [Dictionary<String, AnyObject>], isNews: self.news, type: self.type)
                    
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
        let url: String = "\(APIPROTOCOL)://\(APIURL)/api/mobile/project/getnews"
        
        // GET
        Alamofire.request(.GET, url, parameters: ["id": self.projectId, "page": self.page])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil) {
                    // print error
                    println("Load project news error")
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                } else {
                    let newsViewModel = UANewsViewModel()
                    
                    // get news
                    self.entries = self.entries + newsViewModel.getNewsForProject(JSON as! [Dictionary<String, AnyObject>])
                    //
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    // reload table data
                    self.mainTable.reloadData()
                    
                    success()
                }
        }
    }
    
    // MARK: rating delegates
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
    }
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        
        if (!self.votingDisabled) {
            var suggestion: UASuggestion = self.entries[ratingView.tag] as! UASuggestion
            let votes: Int = (suggestion.userVotes == Int(rating)) ? 0 : Int(rating)

            // disable for a moment
            self.votingDisabled = true
            
            // TODO: check if it's own suggestion before send
            
            self.sendRating(suggestion.suggestionId, votes: votes, success: { () -> Void in
                
                (self.entries[ratingView.tag] as! UASuggestion).likeCount = suggestion.likeCount - suggestion.userVotes + votes
                
                (self.entries[ratingView.tag] as! UASuggestion).userVotes  = votes
                
                // update only changed row
                let indexPath: NSIndexPath = NSIndexPath(forRow: ratingView.tag, inSection: 0)
                self.mainTable.beginUpdates()
                self.mainTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                self.mainTable.endUpdates()
                
                self.votingDisabled = false
                }) { () -> Void in
                self.votingDisabled = false
            }
        }
    }
    
    /**
    *  Send rating
    */
    func sendRating(id: UInt, votes: Int, success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIPROTOCOL)://\(APIURL)/api/v1/suggestion/vote"
        
        Alamofire.request(.GET, url, parameters: ["id": id, "votes": votes])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("send rating error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
    
    /**
    On company button pressed
    
    :param: sender
    */
    @IBAction func showCompanyView(sender: AnyObject) {
        var companyVC: UACompanyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CompanyVC") as! UACompanyViewController
        companyVC.company = self.project.company
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    
    
    /**
    Open editor
    
    :param: sender
    */
    @IBAction func openEditor(sender: AnyObject) {
        var editor: UAEditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditorVC") as! UAEditorViewController
        
        weak var _self = self
        
        editor.setEditorTitle("New suggestion")
        editor.delegate = _self
        editor.string = self.sendSuggestionInput.text
        self.presentViewController(editor, animated: true, completion: nil)

    }
    
    func passTextBack(controller: UAEditorViewController, string: String) {
        self.sendSuggestionInput.text = string
    }
    
    @IBAction func sendNewSuggestion() {
        self.sendSuggestion({ (json) -> () in
            
            var suggestion = UASuggestion()
            self.sendSuggestionInput.text = ""
            println(json)
            if (self.type == "vote") {
                suggestion = UASuggestion().initVoteForProjectFromJSON(json, project: self.project)
            } else {
                suggestion = UASuggestion().initSuggestForProjectFromJSON(json, project: self.project)
            }
            
            var array = [suggestion]
            
            self.entries = array + self.entries
            self.mainTable.reloadData()
            
        }, failure: { () -> () in
            
        })
    }
    
    /**
    Send new suggestion
    
    :param: success func
    :param: failure func
    */
    func sendSuggestion(success: (json: AnyObject) -> (), failure: () -> ()) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIPROTOCOL)://\(APIURL)/api/v1/suggestion/post"
        
        Alamofire.request(.POST, url, parameters: ["suggestion": self.sendSuggestionInput.text, "phase": self.actualPhaseId])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("send rating error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success(json: JSON!)
                }
        }
    }
}
