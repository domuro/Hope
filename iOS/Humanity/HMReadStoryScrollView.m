//
//  HMReadStoryScrollView.m
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMReadStoryScrollView.h"
#import "HMAppDelegate.h"

@implementation HMReadStoryScrollView {
    CGPoint lastLocation;
    CGFloat halfHeight;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        lastLocation = self.center;
        halfHeight = frame.size.height/2;
        self.peekHeight = 64;
        self.animationDuration = 0.45;
        
        [self setContainerHidden:YES];
        [self setScrollEnabled:NO];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidBeginScrolling)]) {
            [self.storyDelegate storyScrollViewDidBeginScrolling];
        }
    }
    
    CGPoint translation = [panGestureRecognizer translationInView:self.superview];
    CGFloat newY = lastLocation.y + translation.y;
    newY = newY<halfHeight?halfHeight:newY;
    
    self.center = CGPointMake(self.center.x, newY);
    [self updateDarkness];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidEndScrolling)]) {
            [self.storyDelegate storyScrollViewDidEndScrolling];
        }
        [self updateContainerHiddenWithVelocity:[panGestureRecognizer velocityInView:self.superview]];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setContainerHidden:!_containerHidden animated:YES];
    }
}

// private function for setting container hidden with specified animationOptionCurve.
// for illusion of preserving swipe velocity on showing/hiding card.
- (void)setContainerHidden:(BOOL)containerHidden animated:(BOOL)animated animationOptionCurve:(UIViewAnimationOptions)animationOptionCurve duration:(CGFloat)duration{
    if (animated) {
        if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidBeginScrolling)]) {
            [self.storyDelegate storyScrollViewDidBeginScrolling];
        }
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:animationOptionCurve | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self setContainerHidden:containerHidden];
                         } completion:^(BOOL finished) {
                             if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidEndScrolling)]) {
                                 [self.storyDelegate storyScrollViewDidEndScrolling];
                             }
                         }];
        
    } else {
        [self setContainerHidden:containerHidden];
    }
}

- (void)setContainerHidden:(BOOL)containerHidden animated:(BOOL)animated {
    if (animated) {
        if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidBeginScrolling)]) {
            [self.storyDelegate storyScrollViewDidBeginScrolling];
        }
        [UIView animateWithDuration:self.animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self setContainerHidden:containerHidden];
                         } completion:^(BOOL finished) {
                             if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidEndScrolling)]) {
                                 [self.storyDelegate storyScrollViewDidEndScrolling];
                             }
                         }];
    } else {
        [self setContainerHidden:containerHidden];
    }
}

- (void)setContainerHidden:(BOOL)containerHidden {
    _containerHidden = containerHidden;
    
    [self setScrollEnabled:!containerHidden];
    
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        [g setEnabled:containerHidden];
    }
    
    if (containerHidden) {
        [self setCenter:CGPointMake(self.center.x, halfHeight*3-self.peekHeight)];
        lastLocation = self.center;
    } else {
        [self setCenter:CGPointMake(self.center.x, halfHeight)];
        lastLocation = self.center;
    }
    
    [self updateDarkness];
}

- (void)setPeekHidden:(BOOL)peekHidden animated:(BOOL)animated {
    if (animated) {
        if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidBeginScrolling)]) {
            [self.storyDelegate storyScrollViewDidBeginScrolling];
        }
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [self setPeekHidden:peekHidden];
                         } completion:^(BOOL finished) {
                             if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidEndScrolling)]) {
                                 [self.storyDelegate storyScrollViewDidEndScrolling];
                             }
                         }];
    } else {
        [self setPeekHidden:peekHidden];
    }
}

- (void)setPeekHidden:(BOOL)peekHidden {
    _peekHidden = peekHidden;
    
    if (peekHidden) {
        [self setCenter:CGPointMake(self.center.x, halfHeight*3)];
    } else {
        [self setCenter:CGPointMake(self.center.x, halfHeight*3-self.peekHeight)];
    }
}

- (void)updateDarkness {
    // follows an exponential curve
    CGFloat y = 1-(self.frame.origin.y)/(self.frame.size.height-64)-0.1;
    UIWindow *statusWindow = [(HMAppDelegate*)[[UIApplication sharedApplication] delegate] storyWindow];
    
    if (y <= 0) {
        [statusWindow setBackgroundColor:[UIColor clearColor]];
    } else {
        CGFloat alpha = y*y;
        [statusWindow setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.containerHidden) {
        return self;
    } else {
        [self setAlwaysBounceHorizontal:YES];
        [self setScrollEnabled:YES];
        
        point = CGPointMake(point.x + self.contentOffset.x, point.y + self.contentOffset.y);
        
        return [super hitTest:point withEvent:event];
    }
}

- (void)updateContainerHiddenWithVelocity:(CGPoint)velocity {
    BOOL containerHidden;
    if (_containerHidden) {
        containerHidden = self.frame.origin.y > self.frame.size.height-self.peekHeight;
    } else {
        containerHidden = self.frame.origin.y > 0;
    }
    
    UIViewAnimationOptions animationOptionCurve = UIViewAnimationOptionCurveEaseInOut;
    CGFloat duration = self.animationDuration;
    
    if (containerHidden != _containerHidden) {
        // if abs(velocity) > 300, velocity takes precidence.
        CGFloat dy = velocity.y;
        if (dy > 300) {
            containerHidden = YES;
        } else if (dy < -300) {
            containerHidden = NO;
        }
        
        if (abs(dy) > 700) {
            // scrolling fast, so just ease out.
            animationOptionCurve = UIViewAnimationOptionCurveEaseOut;
            CGFloat durationChange = -0.7/3000*abs(dy) + 1;
            durationChange = durationChange < 0.3?0.3:durationChange;
            
            duration = self.animationDuration * durationChange;
        }
    }
    [self setContainerHidden:containerHidden animated:YES animationOptionCurve:animationOptionCurve duration:duration];
}

#pragma mark - HMReadStoryViewDelegate
- (void)storyViewScrolledPastTopByAmount:(CGFloat)amount {
    CGFloat newY = lastLocation.y + amount;
    newY = newY<halfHeight?halfHeight:newY;
    
    self.center = CGPointMake(self.center.x, newY);
    lastLocation = self.center;
    
    [self updateDarkness];
}

- (void)storyViewWillEndDragging:(HMReadStoryView *)storyView withVelocity:(CGPoint)velocity {
    if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidEndScrolling)]) {
        [self.storyDelegate storyScrollViewDidEndScrolling];
    }
    [self updateContainerHiddenWithVelocity:CGPointMake(velocity.x, velocity.y*-1200)];
}

- (void)storyViewWillBeginDragging:(HMReadStoryView *)storyView {
    if (self.storyDelegate && [self.storyDelegate respondsToSelector:@selector(storyScrollViewDidBeginScrolling)]) {
        [self.storyDelegate storyScrollViewDidBeginScrolling];
    }
}

@end
