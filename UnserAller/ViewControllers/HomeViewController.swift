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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate {

    @IBOutlet weak var mainTable: UITableView!
    var page: Int = -1 // -1 for initial infinite load
    var entries: [UASuggestion] = []
    let maxResponse: UInt = 10
    var countEntries: Int = 0
    var photos: [MWPhotoObj] = []
    
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
        var UASuggestCellNib = UINib(nibName: "UASuggestCell", bundle: nil)
        self.mainTable.registerNib(UASuggestCellNib, forCellReuseIdentifier: "UASuggestionCell")
        var UASuggestImageCellNib = UINib(nibName: "UASuggestImageCell", bundle: nil)
        self.mainTable.registerNib(UASuggestImageCellNib, forCellReuseIdentifier: "UASuggestImageCell")
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        // idk why this happening!
        if(self.entries.count == 0) {
            println("accessing with no elements")
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        println("cell is: \(entries[indexPath.row].cellType)")
        if ("SuggestionCell" == entries[indexPath.row].cellType) {
            cell = self.getSuggestCellForHome(entries[indexPath.row])
        } else if ("SuggestImageCell" == entries[indexPath.row].cellType) {
            cell = self.getSuggestImageCellForHome(entries[indexPath.row])
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel.text = "\(indexPath.row)"
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countEntries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
    
    /**
     * MWPhotoBrowser delegates
     */
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser) -> UInt {
        println(self.photos.count)
        return UInt(self.photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhoto! {
        println("here")
        if (Int(index) < self.photos.count) {
            println("asd")
            return self.photos[Int(index)];
        }
        return nil;
    }
    func didSelectItemFromCollectionView(notification: NSNotification) -> Void {
        let cellData: Dictionary<String, AnyObject> = notification.object as Dictionary<String, AnyObject>
        self.photos = []
        if (!cellData.isEmpty) {
            
            if let medias: [UAMedia] = cellData["media"] as? [UAMedia] {
                println(medias.count)
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
}