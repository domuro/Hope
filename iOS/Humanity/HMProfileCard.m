//
//  HMProfieCard.m
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMProfileCard.h"
#import "ServiceEndpoint.h"

@interface HMProfileCard() <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HMProfileCard {
    BOOL stickyScroll;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        stickyScroll = NO;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.scrollView setDelegate:self];
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView setAlwaysBounceVertical:YES];
        
        [self addSubview:self.scrollView];
        
        [self.layer setCornerRadius:12];
        [self.scrollView.layer setCornerRadius:12];
        
        self.layer.shadowOffset = CGSizeMake(3, 5);
        self.layer.shadowRadius = 12;
        self.layer.shadowOpacity = 0.8;
        self.layer.masksToBounds = NO;
        
        // setup profile UI
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        [imageView setImage:[UIImage imageNamed:@"domuro2"]];
        [imageView.layer setCornerRadius: imageView.frame.size.width];
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (stickyScroll || (scrollView.contentOffset.y < 0 && scrollView.isTracking)) {
        stickyScroll = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewScrolledPastTopByAmount:)]) {
            [self.delegate storyViewScrolledPastTopByAmount:-1*scrollView.contentOffset.y];
        }
        [scrollView setContentOffset:CGPointZero];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    stickyScroll = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewWillEndDragging:withVelocity:)]) {
        [self.delegate storyViewWillEndDragging:nil withVelocity:velocity];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewWillBeginDragging:)]) {
        [self.delegate storyViewWillBeginDragging:nil];
    }
}

@end
