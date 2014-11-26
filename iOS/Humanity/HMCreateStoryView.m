//
//  HMCreateStoryView.m
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMCreateStoryView.h"
#import "HMCreateStoryCanvas.h"

@interface HMCreateStoryView() <HMCreateStoryCanvasDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *textView;

@end

@implementation HMCreateStoryView {
    BOOL stickyScroll;
    HMCreateStoryCanvas *canvas;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        stickyScroll = NO;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        [self.scrollView setDelegate:self];
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        [self.scrollView setAlwaysBounceVertical:YES];
        
        [self addSubview:self.scrollView];
        
        [self.layer setCornerRadius:12];
        [self.scrollView.layer setCornerRadius:12];
        
        canvas = [[HMCreateStoryCanvas alloc] initWithFrame:self.scrollView.bounds];
        canvas.delegate = self;
        [self.scrollView addSubview:canvas];
        
        self.layer.shadowOffset = CGSizeMake(3, 5);
        self.layer.shadowRadius = 12;
        self.layer.shadowOpacity = 0.8;
        self.layer.masksToBounds = NO;
    }
    return self;
}

//- (void)setStory:(Story *)story{
//    canvas.story = story;
//}

#pragma mark - HMCreateStoryCanvasDelegate
- (void)storyCanvas:(HMCreateStoryCanvas *)storyCanvas didPostStory:(Story *)story {
    if (self.storyViewDelegate && [self.storyViewDelegate respondsToSelector:@selector(storyView:didPostStory:)]) {
        [self.storyViewDelegate storyView:self didPostStory:story];
    }
}

- (void)storyCanvasDidCancel:(HMCreateStoryCanvas *)storyCanvas {
    if (self.storyViewDelegate && [self.storyViewDelegate respondsToSelector:@selector(storyViewDidCancel:)]) {
        [self.storyViewDelegate storyViewDidCancel:self];
    }
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (stickyScroll || (scrollView.contentOffset.y < 0 && scrollView.isTracking)) {
//        stickyScroll = YES;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewScrolledPastTopByAmount:)]) {
//            [self.delegate storyViewScrolledPastTopByAmount:-1*scrollView.contentOffset.y];
//        }
//        [scrollView setContentOffset:CGPointZero];
//    }
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    stickyScroll = NO;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewWillEndDragging:withVelocity:)]) {
//        [self.delegate storyViewWillEndDragging:nil withVelocity:velocity];
//    }
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewWillBeginDragging:)]) {
//        [self.delegate storyViewWillBeginDragging:nil];
//    }
//}

@end
