//
//  HMReadStoryView.h
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@protocol HMReadStoryViewDelegate;

@interface HMReadStoryView : UIView

@property (nonatomic, weak) id<HMReadStoryViewDelegate> delegate;
@property (nonatomic, strong) Story *story;

@end


@protocol HMReadStoryViewDelegate <NSObject>

@optional
- (void)storyViewScrolledPastTopByAmount:(CGFloat)amount;
- (void)storyViewWillEndDragging:(HMReadStoryView *)storyView withVelocity:(CGPoint)velocity;
- (void)storyViewWillBeginDragging:(HMReadStoryView *)storyView;

@end
