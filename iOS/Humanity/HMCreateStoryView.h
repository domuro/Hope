//
//  HMCreateStoryView.h
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReadStoryView.h"

@protocol HMCreateStoryViewDelegate;

@interface HMCreateStoryView : UIView

//@property (nonatomic, weak) id<HMReadStoryViewDelegate> delegate;
@property (nonatomic, weak) id<HMCreateStoryViewDelegate> storyViewDelegate;
//@property (nonatomic, strong) Story *story;

@end

@protocol HMCreateStoryViewDelegate <NSObject>

@optional
- (void)storyView:(HMCreateStoryView *)storyView didPostStory:(Story *)story;
- (void)storyViewDidCancel:(HMCreateStoryView *)storyView;
@end