//
//  HMCreateStoryCanvas.h
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@protocol HMCreateStoryCanvasDelegate;

@interface HMCreateStoryCanvas : UIView

@property (assign, nonatomic) UIEdgeInsets textViewInsets;

//@property (strong, nonatomic) Story *story;
@property (strong, nonatomic) UITextView *textView;

@property (weak, nonatomic) id<HMCreateStoryCanvasDelegate> delegate;

@end

@protocol HMCreateStoryCanvasDelegate <NSObject>

@optional
- (void)storyCanvas:(HMCreateStoryCanvas *)storyCanvas didPostStory:(Story *)story;
- (void)storyCanvasDidCancel:(HMCreateStoryCanvas *)storyCanvas;

@end