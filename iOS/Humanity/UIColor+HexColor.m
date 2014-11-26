//
//  UIColor+HexColor.m
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorFromLong:(NSInteger)hexValue {
    return [self colorFromLong:hexValue withAlphaComponent:1];
}

+ (UIColor *)colorFromLong:(NSInteger)hexValue withAlphaComponent:(CGFloat)alphaComponent {
    return [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:alphaComponent];
}

@end
