//
//  HMTheme.m
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMTheme.h"
#import "UIColor+HexColor.h"

static const CGFloat kDefaultFontSize = 18.0;
@implementation HMTheme

+ (UIColor *)tintColor {
    return [UIColor colorFromLong:0x007AFF];
}

+ (UIColor *)fadedTintColor {
    return [UIColor colorFromLong:0xB9D5F8];
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size?:kDefaultFontSize];
}

+ (UIFont *)boldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size?:kDefaultFontSize];
}

@end
