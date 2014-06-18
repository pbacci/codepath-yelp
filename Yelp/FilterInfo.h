//
//  FilterInfo.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FilterInfo : NSObject <NSCopying>

typedef NS_ENUM(NSInteger, FilterType) {
    FilterTypeDistance,
    FilterTypeSort,
    FilterTypeDeals,
    FilterTypeCategory,
    FilterTypeCount,
};

typedef NS_ENUM(NSInteger, Distance) {
    DistanceAuto,
    Distance2BLOCKS,
    Distance6BLOCKS,
    Distance1MILE,
    Distance5MILES,
    DistanceCount,
};

typedef NS_ENUM(NSInteger, SortType) {
    SortTypeBestMatch,
    SortTypeDistance,
    SortTypeRating,
    SortTypeCount,
};

typedef NS_ENUM(NSInteger, Category) {
    CategoryArabian,
    CategoryArgentine,
    CategoryCambodian,
    CategoryChinese,
    CategoryEthiopian,
    CategoryFilipino,
    CategoryFrench,
    CategoryItalian,
    CategoryMediterranean,
    CategoryThai,
    CategoryCount,
};

@property (nonatomic, copy) NSString *searchTerm;
@property (nonatomic) Distance distance;
@property (nonatomic) SortType sortType;
@property (nonatomic) BOOL dealsOnly;
@property (nonatomic, strong) NSMutableSet *categories;
@property (nonatomic, strong) CLLocation *location;

- (id)initWithDefaults;
- (NSDictionary *)searchParams;

+ (NSString *)headerTitleForFilterType:(FilterType)filterType;
+ (NSString *)displayStringForDistance:(Distance)distance;
+ (NSString *)displayStringForSortType:(SortType)sortType;
+ (NSString *)displayStringForCategory:(Category)category;

@end
