//
//  RestaurantCell.m
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "RestaurantCell.h"
#import "UIImageView+AFNetworking.h"

@interface RestaurantCell ()


@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;

@end

@implementation RestaurantCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRestaurantInfo:(RestaurantInfo *)restaurantInfo rowId:(NSInteger)rowId
{
    [self.thumbImage setImageWithURL:restaurantInfo.imageUrl];
    [self.ratingImage setImageWithURL:restaurantInfo.ratingImageUrl];
    CALayer * l = [self.thumbImage layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];

    self.nameLabel.text = [NSString stringWithFormat:@"%d. %@", rowId + 1, restaurantInfo.name];
    [self.nameLabel sizeToFit];

    self.addressLabel.text = [restaurantInfo formatAddress];
    [self.addressLabel sizeToFit];

    self.categoriesLabel.text = [restaurantInfo formatCategoryString];
    [self.addressLabel sizeToFit];

    self.reviewsLabel.text = [NSString stringWithFormat:@"%d reviews",[restaurantInfo.reviewCount intValue]];
    [self.reviewsLabel sizeToFit];
}

@end
