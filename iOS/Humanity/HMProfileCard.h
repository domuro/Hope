//
//  HMProfieCard.h
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMReadStoryView.h"
#import "HMReadStoryScrollView.h"

@interface HMProfileCard : UIView

@property (nonatomic, weak) id<HMReadStoryViewDelegate> delegate;

@end