//
//  HomeViewController.swift
//  UnserAller
//
//  Created by Vadym on 20/07/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

//import Foundation
import UIKit
import Alamofire

class HomeViewController: UIViewControllerWithMedia, UITableViewDelegate, UITableViewDataSource, FloatRatingViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1 // -1 for initial infinite load
    var entries: [UASuggestion] = []
    let maxResponse: UInt = 10
    var countEntries: Int = 0

    var votingDisabled = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // adjust table Or use didMoveToParentViewController
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.registerNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // register nibs
        self.registerNibs()
        
        // setup infinite scrolling
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotifications()
    }
    
    func registerNibs() {
        // suggest
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        // suggest with image
        var UASuggestImageCellNib = UINib(nibName: "UASuggestImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestImageCellNib, forCellReuseIdentifier: "UASuggestImageCell")
        // news
        var UANewsCellNib = UINib(nibName: "UANewsCell", bundle: nil)
        self.mainTable.registerNib(UANewsCellNib, forCellReuseIdentifier: "UANewsCell")
        // suggestion vote
        var UASuggestionVoteCellNib = UINib(nibName: "UASuggestionVoteCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteCellNib, forCellReuseIdentifier: "UASuggestionVoteCell")
        // suggestion vote with image
        var UASuggestionVoteImageCellNib = UINib(nibName: "UASuggestionVoteImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteImageCellNib, forCellReuseIdentifier: "UASuggestionVoteImageCell")
    }
    
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

        self.getEntries({ () -> Void in
            
            self.mainTable.reloadData()
            
            self.mainTable.pullToRefreshView.stopAnimating()
            
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, error: { () -> Void in
            println("Homepage refresh error")
            
            self.mainTable.pullToRefreshView.stopAnimating()
            
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    /**
     *  Load next page
     */
    func infiniteLoad() {
        // increment page
        self.page += 1
        
        self.getEntries({ () -> Void in
            // reload data
            self.mainTable.reloadData()
            
            self.mainTable.infiniteScrollingView.stopAnimating()
            
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }, error: { () -> Void in
            println("Homepage infiniteload error")
            
            self.mainTable.infiniteScrollingView.stopAnimating()
            // active activity indicator
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    

    /**
     *  Hide menu button
     */
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    // MARK: table view delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if ("SuggestionCell" == self.entries[indexPath.row].cellType) {
            cell = self.getSuggestCellForHome(entries[indexPath.row])
        } else if ("UASuggestImageCell" == entries[indexPath.row].cellType) {
            cell = self.getSuggestImageCellForHome(entries[indexPath.row])
        } else if ("NewsCell" == self.entries[indexPath.row].cellType) {
            cell = self.getNewsCellForHome(self.entries[indexPath.row])
        } else if ("UASuggestionVoteCell" == self.entries[indexPath.row].cellType) {
            cell = self.getVoteCellForHome(self.entries[indexPath.row], row: indexPath.row)
        } else if ("UASuggestionVoteImageCell" == self.entries[indexPath.row].cellType) {
            cell = self.getVoteImageCellForHome(indexPath.row)
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(self.entries[indexPath.row].cellType) cell not defined"
        }
        
        return cell
    }
    
    
    /**
     *  Get suggestion cell with suggestion object
     */
    func getSuggestCellForHome(suggestion: UASuggestion) -> UASuggestionCell {
        var cell:UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as! UASuggestionCell
        cell.setCellForHome(suggestion)
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            self.presentProjectViewController(suggestion.projectId)

        }
        return cell
    }
    
    func getSuggestImageCellForHome(suggestion: UASuggestion) -> UASuggestImageCell {
        var cell:UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as! UASuggestImageCell
        cell.setCellForHome(suggestion)
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            self.presentProjectViewController(suggestion.projectId)
        }
        return cell
    }
    
    /**
     *  Get news cell without images
     */
    func getNewsCellForHome(suggestion: UASuggestion) -> UANewsCell {
        var cell: UANewsCell = self.mainTable.dequeueReusableCellWithIdentifier("UANewsCell") as! UANewsCell
        cell.setCellForHome(suggestion)

        cell.onMainButton = {
            () -> Void in
            self.presentProjectViewController(suggestion.projectId)
        }
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteCellForHome(suggestion: UASuggestion, row: Int) -> UASuggestionVoteCell {
        var cell: UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as! UASuggestionVoteCell
        
        // rating delegate 
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForHome(suggestion)
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            self.presentProjectViewController(suggestion.projectId)
        }
        return cell
    }
    
    /**
     *  Get vote image cell
     */
    func getVoteImageCellForHome(row: Int) -> UASuggestionVoteImageCell {
        var cell: UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as! UASuggestionVoteImageCell
        
        // rating delegate
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForHome(self.entries[row])

        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            self.presentProjectViewController(self.entries[row].projectId)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = 95.0
            
        var media:CGFloat = 0.0
        if (entries[indexPath.row].media.count > 0) {
            media = 50.0
            let mediaCount = entries[indexPath.row].media.count
            
            if (mediaCount > 5) {
                media = media + CGFloat((mediaCount / 5) * 50)
            }
        }
        return base + entries[indexPath.row].content.getHeightForView(self.mainTable.frame.width - 20, font: UIFont(name: "Helvetica Neue", size: 13)!) + media
    }

    /**
     * Did select row
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.entries[indexPath.row].cellType == "NewsCell" || self.entries[indexPath.row].cellType == "NewsContainerTableCell") {
            self.presentNewsViewController(self.entries[indexPath.row] as UASuggestion)
        } else {
            self.presentSuggestionViewController(self.entries[indexPath.row] as UASuggestion)
        }
        
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }

    /**
     * Present suggestion view controller with suggestion
     */
    func presentSuggestionViewController(suggestion: UASuggestion) {
        var suggestionVC: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as! UASuggestionViewController
        suggestionVC.suggestion = suggestion

        self.navigationController?.pushViewController(suggestionVC, animated: true)
    }


    /**
     * Present news view controller with news
     */
    func presentNewsViewController(news: UASuggestion) {
        var newsVC: NewsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewsVC") as! NewsViewController

        self.navigationController?.pushViewController(newsVC, animated: true)
    }

    /**
     *   Present project view controller
     */
    func presentProjectViewController(projectId: UInt) {
        var projectVC: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController

        // set project id
        projectVC.projectId = projectId

        self.navigationController?.pushViewController(projectVC, animated: true)
    }
    
    /**
     *  Get entries
     */
    func getEntries(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "\(APIURL)/api/mobile/profile/getwall"
        
        // get entries
        Alamofire.request(.GET, url, parameters: ["page": page])
        .responseJSON { (_,_,JSON,errors) in
            
            if(errors != nil || JSON?.count == 0 || JSON?.objectAtIndex(0).count == 0) {
                // print error
                println(errors)
                // error block
                error()
            } else {
                let SuggestionModelView = UASuggestionViewModel()

                // get get objects from JSON
                var array = SuggestionModelView.getSuggestionsFromJSON(JSON as! [Dictionary<String, AnyObject>])
            
                // merge two arrays
                self.entries = self.entries + array
                self.countEntries = self.entries.count
                
                success()
            }
        }
    }
    
    
    // MARK: rating delegates
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
    }
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        
        if (!self.votingDisabled) {
            var suggestion: UASuggestion = self.entries[ratingView.tag] as UASuggestion
            let votes: Int = (suggestion.userVotes == Int(rating)) ? 0 : Int(rating)
            
            // disable for a moment
            self.votingDisabled = true
            
            // TODO: check if it's own suggestion before send
            
            self.sendRating(suggestion.suggestionId, votes: votes, success: { () -> Void in
                
                (self.entries[ratingView.tag] as UASuggestion).likeCount = suggestion.likeCount - suggestion.userVotes + votes
                
                (self.entries[ratingView.tag] as UASuggestion).userVotes  = votes
                
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

        var url: String = "\(APIURL)/api/v1/suggestion/vote"

        Alamofire.request(.GET, url, parameters: ["id": id, "votes": votes])
            .responseJSON { (_, _, JSON, errors) in

                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    success()
                }
        }
    }
}