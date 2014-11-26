//
//  HMReadStoryContainerWindow.h
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReadStoryView.h"
#import "HMCreateStoryView.h"
#import "HMProfileCard.h"

@interface HMReadStoryContainerWindow : UIWindow

- (void)setPeekHidden:(BOOL)peekHidden animated:(BOOL)animated;

- (void)presentCreateStoryView:(HMCreateStoryView *)createStoryView;
- (void)presentProfileCard:(HMProfileCard *)profileCard;

@end