//
//  HMReadStoryContainerWindow.m
//  Humanity
//
//  Created by Derek Omuro on 11/15/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMReadStoryContainerWindow.h"
#import "HMReadStoryContainerCardView.h"
#import "HMAppDelegate.h"
#import "ServiceEndpoint.h"
#import "HMReadStoryScrollView.h"
#import "Story.h"
#import "Image.h"
#import "Video.h"

#import "HMAppDelegate.h"

@interface HMReadStoryContainerWindow () <HMReadStoryScrollViewDelegate, HMReadStoryViewDelegate, UIScrollViewDelegate, HMCreateStoryViewDelegate>

@property (nonatomic, strong) HMReadStoryScrollView *cardScrollView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

static const CGFloat kCardPadding = 20.0;

@implementation HMReadStoryContainerWindow {
    HMReadStoryContainerCardView *card;
    UIWindow *window;
    BOOL allowBackgroundTouch;
    NSInteger storiesLoaded;
    
    UIView *_storyView;
    
    CGPoint lastLocation;
    CGFloat halfHeight;
    
    HMAppDelegate *delegate;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        delegate = (HMAppDelegate*)[[UIApplication sharedApplication] delegate];
        storiesLoaded = 0;
        allowBackgroundTouch = YES;
        halfHeight = frame.size.height/2;
        
        window = [[[UIApplication sharedApplication] delegate] window];
        
        self.cardScrollView = [[HMReadStoryScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width+kCardPadding, self.bounds.size.height)];
        [self.cardScrollView setBackgroundColor:[UIColor clearColor]];
        [self.cardScrollView setStoryDelegate:self];
        [self.cardScrollView setDelegate:self];
        [self.cardScrollView setContentSize:self.cardScrollView.bounds.size];
        [self.cardScrollView setAlwaysBounceHorizontal:YES];
        [self.cardScrollView setPagingEnabled:YES];
        [self.cardScrollView setClipsToBounds:NO];
        [self addSubview:self.cardScrollView];
        
        self.managedObjectContext = [delegate managedObjectContext];
        
        // TODO: unhack... delay to wait for stories to load from core data.
        [self performSelector:@selector(appendPageWithStory:) withObject:nil afterDelay:0.1];
    }
    return self;
}

- (void)appendPageWithStory:(Story *)story {
    story = nil;
    // TODO: For Demo only! load 2 default stories first.
    if (storiesLoaded < delegate.defaultStories.count) {
        story = [delegate.defaultStories objectAtIndex:storiesLoaded];
    } else {
        //         TODO: Pull story from server!
        //        story = [delegate.defaultStories objectAtIndex:0];
    }
    
    storiesLoaded ++;
    
    card = [[HMReadStoryContainerCardView alloc] initWithFrame:self.bounds];
    [card setReadStoryViewDelegate:self.cardScrollView];
    
    if (story) {
        [card setStory:story];
    } else {
        NSNumber *userID = [[(HMAppDelegate *)[[UIApplication sharedApplication] delegate] user] userID];
        
        [ServiceEndpoint getLatestStory:^(id response) {
            NSLog(@"cl %@", [response class]);
            NSLog(@"da %@", response);
            Story *story = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:self.managedObjectContext];
            story.createdAt = [NSDate date];
            story.message = response[@"Message"];
            story.storyID = @([(NSString*)response[@"StoryID"] integerValue]);
            if([response[@"MediaType"] intValue] == 1) {
                // image
                [ServiceEndpoint downloadImage:^(id response) {
                    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
                    image.imageData = UIImagePNGRepresentation(response);
                    story.image = image;
                    [card setStory:story];
                } failure:^(NSError *error) {
                    NSLog(@"Error: %@", error);
                } hash:response[@"hash"]];
            } else if ([response[@"MediaType"] intValue] == 2){
                //video
                [ServiceEndpoint getNSData:^(id response) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",response[@"hash"]]];
                    [response writeToFile:path atomically:YES];
                    Video *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:self.managedObjectContext];
                    video.videoHash = response[@"hash"];
                    story.video = video;
                    [card setStory:story];
                } failure:^(NSError *error) {
                    
                } hash:response[@"hash"]];
            } else {
                [card setStory:story];
            }
        } failure:^(id response) {
        } userID:[NSString stringWithFormat:@"%@", userID]];
    }
    
    CGRect frame = self.cardScrollView.bounds;
    frame.origin.x = self.cardScrollView.contentSize.width-frame.size.width;
    UIView *storyPage = [[UIView alloc] initWithFrame:frame];
    
    [storyPage addSubview:card];
    [self.cardScrollView addSubview:storyPage];
}

- (void)setPeekHidden:(BOOL)peekHidden animated:(BOOL)animated {
    [self.cardScrollView setPeekHidden:peekHidden animated:animated];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (_storyView && CGRectContainsPoint(_storyView.frame, point)) {
        return [_storyView hitTest:point withEvent:event];
    } else if (CGRectContainsPoint(self.cardScrollView.frame, point)) {
        return [self.cardScrollView hitTest:point withEvent:event];
    } else {
        return allowBackgroundTouch?nil:self;
    }
}

#pragma mark - Card UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (storiesLoaded < 3) {
        if (scrollView.contentOffset.x > (storiesLoaded-1) * scrollView.bounds.size.width) {
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width + self.bounds.size.width + kCardPadding, scrollView.contentSize.height)];
            
            [self appendPageWithStory:nil];
        }
    }
}

#pragma mark - HMReadStoryScrollViewDelegate
- (void)storyScrollViewDidBeginScrolling {
    allowBackgroundTouch = NO;
}

- (void)storyScrollViewDidEndScrolling {
    allowBackgroundTouch = YES;
}

#pragma mark - HMReadStoryViewDelegate
- (void)updateDarkness {
    // follows an exponential curve
    CGFloat y = 1-(abs(_storyView.frame.origin.y))/(_storyView.frame.size.height-64)-0.1;
    if (y <= 0) {
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        CGFloat alpha = y*y;
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
    }
}

- (void)storyViewScrolledPastTopByAmount:(CGFloat)amount {
    CGFloat newY = lastLocation.y + amount;
    newY = newY<halfHeight?halfHeight:newY;
    
    _storyView.center = CGPointMake(self.center.x, newY);
    lastLocation = _storyView.center;
    
    [self updateDarkness];
}

- (void)storyViewWillEndDragging:(HMReadStoryView *)storyView withVelocity:(CGPoint)velocity {
    [self storyScrollViewDidEndScrolling];
    [self updateContainerHiddenWithVelocity:CGPointMake(velocity.x, velocity.y*-1200)];
}

- (void)storyViewWillBeginDragging:(HMReadStoryView *)storyView {
    [self storyScrollViewDidBeginScrolling];
}

- (void)updateContainerHiddenWithVelocity:(CGPoint)velocity {
    BOOL containerHidden;
    BOOL _containerHidden = NO;
    if (_containerHidden) {
        containerHidden = _storyView.frame.origin.y > _storyView.frame.size.height;
    } else {
        containerHidden = _storyView.frame.origin.y > 0;
    }
    
    UIViewAnimationOptions animationOptionCurve = UIViewAnimationOptionCurveEaseInOut;
    CGFloat duration = 0.45;
    
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
            
            duration = 0.45 * durationChange;
        }
    }
    
    [self setContainerHidden:containerHidden animated:YES animationOptionCurve:animationOptionCurve duration:duration];
}

- (void)setContainerHidden:(BOOL)containerHidden animated:(BOOL)animated animationOptionCurve:(UIViewAnimationOptions)animationOptionCurve duration:(CGFloat)duration{
    // hide the overlay card if needed.
    
    CGRect frame = _storyView.frame;
    frame.origin = CGPointMake(0, containerHidden?frame.size.height:0);
    if (animated) {
        
        [self storyScrollViewDidBeginScrolling];
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:animationOptionCurve | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [_storyView setFrame:frame];
                             [self updateDarkness];
                         } completion:^(BOOL finished) {
                             [self storyScrollViewDidEndScrolling];
                             if (containerHidden) {
                                 [_storyView removeFromSuperview];
                                 _storyView = nil;
                             }
                         }];
    }
}

#pragma mark - HMCreateStoryViewDelegate
- (void)storyView:(HMCreateStoryView *)storyView didPostStory:(Story *)story {
    // TODO: add code for posting a story to database!
    [UIView animateWithDuration:0.45
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect frame = _storyView.frame;
                         frame.origin = CGPointMake(0, -1 * frame.size.height);
                         [_storyView setFrame:frame];
                         [self updateDarkness];
                     } completion:^(BOOL finished) {
                         [_storyView removeFromSuperview];
                         _storyView = nil;
                     }];
}

- (void)storyViewDidCancel:(HMCreateStoryView *)storyView {
    [UIView animateWithDuration:0.45
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGRect frame = _storyView.frame;
                         frame.origin = CGPointMake(0, frame.size.height);
                         [_storyView setFrame:frame];
                         [self updateDarkness];
                     } completion:^(BOOL finished) {
                         [_storyView removeFromSuperview];
                         _storyView = nil;
                     }];
}

#pragma mark - Presenting Cards
- (void)presentCreateStoryView:(HMCreateStoryView *)createStoryView {
    if (_storyView) {
        return;
    }
    //    createStoryView.delegate = self;
    createStoryView.storyViewDelegate = self;
    _storyView = createStoryView;
    [self addSubview:_storyView];
    
    CGRect rect = _storyView.frame;
    rect.origin = CGPointMake(0, self.bounds.size.height);
    
    [_storyView setFrame:rect];
    rect.origin = CGPointZero;
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_storyView setFrame:rect];
                         [self updateDarkness];
                     } completion:^(BOOL finished) {
                         lastLocation = _storyView.center;
                     }];
}

- (void)presentProfileCard:(HMProfileCard *)profileCard {
    if (_storyView) {
        return;
    }
    profileCard.delegate = self;
    _storyView = profileCard;
    [self addSubview:_storyView];
    
    CGRect rect = _storyView.frame;
    rect.origin = CGPointMake(0, self.bounds.size.height);
    
    [_storyView setFrame:rect];
    rect.origin = CGPointZero;
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_storyView setFrame:rect];
                         [self updateDarkness];
                     } completion:^(BOOL finished) {
                         lastLocation = _storyView.center;
                     }];
    
}

@end
