//
//  SideMenuViewController.h
//  app_test
//
//  Created by Vadym on 15/02/14.
//  Copyright (c) 2014 Vadym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface SideMenuViewController : UIViewController <UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchField;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *userFullName;


@end
