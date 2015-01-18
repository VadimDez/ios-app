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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate, FloatRatingViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1 // -1 for initial infinite load
    var entries: [UASuggestion] = []
    let maxResponse: UInt = 10
    var countEntries: Int = 0
    var photos: [MWPhotoObj] = []
    var votingDisabled = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // adjust table Or use didMoveToParentViewController
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.edgesForExtendedLayout = UIRectEdge.None
        
        // hide nav bar
//        self.navigationController?.hidesBarsOnSwipe = true
        
        
//        self.getEntries({
//            
//        }, error: { () -> Void in
//            
//        })
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
        
        
        // set row height
//        self.mainTable.rowHeight = UITableViewAutomaticDimension
        
        self.mainTable.triggerInfiniteScrolling()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectItemFromCollectionView:", name: "didSelectItemFromCollectionView", object: nil)
    }
    
    func registerNibs() {
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        var UASuggestImageCellNib = UINib(nibName: "UASuggestImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestImageCellNib, forCellReuseIdentifier: "UASuggestImageCell")
        var UANewsCellNib = UINib(nibName: "UANewsCell", bundle: nil)
        self.mainTable.registerNib(UANewsCellNib, forCellReuseIdentifier: "UANewsCell")
        var UASuggestionVoteCellNib = UINib(nibName: "UASuggestionVoteCell", bundle: nil)
        self.mainTable.registerNib(UASuggestionVoteCellNib, forCellReuseIdentifier: "UASuggestionVoteCell")
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
        self.entries = []
        self.countEntries = 0
        
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
        toggleSideMenuView()
    }
    
    // MARK: table view delegates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        // TODO: check why it's empty
        if(self.entries.count == 0) {
            println("accessing with no elements")
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        
        if ("SuggestionCell" == self.entries[indexPath.row].cellType) {
            cell = self.getSuggestCellForHome(entries[indexPath.row])
        } else if ("SuggestImageCell" == entries[indexPath.row].cellType) {
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
        var cell:UASuggestionCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionCell") as UASuggestionCell
        cell.setCellForHome(suggestion)
        return cell
    }
    
    func getSuggestImageCellForHome(suggestion: UASuggestion) -> UASuggestImageCell {
        var cell:UASuggestImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestImageCell") as UASuggestImageCell
        cell.setCellForHome(suggestion)
        return cell
    }
    
    /**
     *  Get news cell without images
     */
    func getNewsCellForHome(suggestion: UASuggestion) -> UANewsCell {
        var cell: UANewsCell = self.mainTable.dequeueReusableCellWithIdentifier("UANewsCell") as UANewsCell
        cell.setCellForHome(suggestion)
        return cell
    }
    
    /**
    *  Get suggestion vote cell
    */
    func getVoteCellForHome(suggestion: UASuggestion, row: Int) -> UASuggestionVoteCell {
        var cell: UASuggestionVoteCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteCell") as UASuggestionVoteCell
        
        // rating delegate 
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForHome(suggestion)
        return cell
    }
    
    /**
     *  Get vote image cell
     */
    func getVoteImageCellForHome(row: Int) -> UASuggestionVoteImageCell {
        var cell: UASuggestionVoteImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UASuggestionVoteImageCell") as UASuggestionVoteImageCell
        
        // rating delegate
        cell.ratingView.delegate = self
        cell.ratingView.tag = row
        cell.setCellForHome(self.entries[row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO: check why it's empty
        if (self.entries.count > 0) {
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
        } else {
            return 0;
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var suggestionVC: UASuggestionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SuggestionVC") as UASuggestionViewController
        suggestionVC.suggestion = self.entries[indexPath.row] as UASuggestion
        
        self.navigationController?.pushViewController(suggestionVC, animated: true)
        self.mainTable.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /**
     *  Get entries
     */
    func getEntries(success:() -> Void, error: () -> Void) {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/profile/getwall"
        
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
                var array = SuggestionModelView.getSuggestionsFromJSON(JSON as [Dictionary<String, AnyObject>])
            
                // merge two arrays
                self.entries = self.entries + array
                self.countEntries = self.entries.count
                
                success()
            }
        }
    }
    
    // MARK: MWPhotoBrowser delegates
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

        var url: String = "http://\(APIURL)/api/v1/suggestion/vote"

        Alamofire.request(.GET, url, parameters: ["id": id, "votes": votes])
            .responseJSON { (_,_,JSON,errors) in

                if(errors != nil) {
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