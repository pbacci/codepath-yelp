//
//  FiltersViewController.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterInfo.h"

@protocol FiltersViewControllerDelegate <NSObject>

- (void)updateLocation;
@property (nonatomic, strong) FilterInfo *filterInfo;

@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) FilterInfo *filterInfo;
@property (nonatomic, retain) id <FiltersViewControllerDelegate> delegate;

@end
