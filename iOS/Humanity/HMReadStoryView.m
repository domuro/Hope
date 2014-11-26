//
//  HMReadStoryView.m
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMReadStoryView.h"
#import "HMTheme.h"
#import "Story.h"
#import "Image.h"
#import "Video.h"
#import "ServiceEndpoint.h"

#import "HMAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HMReadStoryView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation HMReadStoryView {
    BOOL stickyScroll;
    MPMoviePlayerController *player;
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
        [self.scrollView.layer setCornerRadius:12];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (player && player.isFullscreen) {
        [player setFullscreen:NO animated:YES];
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

- (void)setStory:(Story *)story{
    _story = story;
    CGFloat yPos = 80;
    if (story.image) {
        // show image
        yPos = 0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [imageView setImage:[UIImage imageWithData:story.image.imageData]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView addSubview:imageView];
        
        yPos += imageView.frame.size.height + 25;
    } else if (story.video){
        // show video
        yPos = 0;
        // TODO: add video view!
        
        player = [[MPMoviePlayerController alloc] init];
        player.controlStyle = MPMovieControlStyleEmbedded;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",story.video.videoHash]];

        [player setContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sample2" ofType:@"mov"]]];
        [player prepareToPlay];
        [player.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.scrollView addSubview:player.view];
//        [player play];
        
        yPos += player.view.frame.size.height + 25;
    }
    
    // add message
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, yPos, self.frame.size.width - 40, 0)];
    [label setText:story.message];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label setNumberOfLines:0];
    [label setFont:[HMTheme fontWithSize:20]];
    [label sizeToFit];
    
    [self.scrollView addSubview:label];
    [self.scrollView setContentSize:CGSizeMake(self.frame.size.width, yPos + label.frame.size.height + 60)];
}

- (void)playbackFinished:(NSNotification *)notification {
//    [player setFullscreen:NO animated:YES];
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
        [self.delegate storyViewWillEndDragging:self withVelocity:velocity];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyViewWillBeginDragging:)]) {
        [self.delegate storyViewWillBeginDragging:self];
    }
}

@end
