//
//  HMMediaOptions.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMMediaOptionsDelegate;

@interface HMMediaOptions : UIView

@property (nonatomic, weak) id<HMMediaOptionsDelegate> delegate;
- (void)reloadData;

@end

@protocol HMMediaOptionsDelegate <NSObject>

- (void)mediaOptionsDidSelectLibrary:(HMMediaOptions *)mediaOptions;
- (void)mediaOptionsDidSelectPhoto:(HMMediaOptions *)mediaOptions;
- (void)mediaOptionsDidSelectCancel:(HMMediaOptions *)mediaOptions;

- (void)mediaOptions:(HMMediaOptions *)mediaOptions didSelectImage:(UIImage *)image;

@end
