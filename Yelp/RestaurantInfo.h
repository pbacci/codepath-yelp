//
//  RestaurantInfo.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Mantle/Mantle.h"

@interface RestaurantLocation : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSArray *address;
@property (nonatomic, strong, readonly) NSString *city;
@property (nonatomic, strong, readonly) NSString *crossStreets;
@property (nonatomic, strong, readonly) NSArray *neighborhoods;
@property (nonatomic, strong, readonly) NSString *countryCode;
@property (nonatomic, strong, readonly) NSString *postalCode;
@property (nonatomic, strong, readonly) NSString *stateCode;

@end

@interface RestaurantInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *id;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) NSURL *imageUrl;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) RestaurantLocation *location;
@property (nonatomic, strong, readonly) NSString *displayPhone;
@property (nonatomic, strong, readonly) NSString *phone;
@property (nonatomic, readonly) NSNumber *distance;
@property (nonatomic, readonly) NSNumber *rating;
@property (nonatomic, strong, readonly) NSURL *ratingImageUrl;
@property (nonatomic, readonly) NSNumber *reviewCount;
@property (nonatomic, strong, readonly) NSString *snippetText;
@property (nonatomic, strong, readonly) NSURL *snippetImageUrl;
@property (nonatomic, strong, readonly) NSArray *categories;

- (NSString *)formatCategoryString;
- (NSString *)formatAddress;

@end
