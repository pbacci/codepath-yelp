//
//  FilterInfo.m
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterInfo.h"

@implementation FilterInfo

- (id)initWithDefaults {
    self = [super init];
    if (self) {
        self.distance = DistanceAuto;
        self.sortType = SortTypeBestMatch;
        self.dealsOnly = NO;
        self.location = nil;
        self.categories = [[NSMutableSet alloc] init];
    }
    return self;
}

- (NSDictionary *)searchParams
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.location != nil)
    {
        parameters[@"ll"] =  [self searchParamForLocation:self.location];
    }
    if (self.searchTerm != nil) {
        parameters[@"term"] = self.searchTerm;
    }
    if (self.distance != DistanceAuto) {
        parameters[@"radius_filter"] = [self searchParamForDistance:self.distance];
    }
    parameters[@"sort"] = [self searchParamForSortType:self.sortType];
    if (self.categories.count > 0) {
        parameters[@"category_filter"] = [self searchParamForCategories:self.categories];
    }
    else
    {
        parameters[@"category_filter"] = @"restaurants";
    }
    if (self.dealsOnly) {
        parameters[@"deals_filter"] = @"1";
    }
    return parameters;
}

- (NSString *)searchParamForLocation:(CLLocation *)location
{
    return [NSString stringWithFormat:@"%f,%f",
                             location.coordinate.latitude,
                             location.coordinate.longitude];
}

- (NSString *)searchParamForDistance:(Distance)distance
{
    switch (distance) {
        case Distance2BLOCKS:
            return @"100";
        case Distance6BLOCKS:
            return @"600";
        case Distance1MILE:
            return @"1600";
        case Distance5MILES:
            return @"8000";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid distance" userInfo:nil];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    FilterInfo *copy = [[FilterInfo allocWithZone:zone] init];
    copy.searchTerm = self.searchTerm;
    copy.distance = self.distance;
    copy.sortType = self.sortType;
    copy.dealsOnly = self.dealsOnly;
    copy.categories = [self.categories mutableCopy];
    return copy;
}

- (NSString *)searchParamForCategory:(Category)category
{
    return [[FilterInfo displayStringForCategory:category] lowercaseString];
}

+ (NSString *)displayStringForCategory:(Category)category
{
    switch (category) {
        case CategoryArabian:
            return @"Arabian";
        case CategoryArgentine:
            return @"Argentine";
        case CategoryCambodian:
            return @"Cambodian";
        case CategoryChinese:
            return @"Chinese";
        case CategoryEthiopian:
            return @"Ethiopian";
        case CategoryFilipino:
            return @"Filipino";
        case CategoryFrench:
            return @"French";
        case CategoryItalian:
            return @"Italian";
        case CategoryMediterranean:
            return @"Mediterranean";
        case CategoryThai:
            return @"Thai";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid category" userInfo:nil];
    }
}

- (NSString *)searchParamForCategories:(NSMutableSet *)categories
{
    NSString *param;
    for (NSNumber *category in categories) {
        NSString *categoryString = [self searchParamForCategory:[category intValue]];
        if (param == nil) {
            param = categoryString;
        } else {
            param = [param stringByAppendingFormat:@",%@", categoryString];
        }
    }
    return param;
}

- (NSString *)searchParamForSortType:(SortType)sortType
{
    return [[NSString alloc] initWithFormat:@"%d", sortType];
}

+ (NSString *)headerTitleForFilterType:(FilterType)filterType {
    switch (filterType) {
        case FilterTypeDistance:
            return @"Distance";
        case FilterTypeSort:
            return @"Sort By";
        case FilterTypeDeals:
            return @"Deals";
        case FilterTypeCategory:
            return @"Categories";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid filter type" userInfo:nil];
    }
}

+ (NSString *)displayStringForDistance:(Distance)distance
{
    switch (distance) {
        case DistanceAuto:
            return @"Auto";
        case Distance2BLOCKS:
            return @"2 blocks";
        case Distance6BLOCKS:
            return @"6 blocks";
        case Distance1MILE:
            return @"1 Mile";
        case Distance5MILES:
            return @"5 Miles";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid distance" userInfo:nil];
    }
}

+ (NSString *)displayStringForSortType:(SortType)sortType
{
    switch (sortType) {
        case SortTypeBestMatch:
            return @"Best Match";
        case SortTypeDistance:
            return @"Distance";
        case SortTypeRating:
            return @"Rating";
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid sort type" userInfo:nil];
    }
}

@end
