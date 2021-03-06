//
//  ProjectViewController.swift
//  UnserAller
//
//  Created by Vadym on 30/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ProjectViewController:
        UIViewControllerWithMedia,
        UITableViewDelegate,
        UITableViewDataSource,
        UICollectionViewDelegate,
        UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout,
        FloatRatingViewDelegate,
        UAEditorDelegate
{
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var phaseCollection: UICollectionView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectCompanyName: UIButton!
    @IBOutlet weak var sendSuggestionInput: UITextField!
    @IBOutlet weak var sendSuggestionBtn: RNLoadingButton!
    @IBOutlet weak var phaseContent: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var projectNameBackground: UIView!
    @IBOutlet weak var transparentEditorBtn: UIButton!

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
    var votingDisabled = false
    var newsPhaseCount = 0
    var hasCompetences: Bool = false
    var mediaHelper: MediaHelper = MediaHelper()
    var allowNewSuggesitons: Bool = false
    
    var getRequest: Alamofire.Request!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.registerNotifications()
        
        self.sendSuggestionInput.enabled = false
        self.sendSuggestionBtn.enabled = false
        
        if self.type == "survey" && self.hasCompetences {
            self.checkCompetences()
        }
        self.mainTable.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDelegates()
        // nib
        self.registerNibs()
        
        self.configureLayout()
        
        self.startLoad { () -> Void in
            
            // set news to 1
            self.newsPhaseCount = 1
            // reload collection
            self.phaseCollection.reloadData()
            
            // check if there's at least one phase
            if (self.phasesArray.count > 0) {
                
                // set first phase as actial one
                self.actualPhaseId = self.phasesArray[0].id
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                
                
                // load phase
                self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                    
                    if jsonResponse.count > 0 {
                        self.updatePhase(jsonResponse, success: { () -> Void in
                            self.entries = []
                            if self.active {
                                self.allowNewSuggesitons = true
                                self.sendSuggestionInput.enabled = true
                                self.sendSuggestionBtn.enabled = true
                                
                                self.loadSuggestions({ () -> Void in
                                    
                                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    }, failure: { () -> Void in
                                        println("fail load suggestions")
                                        
                                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                })
                            }
                        })
                    }
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
        
        self.setProjectBg()
        
        // set button with indicator
        self.sendSuggestionBtn.hideTextWhenLoading = true
        self.sendSuggestionBtn.setActivityIndicatorAlignment(RNLoadingButtonAlignmentCenter)
        self.sendSuggestionBtn.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, forState: UIControlState.Disabled)
    }
    
    func setProjectBg() -> Void {
        self.projectNameBackground.layerGradient(UIColor.clearColor(), color2: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1), color3: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2), color4: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25))
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
                    
                    if jsonResponse.count > 0 {
                        self.updatePhase(jsonResponse, success: { () -> Void in
                            self.entries = []
                            
                            if self.active {
                                if self.type == "survey" {
                                    self.checkCompetences()
                                } else {
                                    self.loadSuggestions({ () -> Void in
                                        
                                        self.mainTable.pullToRefreshView.stopAnimating()
                                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    }, failure: { () -> Void in
                                        println("fail load suggestions")
                                        
                                        self.mainTable.pullToRefreshView.stopAnimating()
                                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                    })
                                }
                            } else {
                                
                                self.mainTable.pullToRefreshView.stopAnimating()
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }

                        })
                    }
                    
                }, failure: { () -> Void in
                    
                    self.mainTable.pullToRefreshView.stopAnimating()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
                
                
            } else {
                
                self.loadNews({ () -> Void in
                    self.mainTable.reloadData()
                    
                    self.mainTable.pullToRefreshView.stopAnimating()
                    
                    // active activity indicator
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    }, failure: { () -> Void in
                        
                    self.mainTable.pullToRefreshView.stopAnimating()
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
        
        if !self.news {
            if self.active {
                if self.type == "survey" {
                    self.checkCompetences()
                } else {
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
                }
            } else {
                self.mainTable.infiniteScrollingView.stopAnimating()
            }
        } else {
            self.loadNews({ () -> Void in
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
        var phaseText: String = ""
        if let shortText = jsonResponse.objectForKey("shortText") as? String {
            phaseText = "\(shortText)"
        }
        if let text = jsonResponse.objectForKey("text") as? String {
            phaseText = "\(phaseText)\(text)"
        }
        phaseText = phaseText.html2String()
        
        self.phaseContent.text = phaseText
        self.adjustTableHeader()
        
        // type
        if let type_ = jsonResponse.objectForKey("type") as? String {
            self.type = type_
        }
        
        var startDate: String = ""
        var endDate: String = ""
        var allowNewSuggestion = true
        
        // end date
        if (!(jsonResponse.objectForKey("endDate") is NSNull)) {
            endDate = jsonResponse.objectForKey("endDate")?.objectForKey("date") as! String!
        }
        // start date
        if let start: AnyObject = jsonResponse.objectForKey("startDate") {
            startDate = start.objectForKey("date") as! String!
        }
        
        if let allowSuggestions: UInt = jsonResponse.objectForKey("allowNewSuggestions") as? UInt {
            allowNewSuggestion = (allowSuggestions == 1)
        }
        
        // check active step
        self.active = self.checkActive(startDate, end: endDate)
        
        // disable or enable posting suggestion
        self.sendSuggestionBtn.enabled = allowNewSuggestion && self.active
        self.sendSuggestionInput.enabled = allowNewSuggestion && self.active
        self.transparentEditorBtn.enabled = allowNewSuggestion && self.active
        
        success()
    }

    /**
     *  MARK: Table view delegates
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == "survey" {
            return 1
        }
        return self.entries.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!news) {
            if self.type == "survey" {
                if self.hasCompetences {
                    var competenceVC = self.storyboard?.instantiateViewControllerWithIdentifier("CompetenceVC") as! CompetenceViewController
                    competenceVC.projectId = self.projectId
                    competenceVC.projectStepId = self.stepId
                    self.navigationController?.pushViewController(competenceVC, animated: true)
                }
            } else {
                var detailViewController: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as! UASuggestionViewController
                
                detailViewController.suggestion = self.entries[indexPath.row] as! UASuggestion
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else {
            var detailViewController: NewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewsVC") as! NewsViewController
            detailViewController.news = self.entries[indexPath.row] as! UANews
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }

        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if self.type == "survey" {
            if self.hasCompetences {
                var cell = UITableViewCell()
                cell.textLabel?.text = "go to survey"
                return cell
            } else {
                var cell = UITableViewCell()
                cell.textLabel?.text = "You finished the survey"
                return cell
            }
        } else {
            switch self.entries[indexPath.row].cellType {
                case "SuggestionCell":              return self.getSuggestCellForRow(indexPath.row)
                case "UAProjectNewsCell":           return self.getNewsCellForRow(indexPath.row)
                case "UASuggestImageCell":          return self.getSuggestImageCellForRow(indexPath.row)
                case "UASuggestionVoteCell":        return self.getVoteCellForRow(indexPath.row)
                case "UASuggestionVoteImageCell":   return self.getVoteImageCellForRow(indexPath.row)
                default: break;
            }
        }
        return self.defaultCell(indexPath.row)
    }
    
    /**
     *  Get suggest cell without images
     */
    func getSuggestCellForRow(row: Int) -> UASuggestionCell {
        var cell: UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as! UASuggestionCell
        
        self.setProjectToSuggestionWithIndex(row)
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
    *  Get suggest cell with image
    */
    func getSuggestImageCellForRow(row: Int) -> UASuggestImageCell {
        var cell: UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as! UASuggestImageCell
        
        self.setProjectToSuggestionWithIndex(row)
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
     *  Get project news cell
     */
    func getNewsCellForRow(row: Int) -> UAProjectNewsCell {
        var cell: UAProjectNewsCell = self.mainTable.dequeueReusableCellWithIdentifier("UAProjectNewsCell") as! UAProjectNewsCell
        
        self.setProjectToSuggestionWithIndex(row)
        cell.setCellForProjectPhase(self.entries[row] as! UANews)
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteCellForRow(row: Int) -> UASuggestionVoteCell {
        var cell: UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as! UASuggestionVoteCell
        if (self.entries[row] as! UASuggestion).isReleased {
            cell.ratingView.delegate = self
            cell.ratingView.tag = row
        }
        
        self.setProjectToSuggestionWithIndex(row)
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteImageCellForRow(row: Int) -> UASuggestionVoteImageCell {
        var cell: UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as! UASuggestionVoteImageCell
        println((self.entries[row] as! UASuggestion).isReleased)
        if (self.entries[row] as! UASuggestion).isReleased {
            cell.ratingView.delegate = self
            cell.ratingView.tag = row
        }
        
        self.setProjectToSuggestionWithIndex(row)
        cell.setCellForPhase(self.entries[row] as! UASuggestion)
        return cell
    }
    
    private func setProjectToSuggestionWithIndex(index: Int) {
        (self.entries[index] as! UASuggestion).projectId = self.project.id
        (self.entries[index] as! UASuggestion).projectName = self.project.name
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
        let base: CGFloat!
        var content: CGFloat = 0
        
        if (self.entries.count == 0) {
            if (self.type == "survey") {
                return 50.0
            }
            return 0
        }
        
        var media: CGFloat = self.mediaHelper.getHeightForMedias(self.entries[indexPath.row].media.count, maxWidth: self.mainTable.frame.width - 24.0)
        
        if (self.news) {
            base = 50.0
            content = self.entries[indexPath.row].content.getHeightForView(280, font: UIFont(name: "Helvetica Neue", size: 14)!)
            content += (self.entries[indexPath.row] as! UANews).title.getHeightForView(280, font: UIFont(name: "Helvetica Neue", size: 16)!)
        } else {
            base = 110.0
            content = self.entries[indexPath.row].content.getHeightForView(290, font: UIFont(name: "Helvetica Neue", size: 14)!)
        }
        
        return base + content + media
    }
    
    // MARK: Collection view delegates
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:UAPhaseCell = self.phaseCollection.dequeueReusableCellWithReuseIdentifier("UAPhaseCell", forIndexPath: indexPath) as! UAPhaseCell

        cell.hideLines(false)
        cell.resetFont()
        
//        if (self.phasesArray.count == 0) {
//            return cell
//        }

        if (indexPath.row == 0) {
            cell.setNewsCell()
            
            if self.news {
                cell.setSelected()
            }
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
            
            
            if !self.news && self.phasesArray[indexPath.row - 1].id == self.actualPhaseId {
                cell.setSelected()
            }
            println(indexPath.row)
            println(cell.leftLine.hidden)
            println(cell.rightLine.hidden)
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(phasesArray.count + self.newsPhaseCount)
        // +1 for "NEWS"
        return phasesArray.count + self.newsPhaseCount
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size: CGSize = CGSize(width: 0, height: 50.0)
        
        if indexPath.row == 0 {
            size.width = 70.0
        } else {
            size.width = 20.0 + self.phasesArray[indexPath.row - 1].name.getWidthForView(17.0, font: UIFont(name: "Helvetica Neue", size: 14)!);
        }
        return size;
    }

    /**
     * did select
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if (indexPath.row == 0) {
            // news
            self.entries = []
            self.news = true
            self.entries = []
            
            self.phaseCollection.reloadData()
            self.mainTable.reloadData()
            
            self.loadNews({ () -> Void in
                self.mainTable.reloadData()
                }, failure: { () -> Void in
                    println("fail load news")
            })
            
        } else {
            
            self.type = ""
            self.entries = []
            self.mainTable.reloadData()
            
            // suggestions
            self.news = false
            // set active phase id
            self.actualPhaseId = self.phasesArray[indexPath.row - 1].id
            
            // upload cell
            self.phaseCollection.reloadData()
            
            // load phase/step info
            self.loadPhase(self.actualPhaseId, success: { (jsonResponse) -> Void in
                
                if jsonResponse.count > 0 {
                    self.updatePhase(jsonResponse, success: { () -> Void in
                        
                        if self.active {
                            if self.type == "survey" {
                                self.checkCompetences()
                            } else {
                                self.loadSuggestions({ () -> Void in
                                    
                                    }, failure: { () -> Void in
                                        println("fail load suggestions")
                                })
                            }
                        }
                    })
                }
                
            }, failure: { () -> Void in
                println("fail load phase")
            })
        }
    }
    
    /**
     *  Get project info
     */
    func loadProject(success: (json: AnyObject) -> Void, error: () -> Void) {
        // build URL
        let url: String = "\(APIURL)/api/mobile/project/get/\(self.projectId)"
        
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
        
        let request = NSURLRequest(URL: NSURL(string: "\(APIURL)/api/v1/media/project/\(self.project.id)/width/320/height/188")!)

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
        let url: String = "\(APIURL)/api/mobile/project/getphases/\(self.projectId)"
        
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
        let url: String = "\(APIURL)/api/mobile/project/getstep/\(id)"

        // GET
        self.getRequest = Alamofire.request(.GET, url)
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
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
        
        // set frame height
        mainFrame?.size.height = self.phaseContent.text!.getHeightForView(self.phaseContent.frame.width, font: UIFont(name: "Helvetica Neue", size: 15)!) + 290.0
        self.mainTable.tableHeaderView?.frame = mainFrame!
        self.mainTable.tableHeaderView = self.mainTable.tableHeaderView
    }
    
    /**
     * Load suggestions
     */
    func loadSuggestions(success: () -> Void, failure: () -> Void) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // cancel previous request
        if self.getRequest != nil {
            println("cancel news")
            self.getRequest.cancel()
        }
        
        // build url
        let url: String = "\(APIURL)/api/mobile/project/suggestions"
        
        // GET
        self.getRequest = Alamofire.request(.GET, url, parameters: ["id": self.projectId, "step": self.stepId, "order": "newest", "page": self.page])
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
    func loadNews(success: () -> Void, failure: () -> Void) -> Void {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // build url
        let url: String = "\(APIURL)/api/mobile/project/getnews"
        
        // cancel previous request
        if self.getRequest != nil {
            println("cancel suggestions")
            self.getRequest.cancel()
        }
        
        // GET
        self.getRequest = Alamofire.request(.GET, url, parameters: ["id": self.projectId, "page": self.page])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    // print error
                    println("Load project news error")
                    println(errors)
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    failure()
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
            
            
            let likeCountBefore = (self.entries[ratingView.tag] as! UASuggestion).likeCount
            let userVotesBefore = (self.entries[ratingView.tag] as! UASuggestion).userVotes
            (self.entries[ratingView.tag] as! UASuggestion).likeCount = suggestion.likeCount - suggestion.userVotes + votes
            
            (self.entries[ratingView.tag] as! UASuggestion).userVotes = votes
            
            // update only changed row
            let indexPath: NSIndexPath = NSIndexPath(forRow: ratingView.tag, inSection: 0)
            self.mainTable.beginUpdates()
            self.mainTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            self.mainTable.endUpdates()
            
            self.sendRating(suggestion.suggestionId, votes: votes, success: { () -> Void in
                
                self.votingDisabled = false
            }, failure: { () -> Void in
                
                self.votingDisabled = false
                
                (self.entries[ratingView.tag] as! UASuggestion).likeCount = likeCountBefore
                
                (self.entries[ratingView.tag] as! UASuggestion).userVotes = userVotesBefore
                
                // update only changed row
                let indexPath: NSIndexPath = NSIndexPath(forRow: ratingView.tag, inSection: 0)
                self.mainTable.beginUpdates()
                self.mainTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                self.mainTable.endUpdates()

            })
        }
    }
    
    /**
    *  Send rating
    */
    func sendRating(id: UInt, votes: Int, success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/v1/suggestion/vote"
        
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
    
    // MARK: new suggestion editor delegates
    /**
    Open editor
    
    :param: sender
    */
    @IBAction func openEditor(sender: AnyObject) {
        
        if !self.allowNewSuggesitons {
            return
        }
        
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

    /**
     *  Send new suggestion
     */
    @IBAction func sendNewSuggestion() {
        self.sendSuggestionBtn.loading = true
        
        self.sendSuggestion({ (json) -> () in
            
            var suggestion = UASuggestion()
            self.sendSuggestionInput.text = ""
            
            if (self.type == "vote") {
                suggestion = UASuggestion().initVoteForProjectFromJSON(json, project: self.project)
            } else {
                suggestion = UASuggestion().initSuggestForProjectFromJSON(json, project: self.project)
            }
            
            self.sendSuggestionBtn.loading = false
            var array = [suggestion]
            
            self.entries = array + self.entries
            self.mainTable.reloadData()
            
        }, failure: { () -> () in
            self.sendSuggestionBtn.loading = false
        })
    }
    
    /**
    Send new suggestion
    
    :param: success func
    :param: failure func
    */
    func sendSuggestion(success: (json: AnyObject) -> (), failure: () -> ()) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/v1/suggestion/post"
        
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
    
    func checkCompetences() {
        var competenceService = CompetenceService()
        // active activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        competenceService.getEntries(self.projectId, projectStep: self.stepId, success: { (competences) -> Void in
            self.hasCompetences = (competences.count > 0)

            self.mainTable.reloadData()

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, error: { () -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}
