//
//  UASuggestionViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 14/01/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit
import Alamofire

class UASuggestionViewController: UIViewControllerWithMedia, UITableViewDataSource, UITableViewDelegate, FloatRatingViewDelegate, UAEditorDelegate {

    @IBOutlet weak var mainTable: UITableView!
    
    var active: Bool!
    var suggestion: UASuggestion!
    var entries: [UAComment] = []
    var tableWidth: CGFloat!
    var votingDisabled = false
    var newCommentContent: String!
    
    override func viewWillAppear(animated: Bool) {
        self.tableWidth = self.mainTable.frame.width
        
        self.registerNotifications()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setViewHeader()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        
        // register nibs
        self.registerNibs()
        
        
        self.loadComments({ () -> Void in
            self.mainTable.reloadData()
            }, failure: { () -> Void in
                
        })
        
        self.newCommentContent = ""
    }
    
    
    func registerNibs() {
//        var UASuggestionViewNib = UINib(nibName: "UASuggestionView", bundle: nil)
//        self.mainTable.registerNib(UASuggestionViewNib, forHeaderFooterViewReuseIdentifier: "UASuggestionView")
//        var UASuggestionWithImageViewNib = UINib(nibName: "UASuggestionWithImageView", bundle: nil)
//        self.mainTable.registerNib(UASuggestionWithImageViewNib, forHeaderFooterViewReuseIdentifier: "UASuggestionWithImageView")
        
        
        var UACommentCellNib = UINib(nibName: "UACommentCell", bundle: nil)
        self.mainTable.registerNib(UACommentCellNib, forCellReuseIdentifier: "UACommentCell")
        var UACommentImageCellNib = UINib(nibName: "UACommentWithImageCell", bundle: nil)
        self.mainTable.registerNib(UACommentImageCellNib, forCellReuseIdentifier: "UACommentWithImageCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.entries[indexPath.row].cellType == "UACommentWithImageCell") {
            var cell: UACommentWithImageCell = self.mainTable.dequeueReusableCellWithIdentifier("UACommentWithImageCell") as! UACommentWithImageCell
            cell.setCell(self.entries[indexPath.row])
            return cell
        }
        var cell: UACommentCell = self.mainTable.dequeueReusableCellWithIdentifier("UACommentCell") as! UACommentCell

        cell.setCell(self.entries[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let base: CGFloat = 69.0
        
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = self.tableWidth
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = entries[indexPath.row].content
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        var media:CGFloat = 0.0
        if (entries[indexPath.row].media.count > 0) {
            media = 60.0 + CGFloat((entries[indexPath.row].media.count/5) * 51)
        }
        
        return base + label.frame.size.height + media
    }
    
    /**
     *  Load suggestion
     */
    func getSuggestion(success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/mobile/suggestion/suggestion"

        Alamofire.request(.GET, url, parameters: ["id": self.suggestion.suggestionId])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("get suggestion error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    let suggestionViewModel = UASuggestionViewModel()
                    
                    self.suggestion = UASuggestion().getSuggestionFromJSONForSuggestionVC(JSON?.objectAtIndex(0) as! Dictionary<String, AnyObject>)
                    
                    success()
                }
        }
    }
    
    /**
     *  Load comments for suggestion
     */
    func loadComments(success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/mobile/comment/suggestion"
        
        Alamofire.request(.GET, url, parameters: ["id": self.suggestion.suggestionId])
            .responseJSON { (_,_,JSON,errors) in
                
                if (errors != nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
                    println("load comments error")
                    println(errors)
                    // error block
                    failure()
                } else {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                    if (JSON?.count > 0 && JSON?.objectForKey("comments")?.count > 0) {
                        let commentViewModel = UACommentViewModel()

                        // get array
                        var array = commentViewModel.getCommentsFromJSON(JSON?.objectForKey("comments") as! [Dictionary<String, AnyObject>])
                        
                        self.entries = self.entries + array
                    }
                    success()
                }
        }
    }
    
    
    /**
        Set up table header view
    */
    func setViewHeader() {
        switch (self.suggestion.cellType) {
            case "SuggestionCell": self.mainTable.tableHeaderView = self.getSuggestionView()
                break
            case "UASuggestImageCell": self.mainTable.tableHeaderView = self.getSuggestionWithimageView()
                break
            case "UASuggestionVoteCell": self.mainTable.tableHeaderView = self.getSuggestionVoteView()
                break
            case "UASuggestionVoteImageCell": self.mainTable.tableHeaderView = self.getSuggestionVoteWithImageView()
                break
            default: self.mainTable.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.mainTable.frame.size.width, height: 0))
        }
    }
    
    /**
    Get suggestion view
    
    :returns: returns UASuggestionView
    */
    func getSuggestionView() -> UASuggestionView {
        let nib = NSBundle.mainBundle().loadNibNamed("UASuggestionView", owner: self, options: nil)
        var suggestionView: UASuggestionView = nib[0] as! UASuggestionView
        
        suggestionView.setUp(self.suggestion)
        suggestionView.newCommentButton.addTarget(self, action: "openEditor:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.sendNewCommentButton.addTarget(self, action: "sendNewComment:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.projectButton.addTarget(self, action: "openProject:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.frame.size.height = self.calculateHeaderHeight(105.0)
        
        return suggestionView
    }
    
    /**
    Get suggestion with image view
    
    :returns: returns UASuggestionWithImageView
    */
    func getSuggestionWithimageView() -> UASuggestionWithImageView {
        let nib = NSBundle.mainBundle().loadNibNamed("UASuggestionWithImageView", owner: self, options: nil)
        var suggestionView: UASuggestionWithImageView = nib[0] as! UASuggestionWithImageView
        
        suggestionView.setUp(self.suggestion)
        suggestionView.newCommentButton.addTarget(self, action: "openEditor:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.sendNewCommentButton.addTarget(self, action: "sendNewComment:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.projectButton.addTarget(self, action: "openProject:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.frame.size.height = self.calculateHeaderHeight(105.0)
        
        return suggestionView
    }
    
    /**
    Get suggestion vote view
    
    :returns: returns UASuggestionVoteView
    */
    func getSuggestionVoteView() -> UASuggestionVoteView {
        let nib = NSBundle.mainBundle().loadNibNamed("UASuggestionVoteView", owner: self, options: nil)
        var suggestionView: UASuggestionVoteView = nib[0] as! UASuggestionVoteView
        
        suggestionView.setUp(self.suggestion)
        suggestionView.ratingView.delegate = self
        suggestionView.newCommentButton.addTarget(self, action: "openEditor:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.sendNewCommentButton.addTarget(self, action: "sendNewComment:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.projectButton.addTarget(self, action: "openProject:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.frame.size.height = self.calculateHeaderHeight(110.0)
        
        return suggestionView
    }
    
    /**
    Get suggestion vote with images view
    
    :returns: returns UASuggestionVoteView
    */
    func getSuggestionVoteWithImageView() -> UASuggestionVoteWithImageView {
        let nib = NSBundle.mainBundle().loadNibNamed("UASuggestionVoteWithImageView", owner: self, options: nil)
        var suggestionView: UASuggestionVoteWithImageView = nib[0] as! UASuggestionVoteWithImageView
        
        suggestionView.setUp(self.suggestion)
        suggestionView.ratingView.delegate = self
        suggestionView.newCommentButton.addTarget(self, action: "openEditor:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.sendNewCommentButton.addTarget(self, action: "sendNewComment:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.projectButton.addTarget(self, action: "openProject:", forControlEvents: UIControlEvents.TouchUpInside)
        suggestionView.frame.size.height = self.calculateHeaderHeight(105.0)
        
        return suggestionView
    }
    
    func calculateHeaderHeight(base: CGFloat) -> CGFloat {
        let imageSize: CGFloat = 40.0
        var media: CGFloat = 0.0
        
        if (self.suggestion.media.count > 0) {
            media = 50.0 + CGFloat((self.suggestion.media.count/5) * 50) + 10
        }
        
        // count text
        var frame: CGRect = CGRect()
        frame.size.width = self.mainTable.frame.width - 10
        frame.size.height = CGFloat(MAXFLOAT)
        var label: UILabel = UILabel(frame: frame)
        
        label.text = self.suggestion.content
        label.font = UIFont(name: "Helvetica Neue", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        
        return base + media + label.frame.size.height
    }
    
    // MARK: rating delegates
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        
    }
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {

        if (!self.votingDisabled) {
            let votes: Int = (suggestion.userVotes == Int(rating)) ? 0 : Int(rating)
            let oldLikeCount = self.suggestion.likeCount
            let oldUserVotes = self.suggestion.userVotes
            
            // disable for a moment
            self.votingDisabled = true
            
            // TODO: check if it's own suggestion before send
            
            self.sendRating(self.suggestion.suggestionId, votes: votes, success: { () -> Void in
                
                self.suggestion.likeCount = oldLikeCount - oldUserVotes + votes
                self.suggestion.userVotes  = votes
                
                self.updateVoteTableHeader(self.suggestion.likeCount, votes: Float(votes))
                
                self.votingDisabled = false
                }) { () -> Void in
                    self.votingDisabled = false
            }
        }
    }
    
    /**
    Update SuggestionVote table header with new
    
    :param: likeCount likes
    :param: votes     user votes
    */
    func updateVoteTableHeader(likeCount: Int, votes: Float) {
        (self.mainTable.tableHeaderView as! UASuggestionVoteView).likeLabel.text = "\(likeCount)"
        (self.mainTable.tableHeaderView as! UASuggestionVoteView).ratingView.rating = votes
    }
    
    /**
    *  Send rating
    */
    func sendRating(id: UInt, votes: Int, success: () -> Void, failure: () -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/v1/suggestion/vote"
        
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
    
    // MARK: editor
    
    /**
    Open editor
    
    :param: sender
    */
    @IBAction func openEditor(sender: AnyObject) {
        var editor: UAEditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditorVC") as! UAEditorViewController
        
        weak var _self = self
        editor.setEditorTitle("New comment")
        editor.delegate = _self
        editor.string = (self.mainTable.tableHeaderView as! UASuggestionHeaderView).newCommentInput.text
        
//        1)
//        self.navigationController?.pushViewController(editor, animated: true)
//        2)
//        self.showViewController(editor, sender: self)
//        3)
        self.presentViewController(editor, animated: true, completion: nil)
    }
    
    func passTextBack(controller: UAEditorViewController, string: String) {
        (self.mainTable.tableHeaderView as! UASuggestionHeaderView).newCommentInput.text = string
    }
    
    @IBAction func sendNewComment(sender: AnyObject) {
        let newComment: String = (self.mainTable.tableHeaderView as! UASuggestionHeaderView).newCommentInput.text

        self.sendNewComment(newComment, success: { (json) -> () in
            (self.mainTable.tableHeaderView as! UASuggestionHeaderView).newCommentInput.text = ""
            
            let comment = UAComment().initCommentWithJSON(json as! Dictionary<String, AnyObject>)
            let array = [comment]
            
            // prepend new comment
            self.entries = array + self.entries
            
            // reload table
            self.mainTable.reloadData()
        }) { () -> () in
            
        }
    }
    
    
    @IBAction func openProject(sender: AnyObject) {
        var projectVC: ProjectViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Project") as! ProjectViewController
        
        // set project id
        projectVC.projectId = self.suggestion.projectId
        
        self.navigationController?.pushViewController(projectVC, animated: true)
    }
    
    func sendNewComment(comment: String, success: (json: AnyObject) -> (), failure: () -> ()) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var url: String = "\(APIURL)/api/mobile/comment/add"

        Alamofire.request(.POST, url, parameters: [
            "comment": comment,
            "suggestion": self.suggestion.suggestionId])
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil && JSON == nil) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    // print error
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
