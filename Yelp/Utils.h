//
//  Utils.h
//  Yelp
//
//  Created by Pierpaolo Baccichet on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#ifndef Yelp_Utils_h
#define Yelp_Utils_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
