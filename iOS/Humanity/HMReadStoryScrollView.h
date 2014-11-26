//
//  HMReadStoryScrollView.h
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReadStoryView.h"

@protocol HMReadStoryScrollViewDelegate;

@interface HMReadStoryScrollView : UIScrollView <HMReadStoryViewDelegate>

@property (nonatomic, assign) CGFloat peekHeight;
@property (nonatomic, assign) BOOL containerHidden;
@property (nonatomic, assign) BOOL peekHidden;
@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, weak) id <HMReadStoryScrollViewDelegate> storyDelegate;

- (void)setContainerHidden:(BOOL)containerHidden animated:(BOOL)animated;
- (void)setPeekHidden:(BOOL)peekHidden animated:(BOOL)animated;

@end

@protocol HMReadStoryScrollViewDelegate <NSObject>

@optional
- (void)storyScrollViewDidBeginScrolling;
- (void)storyScrollViewDidEndScrolling;

@end
