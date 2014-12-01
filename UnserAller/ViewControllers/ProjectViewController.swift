//
//  ProjectViewController.swift
//  UnserAller
//
//  Created by Vadym on 30/11/14.
//  Copyright (c) 2014 Vadym Yatsyuk. All rights reserved.
//

import UIKit

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

    
    var projectId: UInt = 0
    var entries: [UASuggestion] = []
    var page: UInt = 0
    var actualPhaseId: UInt = 0
    var phasesArray: [UAPhase] = []
    
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
        println(flowLayout)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.itemSize = CGSize(width: 320, height: 30)// CGSizeMake(320, 50)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = 0
        
        self.phaseCollection.collectionViewLayout = flowLayout
        self.phaseCollection.bounces = true
        self.phaseCollection.showsHorizontalScrollIndicator = false
        self.phaseCollection.showsVerticalScrollIndicator = false
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
        return 1
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}
