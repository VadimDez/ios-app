//
//  SideMenuViewController.m
//  app_test
//
//  Created by Vadym on 15/02/14.
//  Copyright (c) 2014 Vadym. All rights reserved.
//

#import "SideMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
//#import "User.h"



@interface SideMenuViewController (){
//    User *user;
}

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menuIconsItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation SideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    CALayer *imageLayer = _profileImageView.layer;
    [imageLayer setCornerRadius:20];
    [imageLayer setMasksToBounds:YES];
    
//    user = [User sharedInstance];
//    [self loadUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@"Wall", @"Projects", @"Credits", @"Bookmarks",@"Activity", @"Settings"];
    
    return _menuItems;
}

- (NSArray *)menuIconsItems {
    if(_menuIconsItems) return _menuIconsItems;
    
    _menuIconsItems = @[@"wall",@"projects",@"credits",@"bookmarks",@"activity",@"settings"];
    return _menuIconsItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuItem = self.menuItems[indexPath.row];
    
    cell.textLabel.text = menuItem;
    cell.imageView.image = [UIImage imageNamed:self.menuIconsItems[indexPath.row]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuItem = self.menuItems[indexPath.row];
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if ([menuItem isEqualToString:@"Wall"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavi"];//self.transitionsNavigationController; // uncomment if want to save wall view
    } else if ([menuItem isEqualToString:@"Projects"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"projectsNavi"];
    } else if ([menuItem isEqualToString:@"Credits"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"creditsNavi"];
    } else if ([menuItem isEqualToString:@"Bookmarks"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bookmarksNavi"];
    } else if ([menuItem isEqualToString:@"Activity"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"activityNavi"];
    } else if ([menuItem isEqualToString:@"Settings"]) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsNavi"];
    }
    
    [self.searchField resignFirstResponder];
    [self.slidingViewController resetTopViewAnimated:YES];
}

//- (void) loadUserInfo
//{
//    NSString *url = [NSString stringWithFormat:@"https://%@/api/v1/user",APIIP];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:url parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        // save user info
//        user.id = [[[responseObject objectForKey:@"user"] objectForKey:@"id"] intValue];
//        user.profileImageURL = [NSString stringWithFormat:@"https://%@/media/profileimage/%i/200/200",APIIP,user.id];
//        user.fullname = [NSString stringWithFormat:@"%@ %@",[[responseObject objectForKey:@"user"] objectForKey:@"firstname"], [[responseObject objectForKey:@"user"] objectForKey:@"lastname"]];
//        // set user name and profile foto in menu
//        [self setUserInfoWithUser:user];
//        [self getProfileImageWithURL:user.profileImageURL];
////        [user setUserFullNameWitString:@"asd"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Activity error: %@",error);
//    }];
//    
//}

//- (void)setUserInfoWithUser:(User *)userInstance
//{
//    [[self userFullName] setText:userInstance.fullname];
//}

//-(void)getProfileImageWithURL:(NSString *)url
//{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    AFHTTPRequestOperation *postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    postOperation.responseSerializer = [AFImageResponseSerializer serializer];
//    [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        _profileImageView.image = responseObject;
//        [user setProfileImageView:_profileImageView];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Image error: %@", error);
//    }];
//    [postOperation start];
//}
@end
