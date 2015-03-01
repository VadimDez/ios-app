//
//  ActivityViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 17/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate, FloatRatingViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var entries: [UASuggestion] = []
    var countEntries: Int = 0
    var page: Int = -1
    var photos: [MWPhotoObj] = []
    var votingDisabled = false
    
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
        return self.countEntries
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        switch (entries[indexPath.row].cellType) {
            case "SuggestionCell": return self.getSuggestCellForActivity(self.entries[indexPath.row])
            case "UASuggestImageCell": return self.getSuggestImageCellForActivity(self.entries[indexPath.row])
            case "UASuggestionVoteCell": return self.getVoteCellForActivity(indexPath.row)
            case "UASuggestionVoteImageCell": return self.getVoteWithImageCellForActivity(indexPath.row)
        default:
            var cell: UITableViewCell
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(entries[indexPath.row].cellType) cell is not defined"
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var suggestionVC: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as UASuggestionViewController
        suggestionVC.suggestion = self.entries[indexPath.row] as UASuggestion
        
        self.navigationController?.pushViewController(suggestionVC, animated: true)
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /**
    *  Get suggestion cell with suggestion object
    */
    func getSuggestCellForActivity(suggestion: UASuggestion) -> UASuggestionCell {
        var cell:UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as UASuggestionCell
        cell.setCellForHome(suggestion)
        return cell
    }
        
    func getSuggestImageCellForActivity(suggestion: UASuggestion) -> UASuggestImageCell {
        var cell:UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as UASuggestImageCell
        cell.setCellForHome(suggestion)
        return cell
    }
    
    func getVoteCellForActivity(row: Int) -> UASuggestionVoteCell {
        var cell:UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as UASuggestionVoteCell
        cell.ratingView.delegate = self
        cell.ratingView.editable = false
        cell.ratingView.tag = row
        cell.setCellForActivity(self.entries[row])
        return cell
    }
    
    func getVoteWithImageCellForActivity(row: Int) -> UASuggestionVoteImageCell {
        var cell:UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as UASuggestionVoteImageCell
        cell.ratingView.delegate = self
        cell.ratingView.editable = false
        cell.ratingView.tag = row
        cell.setCellForHome(self.entries[row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = 110.0
        
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = 290
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = entries[indexPath.row].content
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        var media:CGFloat = 0.0
        if (entries[indexPath.row].media.count > 0) {
            media = 50.0 + CGFloat((entries[indexPath.row].media.count/5) * 50)
        }
        
        return base + label.frame.size.height + media
    }
    
    /*
    * Infite load implementation
    */
    func infiniteLoad() {
        self.page += 1
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.infiniteScrollingView.stopAnimating()
            }, {() -> Void in
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
        self.countEntries = 0
        
        self.getEntries({() -> Void in
            self.mainTable.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.mainTable.pullToRefreshView.stopAnimating()
            }, {() -> Void in
                println("Activity pull to refresh load error")
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.mainTable.pullToRefreshView.stopAnimating()
        })
    }
    
    func getEntries(success: () -> Void, error: () -> Void) {
        // /api/mobile/profile/getbookmarks/
        let url: String = "https://\(APIURL)/api/mobile/profile/getactivity"
        
        Alamofire.request(.GET, url, parameters: ["page": page])
            .responseJSON { (_, _, JSON, errors) -> Void in
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                    // error block
                    error()
                } else {
                    let SuggestionViewModel = UASuggestionViewModel()

                    // get get objects from JSON
                    var array = SuggestionViewModel.getSuggestionsForActivityFromJSON(JSON as [Dictionary<String, AnyObject>])
                    // merge two arrays
                    self.entries = self.entries + array
                    self.countEntries = self.entries.count
                    
                    success()
                }
        }
    }
    
    // MARK: MWPhotoBrowser delegates
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
        let cellData: Dictionary<String, AnyObject> = notification.object as Dictionary<String, AnyObject>
        self.photos = []
        
        if (!cellData.isEmpty) {
            
            if let medias: [UAMedia] = cellData["media"] as? [UAMedia] {
                
                for media: UAMedia in medias {
                    let photo: MWPhotoObj = MWPhotoObj.photoWithURL(NSURL(string: "https://\(APIURL)/media/crop/\(media.hash)/\(media.width)/\(media.height)"))
                    self.photos.append(photo)
                }
                
                var browser: MWPhotoBrowser = MWPhotoBrowser(delegate: self)
                
                browser.showPreviousPhotoAnimated(true)
                browser.showNextPhotoAnimated(true)
                browser.setCurrentPhotoIndex(cellData["actual"] as UInt)
                self.navigationController?.pushViewController(browser, animated: false)
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
}