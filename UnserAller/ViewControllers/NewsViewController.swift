//
//  NewsViewController.swift
//  UnserAller
//
//  Created by Vadim Dez on 04/06/15.
//  Copyright (c) 2015 Vadym Yatsyuk. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var container: UIView!
    
    
    var news: UANews!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.news != nil) {
            self.titleLabel.text = self.news.title
            self.contentLabel.text = self.news.content
            self.dateLabel.text = self.news.updated.getStringFromDate()
        
//        self.automaticallyAdjustsScrollViewInsets = false
        }
        self.setHeaderHeight()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        var screen: CGRect = UIScreen.mainScreen().applicationFrame
//        self.scrollView.frame = CGRect(x: 0, y: 0, width: screen.width, height: 5000)
//        self.container.frame = CGRect(x: 0, y: 0, width: screen.width, height: 5000)
//        self.view.frame = CGRect(x: 0, y: 0, width: screen.width, height: 5000)
    }
    
    // MARK: - Table Delegates
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func setHeaderHeight() {
        let base: CGFloat = 42.0
        let width = self.tableView.tableHeaderView?.frame.size.width
        var height: CGFloat = base
        let labelWidth = UIScreen.mainScreen().applicationFrame.width - 20
        
        if (self.news != nil) {
            if let title = self.news.title {
                height += title.getHeightForView(labelWidth, font: UIFont(name: "Helvetica Neue", size: 14.0)!)
            }
            
            if let content = self.news?.content {
                height += content.getHeightForView(labelWidth, font: UIFont(name: "Helvetica Neue", size: 13.0)!)
            }
        }
        
        self.tableView.tableHeaderView?.frame = CGRect(x: 0.0, y: 0.0, width: width!, height: height)
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
}
