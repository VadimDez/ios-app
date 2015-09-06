//
//  ActivityViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewControllerWithMedia, UITableViewDelegate, UITableViewDataSource, FloatRatingViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var entries: [UASuggestion] = []
    var page: Int = -1
    var votingDisabled = false
    var mediaHelper: MediaHelper = MediaHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegates
        self.setDelegates()
        
        // register nibs
        self.registerNibs()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil)
        
        self.mainTable.addInfiniteScrollingWithActionHandler { () -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.infiniteLoad()
        }
        
        self.mainTable.triggerInfiniteScrolling()
    }
    
    /**
    Register nibs
    */
    func registerNibs() {
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        var UASuggestImageCellNib = UINib(nibName: "UASuggestImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestImageCellNib, forCellReuseIdentifier: "UASuggestImageCell")
        var UASuggestionVoteCellNib = UINib(nibName: "UASuggestionVoteCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteCellNib, forCellReuseIdentifier: "UASuggestionVoteCell")
        var UASuggestionVoteImageCellNib = UINib(nibName: "UASuggestionVoteImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteImageCellNib, forCellReuseIdentifier: "UASuggestionVoteImageCell")
    }
    
    func setDelegates() {
        self.mainTable.dataSource = self
        self.mainTable.delegate = self
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    // MARK: - Table Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch (self.entries[indexPath.row].cellType) {
            case "SuggestionCell": return self.getSuggestCellForActivity(self.entries[indexPath.row])
            case "UASuggestImageCell": return self.getSuggestImageCellForActivity(self.entries[indexPath.row])
            case "UASuggestionVoteCell": return self.getVoteCellForActivity(indexPath.row)
            case "UASuggestionVoteImageCell": return self.getVoteWithImageCellForActivity(indexPath.row)
        default:
            var cell: UITableViewCell
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(self.entries[indexPath.row].cellType) cell is not defined"
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var suggestionVC: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as! UASuggestionViewController
        suggestionVC.suggestion = self.entries[indexPath.row] as UASuggestion
        
        self.navigationController?.pushViewController(suggestionVC, animated: true)
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /**
    *  Get suggestion cell with suggestion object
    */
    func getSuggestCellForActivity(suggestion: UASuggestion) -> UASuggestionCell {
        var cell:UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as! UASuggestionCell
        cell.setCellForHome(suggestion)
        
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            // disable button
            cell.mainButton.enabled = false
            
            self.presentProjectViewController(suggestion.projectId, done: { () -> Void in
                // re-enable button
                cell.mainButton.enabled = true
            })
        }
        return cell
    }
        
    func getSuggestImageCellForActivity(suggestion: UASuggestion) -> UASuggestImageCell {
        var cell:UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as! UASuggestImageCell
        cell.setCellForHome(suggestion)
        
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            // disable button
            cell.mainButton.enabled = false
            
            self.presentProjectViewController(suggestion.projectId, done: { () -> Void in
                // re-enable button
                cell.mainButton.enabled = true
            })
        }
        return cell
    }
    
    func getVoteCellForActivity(row: Int) -> UASuggestionVoteCell {
        var cell:UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as! UASuggestionVoteCell
        
        
        if self.entries[row].isReleased {
            cell.ratingView.delegate = self
            cell.ratingView.editable = false
            cell.ratingView.tag = row
        }
        cell.setCellForActivity(self.entries[row])
        
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            
            // disable button
            cell.mainButton.enabled = false
            
            self.presentProjectViewController(self.entries[row].projectId, done: { () -> Void in
                // re-enable button
                cell.mainButton.enabled = true
            })
        }
        return cell
    }
    
    func getVoteWithImageCellForActivity(row: Int) -> UASuggestionVoteImageCell {
        var cell:UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as! UASuggestionVoteImageCell
        
        if self.entries[row].isReleased {
            cell.ratingView.delegate = self
            cell.ratingView.editable = false
            cell.ratingView.tag = row
        }
        cell.setCellForHome(self.entries[row])
        
        // suggestion vc
        cell.onMainButton = {
            () -> Void in
            
            // disable button
            cell.mainButton.enabled = false
            
            self.presentProjectViewController(self.entries[row].projectId, done: { () -> Void in
                // re-enable button
                cell.mainButton.enabled = true
            })
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = 110.0
        
        var media:CGFloat = self.mediaHelper.getHeightForMedias(self.entries[indexPath.row].media.count, maxWidth: self.mainTable.frame.width - 30.0)
        
        return base + self.entries[indexPath.row].content.getHeightForView(290, font: UIFont(name: "Helvetica Neue", size: 14)!) + media
    }
    
    /*
    * Infite load implementation
    */
    func infiniteLoad() {
        self.page += 1
        
        self.getEntries({() -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
            
            self.mainTable.reloadData()
            
            }, error: {() -> Void in
                println("Activity infinite load error")
                
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
        
        self.getEntries({ () -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
            
            self.mainTable.reloadData()
            
            }, error: { () -> Void in
                println("Activity pull to refresh load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        println("get entries is callded")
        // /api/mobile/profile/getbookmarks/
        let url: String = "\(APIURL)/api/mobile/profile/getactivity"
        
        Alamofire.request(.GET, url, parameters: ["page": self.page])
            .responseJSON { (_, _, JSON, errors) -> Void in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let SuggestionViewModel = UASuggestionViewModel()

                    // get get objects from JSON
                    var array = SuggestionViewModel.getSuggestionsForActivityFromJSON(JSON as! [Dictionary<String, AnyObject>])
                    
                    if self.page == 0 {
                        self.entries = []
                    }
                    
                    // merge two arrays
                    self.entries = self.entries + array
                    println(self.entries.count)
                    success()
                }
        }
    }
    
    // MARK: rating delegates
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
    }
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        
        if (!self.votingDisabled) {
//            var suggestion: UASuggestion = self.entries[ratingView.tag] as UASuggestion
//            let votes: Int = (suggestion.userVotes == Int(rating)) ? 0 : Int(rating)
            
            // disable for a moment
            self.votingDisabled = true
            
            // TODO: check if it's own suggestion before send
            
//            self.sendRating(suggestion.suggestionId, votes: votes, success: { () -> Void in
//                
//                (self.entries[ratingView.tag] as UASuggestion).likeCount = suggestion.likeCount - suggestion.userVotes + votes
//                
//                (self.entries[ratingView.tag] as UASuggestion).userVotes  = votes
//                
                // update only changed row
                let indexPath: NSIndexPath = NSIndexPath(forRow: ratingView.tag, inSection: 0)
                self.mainTable.beginUpdates()
                self.mainTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                self.mainTable.endUpdates()

                self.votingDisabled = false
//                }) { () -> Void in
//                    self.votingDisabled = false
//            }
        }
    }
    
    /**
    *   Present project view controller
    */
    func presentProjectViewController(projectId: UInt, done: () -> Void) {
        
        var competenceService = CompetenceService()
        competenceService.getEntries(projectId, projectStep: 0, success: { (competences) -> Void in
            if competences.count > 0 {
                var competenceVC = self.storyboard?.instantiateViewControllerWithIdentifier("CompetenceVC") as! CompetenceViewController
                competenceVC.projectId = projectId
                self.navigationController?.pushViewController(competenceVC, animated: true)
                
                done()
            } else {
                var projectVC: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
                
                // set project id
                projectVC.projectId = projectId
                
                self.navigationController?.pushViewController(projectVC, animated: true)
                
                done()
            }
            }) { () -> Void in
                done()
                
        }
    }
}
