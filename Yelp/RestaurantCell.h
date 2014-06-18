//
//  RestaurantCell.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantInfo.h"

@interface RestaurantCell : UITableViewCell

- (void)setRestaurantInfo:(RestaurantInfo *)restaurantInfo rowId:(NSInteger)rowId;

@end
