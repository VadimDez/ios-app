//
//  HomeViewController.m
//  app_test
//
//  Created by Vadym on 18/12/13.
//  Copyright (c) 2013 Vadym. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController (){
    bool hasImages;
}

@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
//    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
//    self.slidingViewController.customAnchoredGestures = @[];
//    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
//    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // set side menu
//    NSDictionary *transitionData = self.transitions.all[3];
//    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
//    self.slidingViewController.delegate = transition;
//    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
//    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
//    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
//    [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
//    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // side menu
//    self.clearsSelectionOnViewWillAppear = NO;
    
//    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
//    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
//    self.slidingViewController.customAnchoredGestures = @[];
//    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
//    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
//    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserAuthToken" accessGroup:nil];
    //NSLog(@"%@, %@", [keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)], [keychainWrapper objectForKey:(__bridge id)(kSecValueData)]);
    
//    _wallRecordsQuantity = 0;
//    _page = 0;
    
    // adjust the view
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // hide nav bar
//    [self followScrollView:self.wallTable];
    
    // delegates
//    self.wallTable.dataSource = self;
//    self.wallTable.delegate = self;
//    [self.wallTable setDragDelegate:self refreshDatePermanentKey:@"wall"];
//    self.wallTable.showLoadMoreView   = YES;
//    self.wallTable.showRefreshView    = YES;
    
    // Register the table cell
//    [self.wallTable registerClass:[ContainerTableCell class] forCellReuseIdentifier:@"ContainerTableCell"];
//    [[self wallTable] registerNib:[UINib nibWithNibName:@"ContainerTableCell" bundle:nil] forCellReuseIdentifier:@"ContainerTableCell"];
//    [[self wallTable] registerNib:[UINib nibWithNibName:@"SuggestionCell" bundle:nil] forCellReuseIdentifier:@"SuggestionCell"];
//    [[self wallTable] registerNib:[UINib nibWithNibName:@"VoteSuggestionCell" bundle:nil] forCellReuseIdentifier:@"VoteSuggestionCell"];
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectGoToFromCollectionView:) name:@"didSelectGoToFromCollectionView" object:nil];
    
    [self getEntitiesWithSuccess:^{
        
    } failure:^(NSError *error) {
        
    }];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - Properties

- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

/**
 *  Set number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

/**
 *  Set number of rows
 */
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return _wallRecordsQuantity;
//}

/**
 *  Return suggestion cell
 */
//- (UITableViewCell*)getSuggestionCellForRow:(NSInteger)row {
//    return ([[[wallRecords objectAtIndex:row] objectForKey:@"type"] isEqualToString:@"suggest"]) ? [self getSuggestionSuggestCellForRow:row] : [self getSuggestionVoteCellForRow:row];
//}

/**
 *  Get suggest Cell
 */
//- (SuggestionCell*)getSuggestionSuggestCellForRow:(NSInteger)row {
//- (SuggestionCell*)SuggestionCell:(NSInteger)row {
//    Suggestion *suggestion = (Suggestion *)[entries objectAtIndex:row];
////    static NSString *CellIdentifier = @"SuggestionCell";
//    
//    SuggestionCell *cell = (SuggestionCell*)[[self wallTable] dequeueReusableCellWithIdentifier:[suggestion cellType]];
//    
//    if(cell == nil) {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[suggestion cellType] owner:self options:nil];
//        cell = topLevelObjects[0];
//    }
//    
//    
////    [cell setViewController:self];
//    [cell setSuggestion:suggestion];
//    
//    [[cell commentButton] setTag:row];
//    [[cell commentButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    [[cell goToProjectButton] setTag:row];
//    [[cell goToProjectButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    return cell;
//}

/**
 *  Get vote cell
 */
//- (VoteSuggestionCell*)getSuggestionVoteCellForRow:(NSInteger)row {
//- (VoteSuggestionCell*)VoteSuggestionCell:(NSInteger)row {
//    Suggestion *suggestion = (Suggestion *)[entries objectAtIndex:row];
//
////    static NSString *CellIdentifier = @"VoteSuggestionCell";
//    
//    VoteSuggestionCell *cell = (VoteSuggestionCell*)[[self wallTable] dequeueReusableCellWithIdentifier:[suggestion cellType]];
//    
//    if(cell == nil) {
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[suggestion cellType] owner:self options:nil];
//        cell = topLevelObjects[0];
//    }
//    //    [cell setViewController:self];
//    
//    // assign
//    [cell setHomeVoteSuggestionWithSuggestion:suggestion];
//    
//    // rating
//    [[cell rating] setTag:row];
//    [cell rating].value = [suggestion userVotes];
//    [cell rating].delegate = self;
//    
//    // action buttons
//    [[cell commentButton] setTag:row];
//    [[cell commentButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    [[cell goToProjectButton] setTag:row];
//    [[cell goToProjectButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    return cell;
//}


//- (UITableViewCell*)getSuggestionWithImageCellForRow:(NSInteger)row {
//    return ([[[wallRecords objectAtIndex:row] objectForKey:@"type"] isEqualToString:@"suggest"]) ? [self getSuggestionSuggestWithImageCellForRow:row] : [self getSuggestionVoteWithImageCellForRow:row];
//}

//- (ContainerTableCell*)getSuggestionSuggestWithImageCellForRow:(NSInteger)row {
//- (ContainerTableCell*)ContainerTableCell:(NSInteger)row {
//    Suggestion *suggestion = (Suggestion *)[entries objectAtIndex:row];
//    ContainerTableCell *cell = (ContainerTableCell *)[[self wallTable] dequeueReusableCellWithIdentifier:[suggestion cellType]];
//    
//    if(cell == nil){
////        cell = [[ContainerTableCell alloc] init];
//        cell = [[ContainerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[suggestion cellType]];
//    }
////    NSDictionary *cellData = [_objects objectAtIndex:[indexPath section]];  // Note we're using section, not row here
////    NSArray *articleData = [cellData objectForKey:@"articles"];
//    
//    
//    
//    [cell setCollectionData:suggestion];
//    
//    [[[cell collectionView] projectButton] setTag:row];
//    [[[cell collectionView] projectButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    return cell;
//}

//- (VoteSuggestionTableViewCell*)getSuggestionVoteWithImageCellForRow:(NSInteger)row {
//- (VoteSuggestionTableViewCell*)VoteSuggestionTableCell:(NSInteger)row {
//    Suggestion *suggestion = (Suggestion *)[entries objectAtIndex:row];
//    
//    VoteSuggestionTableViewCell *cell = (VoteSuggestionTableViewCell*)[[self wallTable] dequeueReusableCellWithIdentifier:[suggestion cellType]];
//    
//    if(cell == nil){
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[suggestion cellType] owner:self options:nil];
//        cell = topLevelObjects[0];
//    }
//    
//    // rating
//    [[cell rating] setTag:row];
//    [cell rating].delegate = self;
//    [cell rating].value = [suggestion userVotes];
//    
//    // set data
//    [cell setCellData:suggestion];
//    
//    // set actions
//    [[cell commentButton] setTag:row];
//    [[cell commentButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    [[cell goToProjectButton] setTag:row];
//    [[cell goToProjectButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    return cell;
//}

/**
 *  News cell with images
 */
//- (NewsContainerTableCell*)getNewsWithImageCellForRow:(NSInteger)row {
//-(NewsContainerTableCell*)NewsContainerTableCell:(NSInteger)row {
//    
//    NewsContainerTableCell *cell = [self.wallTable dequeueReusableCellWithIdentifier:[(Suggestion *)[entries objectAtIndex:row] cellType]];
//    if(cell == nil){
////        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[(Suggestion *)[entries objectAtIndex:row] cellType] owner:self options:nil];
////        cell = topLevelObjects[0];
//        cell = [[NewsContainerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[(Suggestion *)[entries objectAtIndex:row] cellType]];
//    }
//    
//    [cell setCollectionDataWithSuggestion:[entries objectAtIndex:row]];
//    
//    return cell;
//}

//- (NewsCell*)getNewsCellForRow:(NSInteger)row {
//- (NewsCell*)NewsCell:(NSInteger)row {
//    Suggestion *suggestion = (Suggestion *)[entries objectAtIndex:row];
//    
//    NewsCell *cell = (NewsCell*)[[self wallTable] dequeueReusableCellWithIdentifier:[suggestion cellType]];
//    
//    if(cell == nil){
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[suggestion cellType] owner:self options:nil];
//        cell = topLevelObjects[0];
//    }
//    
//    [cell setNewsWithDictionary:suggestion];
//    
//    [[cell goToProjectButton] setTag:row];
//    [[cell goToProjectButton] addTarget:self action:@selector(showProjectWithButton:) forControlEvents:UIControlEventTouchDown];
//    
//    return cell;
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",[[entries objectAtIndex:[indexPath row]] cellType]]);
////    if([self respondsToSelector:selector]){
////        NSLog(@"%@", [self performSelector:selector withObject:[entries objectAtIndex:[indexPath row]] afterDelay:0.0f]);
////    }
////    return nil;
////    NSLog(@"%@", [[entries objectAtIndex:[indexPath row]] cellType]);
//    
////    UITableViewCell *returnedCell;
////    NSInteger row = [indexPath row];
////    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", [[entries objectAtIndex:row] cellType]]);
////    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
////    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
////    [inv setTarget:self];
////    [inv setSelector:sel];
////    [inv setArgument:&row atIndex:2];
////    [inv invoke];
////    [inv getReturnValue:&returnedCell];
////
////    return returnedCell;
//    
//    
//    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", [[entries objectAtIndex:[indexPath row]] cellType]]);
//    return objc_msgSend(self, sel, [indexPath row]);
//    
////    return [self getCellForRow:indexPath.row];
//}

/**
 * Get cell for row
 */
//- (UITableViewCell*)getCellForRow:(NSInteger)row{
//    return (![[[wallRecords objectAtIndex:row] objectForKey:@"suggestion"] isKindOfClass:[NSNull class]]) ? ([[wallRecords objectAtIndex:row] objectForKey:@"media"]) ? [self getSuggestionWithImageCellForRow:row] : [self getSuggestionCellForRow:row] : [self getNewsCellForRow:row];
//}

/**
 * Set height for cell
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UACellViewModel *cellViewModel = [[UACellViewModel alloc] init];
//    float imageViewSize = 0.0f;
//    
//    if([[entries objectAtIndex:[indexPath row]] media]){
//        int heightOfCollectionViewForImages = ((int)[[[entries objectAtIndex:[indexPath row]] media] count] / 5) * 50;
//        imageViewSize = 23.0f + heightOfCollectionViewForImages + 50.0f;
//    }
//    
//    CGFloat height = [cellViewModel getSuggestionSizeWithSuggestionStringWithHtmlTags:[[(Suggestion *)[entries objectAtIndex:[indexPath row]] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] andWithCharactersPerLine:31 andFontSize:14.0f] + 114.0f + imageViewSize; // 50 for collection view
//    return height;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat h = [self heightForBasicCellAtIndexPath:indexPath];
//    NSLog(@"%f",h);
//    return h;
//}

//- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *sizingCell = nil;
////    dispatch_once_t onceToken;
////    dispatch_once(&onceToken, ^{
//        NSString *cellType = [[entries objectAtIndex:[indexPath row]] cellType];
////        NSLog(@"1: %@",cellType);
//        sizingCell = [self.wallTable dequeueReusableCellWithIdentifier: cellType];
//        if(sizingCell == nil){
////            NSLog(@"2: %@",cellType);
//            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellType owner:self options:nil];
//            sizingCell = topLevelObjects[0];
//            
////
////            if ([cellType isEqualToString:@"SuggestionCell"]) {
////                sizingCell = [[SuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            } else if ([cellType isEqualToString:@"NewsCell"]) {
////                sizingCell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            } else if ([cellType isEqualToString:@"VoteSuggestionCell"]) {
////                sizingCell = [[VoteSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            } else if ([cellType isEqualToString:@"ContainerTableCell"]) {
////                sizingCell = [[ContainerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            } else if ([cellType isEqualToString:@"NewsContainerTableCell"]) {
////                sizingCell = [[NewsContainerTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            } else if ([cellType isEqualToString:@"VoteSuggestionTableCell"]) {
////                sizingCell = [[VoteSuggestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
////            }
//        }
////    });
//    
//    [self configureBasicCell:sizingCell atIndexPath:indexPath];
//    return [self calculateHeightForConfiguredSizingCell:sizingCell];
//}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

/**
 *  configure cell
 */
//- (void)configureBasicCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    Suggestion *suggestion = [entries objectAtIndex:[indexPath row]];
//    if ([[suggestion cellType] isEqualToString:@"SuggestionCell"]) {
//        [(SuggestionCell*)cell setSuggestion:suggestion];
//    } else if ([[suggestion cellType] isEqualToString:@"NewsCell"]) {
//        [(NewsCell*)cell setNewsWithDictionary:suggestion];
//    } else if ([[suggestion cellType] isEqualToString:@"VoteSuggestionCell"]) {
//        [(VoteSuggestionCell*)cell setHomeVoteSuggestionWithSuggestion:suggestion];
//    } else if ([[suggestion cellType] isEqualToString:@"ContainerTableCell"]) {
//        [(ContainerTableCell *)cell setCollectionData:suggestion];
//    } else if ([[suggestion cellType] isEqualToString:@"NewsContainerTableCell"]) { NSLog(@"NewsContainerTableCell");
//        [(NewsContainerTableCell *)cell setCollectionDataWithSuggestion:suggestion];
//    } else if ([[suggestion cellType] isEqualToString:@"VoteSuggestionTableCell"]) {
//        NSLog(@"%@",[cell class]);
//        [(VoteSuggestionTableViewCell *)cell setCellData:suggestion];
//    }
//}

/**
 *  Table cell is pressed
 */
#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{   // check if it's suggestion
//    Suggestion *suggestion = (Suggestion*)[entries objectAtIndex:[indexPath row]];
//    
//    if([suggestion suggestionId] > 0 )//if(![[[wallRecords objectAtIndex:indexPath.row] objectForKey:@"suggestion"] isKindOfClass:[NSNull class]])
//    {
//        SuggestionViewController *suggestionVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"Suggestion"];
//        suggestionVC.suggestionId = [suggestion suggestionId];
//        [self.navigationController pushViewController:suggestionVC animated:YES];
//    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


#pragma mark - Drag delegate methods
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView {
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.5];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.5];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)finishLoadMore {
    // increase page
    _page++;
    
    // get new projects
    [self getEntitiesWithSuccess:^{
        [[self wallTable] finishLoadMore];
    } failure:^(NSError *error) {
        
    }];
    
    //    UIEdgeInsets inset = UIEdgeInsetsMake(50, 0, 0, 0);
    //    self.projectList.scrollIndicatorInsets = inset;
}

/**
 *  Finish table refresh
 */
- (void)finishRefresh {
    _page = 0;
    entries = nil;
    [self getEntitiesWithSuccess:^{
        // set refresh as finished
        [[self wallTable] finishRefresh];
    } failure:^(NSError *error) {
        
    }];
}

/**
 * Get wall records BLOCK
 *
 */
- (void)getEntitiesWithSuccess:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"https://%@/api/mobile/profile/getwall/?page=%ld",APIIP,(long)_page ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject count] > 0){
            if([[responseObject objectAtIndex:0] count] > 0){
                
                // get suggestions objects
                UASuggestionViewModel *suggestionViewModel = [[UASuggestionViewModel alloc] init];
                NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:entries];
                [set2 addObjectsFromArray:[suggestionViewModel getSuggestionsFromJSON:responseObject]];
                entries = [set2 array];
                
                _wallRecordsQuantity = (NSInteger)[entries count];
                
                // reload table;
                [self.wallTable reloadData];
            } else {
                // make something when wall list is empty
                
            }
        }
        if(success)
            success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // if caller provided a failure block, call that
        if(failure)
            failure(error);
    }];
}

- (void)showProjectWithButton:(UIButton *)sender
{
    // get indexPath
    CGRect buttonFrameInTableView = [sender convertRect:sender.bounds toView:_wallTable];
    NSIndexPath *indexPath = [_wallTable indexPathForRowAtPoint:buttonFrameInTableView.origin];
    // go to the proj
    ProjectViewController *project = [[self storyboard] instantiateViewControllerWithIdentifier:@"project"];
    project.projectId = [(Suggestion *)[entries objectAtIndex:[indexPath row]] projectId];
    [self.navigationController pushViewController:project animated:YES];
    [self.wallTable deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  Show side menu button
 */
- (IBAction)menuButton:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) didSelectItemFromCollectionView:(NSNotification *)notification {
    NSDictionary *cellData = [notification object];
    if (cellData) {
        // Create an array to store IDMPhoto objects
        NSMutableArray *photos = [NSMutableArray new];
        for (UAMedia *media in [cellData objectForKey:@"media"]) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@/media/crop/%@/%u/%u",APIIP,[media hash], [media width], [media height]]]];
            [photos addObject:photo];
        }
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
        browser.displayArrowButton = NO;
        browser.delegate = self;
        browser.displayCounterLabel = YES;
        
        [browser setInitialPageIndex: [[cellData objectForKey:@"actual"] intValue]];
        [self presentViewController:browser animated:YES completion:nil];
    }
}

- (void) didSelectGoToFromCollectionView:(NSNotification *)notification {
    SuggestionViewController *suggestionVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"Suggestion"];
    suggestionVC.suggestionId = [[notification object] intValue];
    [self.navigationController pushViewController:suggestionVC animated:YES];
}

/* On rating
 *
 */
//-(void)rateChanged:(RatingView *)sender {
//    // get suggestion id from array
//    Suggestion *suggestion = (Suggestion*)[entries objectAtIndex:[sender tag]];
//    
//    
//    // add activity indicator
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    // send vote
//    NSString *url = [NSString stringWithFormat:@"https://%@/api/v1/suggestion/vote/%i?votes=%i",APIIP, [suggestion suggestionId], (int)sender.value ];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // if response JSON format
//    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSLog(@"%@",responseObject);
//        [sender setTintColor:[UIColor redColor]];
//        
//        // count new likes value
//        int newUserVotes = [[self getValueFromString:[responseObject objectForKey:@"voteSuggestion"]] intValue];
//        int total = [(Suggestion *)[entries objectAtIndex:[sender tag]] likeCount] + newUserVotes - [(Suggestion*)[entries objectAtIndex:[sender tag]] userVotes];
//        
//        // set new values
//        [(Suggestion *)[entries objectAtIndex:[sender tag]] setUserVotes: newUserVotes];
//        [(Suggestion *)[entries objectAtIndex:[sender tag]] setLikeCount: total];
//        // reload table view
//        [_wallTable reloadData];
//        
//        
//        // remove activity indicator
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"%@", error);
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    }];
//}

- (NSString*)getValueFromString:(NSString*)string {
    return [NSString stringWithFormat:@"%@", ([string isKindOfClass:[NSNull class]]) ? @"0" : string];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.1];
	
	return YES;
}

-(void) viewWillDisappear:(BOOL)animated {
    [self showNavbar];
    [super viewWillDisappear:animated];
}
@end
