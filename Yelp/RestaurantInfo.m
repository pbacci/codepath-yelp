//
//  RestaurantInfo.m
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "RestaurantInfo.h"

@implementation RestaurantLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"address"  : @"address",
             @"city"  : @"city",
             @"crossStreets"  : @"cross_streets",
             @"neighborhoods"  : @"neighborhoods",
             @"countryCode"  : @"country_code",
             @"postalCode"  : @"postal_code",
             @"stateCode"  : @"state_code",
             };
}

@end


@implementation RestaurantInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id"                  : @"id",
             @"name"                : @"name",
             @"url"                 : @"url",
             @"imageUrl"            : @"image_url",
             @"distance"            : @"distance",
             @"location"            : @"location",
             @"phone"               : @"phone",
             @"displayPhone"        : @"display_phone",
             @"rating"              : @"rating",
             @"ratingImageUrl"      : @"rating_img_url",
             @"reviewCount"         : @"review_count",
             @"snippetText"         : @"snippet_text",
             @"snippetImageUrl"     : @"snippet_image_url",
             @"categories"          : @"categories",
             };
}

+ (NSValueTransformer *)locationJSONTransformer {

    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *locationDict) {
        return [MTLJSONAdapter modelOfClass: RestaurantLocation.class
                         fromJSONDictionary: locationDict
                                      error: nil];
    } reverseBlock:^(RestaurantLocation *location) {
        return [MTLJSONAdapter JSONDictionaryFromModel: location];
    }];
}


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)snippetImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)ratingImageUrlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

- (NSString *)formatCategoryString
{
    NSString *ret;
    for (NSArray *category in self.categories)
    {
        if (ret == nil) {
            ret = category[0];
        } else {
            ret = [ret stringByAppendingFormat:@", %@", category[0]];
        }
    }
    return ret == nil ? @"" : ret;
}

- (NSString *)formatAddress
{
    if (self.location.address != nil && [self.location.address count] > 0)
    {
        return self.location.address[0];
    }
    else
    {
        return @"";
    }
}

@end
