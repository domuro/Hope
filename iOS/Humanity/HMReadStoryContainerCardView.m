//
//  HMReadStoryContainerView.m
//  Humanity
//
//  Created by Derek Omuro on 11/14/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMReadStoryContainerCardView.h"
#import "HMReadStoryView.h"
#import "HMAppDelegate.h"

@implementation HMReadStoryContainerCardView {
    HMReadStoryView *storyView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:12];
        // TODO: handle the rounded corners on bottom.
        
        storyView = [[HMReadStoryView alloc] initWithFrame:self.bounds];
        [self addSubview:storyView];
        
        self.layer.shadowOffset = CGSizeMake(3, 5);
        self.layer.shadowRadius = 12;
        self.layer.shadowOpacity = 0.8;
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)setReadStoryViewDelegate:(id<HMReadStoryViewDelegate>)readStoryViewDelegate {
    _readStoryViewDelegate = readStoryViewDelegate;
    [storyView setDelegate:_readStoryViewDelegate];
}

- (void)setStory:(Story *)story {
    _story = story;
    [storyView setStory:story];
}

@end
