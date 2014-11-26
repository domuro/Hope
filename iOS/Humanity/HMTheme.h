//
//  HMTheme.h
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTheme : NSObject

// Colors
+ (UIColor *)tintColor; // The main tint color throughout the application, e.g a text button
+ (UIColor *)fadedTintColor; // The faded tint color, e.g when a text button is pressed

// Fonts
+ (UIFont *)fontWithSize:(CGFloat)size;
+ (UIFont *)boldFontWithSize:(CGFloat)size;

@end
