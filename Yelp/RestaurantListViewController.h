//
//  RestaurantListViewController.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterInfo.h"
#import "FiltersViewController.h"

@interface RestaurantListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, FiltersViewControllerDelegate>

@property (nonatomic, strong) FilterInfo *filterInfo;

@end
