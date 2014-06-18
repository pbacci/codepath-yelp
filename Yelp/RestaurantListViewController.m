//
//  RestaurantListViewController.m
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "RestaurantListViewController.h"
#import "RestaurantCell.h"
#import "YelpClient.h"
#import "RestaurantInfo.h"
#import "MTLModel.h"
#import "MBProgressHUD.h"

NSString * const kYelpConsumerKey = @"87eGDdYpEfc3Ke_lqToe9w";
NSString * const kYelpConsumerSecret = @"kMCLE6yuDdnIp74Q4-5jgQ4oxhg";
NSString * const kYelpToken = @"y5pcszQDPqXZ-zX1kpULd-iI6ApNQUla";
NSString * const kYelpTokenSecret = @"C3gPYbrLbNcim3ijergnYzq59Ec";

@interface RestaurantListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) YelpClient *yelpClient;
@property (strong, nonatomic) NSArray *restaurantList;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) UIBarButtonItem *filterButton;
@property (strong, nonatomic) RestaurantCell *stubCell;

@end

@implementation RestaurantListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.yelpClient = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];

        self.filterInfo = [[FilterInfo alloc] initWithDefaults];
        // Initialize the location manager and retrieve the current location. On update, we'll trigger fetching
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.tintColor = [UIColor blackColor];
    searchBar.delegate = self;
    self.filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButtonPress)];
    self.filterButton.enabled = YES;

    // init the nav bar
    self.navigationItem.titleView = searchBar;
    self.navigationItem.leftBarButtonItem = self.filterButton;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.locationManager.delegate = self;

    UINib *cellNib = [UINib nibWithNibName:@"RestaurantCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"RestaurantCell"];
    self.stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];

    // Trigger the update loop
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateLocation];
}

- (void)onFilterButtonPress
{
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.filterInfo = self.filterInfo;
    fvc.delegate = self; // make sure the filter view can return the updated filters
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [self.yelpClient searchWithFilters:self.filterInfo.searchParams success:^(AFHTTPRequestOperation *operation, id response)
     {
         NSMutableArray *tmp = [[NSMutableArray alloc] init];
         for (NSDictionary *restaurantInfo in response[@"businesses"])
         {
             NSError *error = nil;
             RestaurantInfo *ri = [MTLJSONAdapter modelOfClass:RestaurantInfo.class fromJSONDictionary:restaurantInfo error:&error];

             // TODO: error handling
             if (error == nil)
             {
                 [tmp addObject:ri];
             }
         }
         self.restaurantList = tmp;
         [self.tableView reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Network error" message: error.description delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.restaurantList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantCell *restaurantCell = [tableView dequeueReusableCellWithIdentifier:@"RestaurantCell"];
    [restaurantCell setRestaurantInfo:self.restaurantList[indexPath.row] rowId:indexPath.row];
    return restaurantCell;
}

- (void)configureCell:(RestaurantCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setRestaurantInfo:self.restaurantList[indexPath.row] rowId:indexPath.row];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateLocation];
}

#pragma mark - LocationManager
- (void)updateLocation
{
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.filterInfo.location = newLocation;
    [self.locationManager stopUpdatingLocation];
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.stubCell setRestaurantInfo:self.restaurantList[indexPath.row] rowId:0];
    [self.stubCell layoutSubviews];
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

# pragma mark - SearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.filterInfo.searchTerm = searchBar.text;
    // Trigger the update loop
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateLocation];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        NSString *prevSearchTerm = self.filterInfo.searchTerm;
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
        if (prevSearchTerm != nil)
        {
            self.filterInfo.searchTerm = nil;
            // Trigger the update loop
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self updateLocation];
        }
    }
}

// Hack to hide the keyboard when the searchbar is cleared (http://stackoverflow.com/questions/1092246/uisearchbar-clearbutton-forces-the-keyboard-to-appear/3852509#3852509)
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

@end
