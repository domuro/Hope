//
//  HMReadStoryContainerView.h
//  Humanity
//
//  Created by Derek Omuro on 11/14/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReadStoryView.h"
#import "Story.h"

@interface HMReadStoryContainerCardView : UIView

@property (nonatomic, strong) Story *story;
@property (nonatomic, weak) id<HMReadStoryViewDelegate> readStoryViewDelegate;

@end