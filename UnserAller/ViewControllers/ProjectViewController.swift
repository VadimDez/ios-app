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
    var entries: [UASuggestion] = []
    var page: UInt = 0
    var actualPhaseId: UInt = 0
    var phasesArray: [UAPhase] = []
    var companyId: UInt = 0
    var bookmarked: Bool = false
    
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
        
        //
        self.loadProject()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        return UITableViewCell()
    }
    
    /**
     * Collection view delegates
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        var cell = self.phaseCollection.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
//        cell.backgroundColor = UIColor.redColor()
//        return cell
    
        
        var cell:UAPhaseCell = self.phaseCollection.dequeueReusableCellWithReuseIdentifier("UAPhaseCell", forIndexPath: indexPath) as UAPhaseCell
        println(cell)
        cell.setPhaseName("asd")
//        cell.setPhaseName(self.entries[indexPath.row - 1].name)
        
        let totalPhases = self.phasesArray.count
        if ((totalPhases - indexPath.row) == 0) {
            // last element
            cell.lastElement()
        }
        if ((totalPhases - indexPath.row + 1) == totalPhases) {
            // first element
            cell.firstElement()
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
            
            label.text = "asd"
            label.font = UIFont(name: "Helvetica Neue", size: 14)
            label.numberOfLines = 1
            label.sizeToFit()
            
            
            size.width = 20.0 + label.frame.width;
        }
        println(size)
        return size;
    }
    
    func loadProject() {
        // build URL
        let url: String = "https://\(APIURL)/api/mobile/project/get/\(self.projectId)"
        
        // get entries
        Alamofire.request(.GET, url)
            .responseJSON { (_,_,JSON,errors) in
                
                if(errors != nil || JSON?.count == 0) {
                    // print error
                    println(errors)
                } else {
                    // update project info
                    self.updateProjectInfoWithDictionary(JSON?.objectForKey("project") as Dictionary<String, AnyObject>)
                }
        }
    }
    
    // set update project info
    func updateProjectInfoWithDictionary(dictionary: Dictionary<String, AnyObject>) {
        //set the data
        if let company = dictionary["company"] as? Dictionary<String, AnyObject> {
            self.companyId = company["id"] as UInt
            
            self.projectCompanyName.setTitle(company["name"] as? String, forState: UIControlState.Normal)
        }
        self.projectName.text = dictionary["name"] as? String
        self.navigationItem.title = dictionary["name"] as? String

        // project image
        let imageHash: String = dictionary["image"] as String
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
    func loadPhases() {
        
//    NSString *url = [NSString stringWithFormat:@"https://%@/api/mobile/project/getphases/%u",APIIP,_projectId];
//    //    NSLog(@"%@",self.projectId);
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//    // typecast an array and list its
//    
//    //
//    UAProjectViewModel *projectViewModel = [[UAProjectViewModel alloc] init];
//    phasesArray     = [projectViewModel getPhasesFromJson:[responseObject objectForKey:@"phases"]];
//    
//    _phasesQuantity = [phasesArray count];
//    actualPhaseId = [[phasesArray objectAtIndex:0] phaseId];
//    
//    // reload table
//    [_phasesList reloadData];
//    [_phaseCollection reloadData];
//    
//    [self loadPhaseInfoWithPhaseId:actualPhaseId WithSuccess:^{
//    
//    } failure:^(NSError *error) {
//    
//    }];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    NSLog(@"error: %@",error);
//    }];
    }
}
