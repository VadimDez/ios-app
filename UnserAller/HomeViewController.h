//
//  HomeViewController.h
//  app_test
//
//  Created by Vadym on 18/12/13.
//  Copyright (c) 2013 Vadym. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KeychainItemWrapper.h"
#import <AFNetworking.h>
//#import "UITableView+DragLoad.h"
//#import "NSString_stripHtml_XMLParsee.h"
//#import "ProjectViewController.h"
#import "ECSlidingViewController.h"
//#import <UIViewController+ScrollingNavbar.h>
//#import "UACellViewModel.h"
//#import "NewsCell.h"
//#import "ContainerTableCell.h"
//#import "NewsContainerTableCell.h"
//#import "IDMPhoto.h"
//#import "IDMPhotoBrowser.h"
//#import "VoteSuggestionTableViewCell.h"
//#import "Suggestion.h"
//#import "UASuggestionViewModel.h"
//#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
//#import "SuggestionCell.h"
//#import "NewsCell.h"
//#import <objc/runtime.h>

@interface HomeViewController : UIViewController </*UITableViewDataSource, UITableViewDelegate, UITableViewDragLoadDelegate, */ECSlidingViewControllerDelegate/*, IDMPhotoBrowserDelegate, RatingViewDelegate*/>
{
    NSArray *wallRecords;
    NSMutableDictionary *heightList;
    int projectId;
    // array of objects
    NSArray *entries;
}

//@property (assign, nonatomic) NSInteger wallRecordsQuantity;
//@property (assign, nonatomic) NSInteger page;
//@property (weak, nonatomic) IBOutlet UITableView *wallTable;

//- (IBAction)menuButton:(id)sender;

// functions
//- (void)getEntitiesWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;
//- (void)finishRefresh;
//- (void)finishLoadMore;
//- (NewsCell*)NewsCell:(NSInteger)row;
//- (NewsContainerTableCell*)NewsContainerTableCell:(NSInteger)row;
//- (VoteSuggestionTableViewCell*)VoteSuggestionTableCell:(NSInteger)row;
//- (ContainerTableCell*)ContainerTableCell:(NSInteger)row;
//- (VoteSuggestionCell*)VoteSuggestionCell:(NSInteger)row;
//- (SuggestionCell*)SuggestionCell:(NSInteger)row;
////- (SuggestionCell*)getSuggestionCellForRow:(NSInteger)row;
////- (UITableViewCell*)getSuggestionWithImageCellForRow:(NSInteger)row;
////- (NewsCell*)getNewsCellForRow:(NSInteger)row;
//- (void) didSelectGoToFromCollectionView:(NSNotification *)notification;
@end
