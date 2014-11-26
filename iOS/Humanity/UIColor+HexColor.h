//
//  UIColor+HexColor.h
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorFromLong:(NSInteger)hexValue;
+ (UIColor *)colorFromLong:(NSInteger)hexValue withAlphaComponent:(CGFloat)alphaComponent;

@end
