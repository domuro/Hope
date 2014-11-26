//
//  HMCreateStoryCanvas.m
//  Humanity
//
//  Created by Derek Omuro on 11/16/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMCreateStoryCanvas.h"
#import "HMTheme.h"
#import "HMAppDelegate.h"
#import "HMMediaOptions.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ServiceEndpoint.h"
@interface HMCreateStoryCanvas() <HMMediaOptionsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSURL *selectedMovieURL;
@property (strong, nonatomic) UIImage *selectedImage;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MPMoviePlayerController *movieView;

@end

@implementation HMCreateStoryCanvas {
    BOOL keyboardIsShown;
    UIButton *cameraButton;
    UIButton *sendButton;
    UIButton *closeButton;
    
    CGFloat buttonFloatMargin;
    HMMediaOptions *cameraPopover;
    UIButton *dismissCameraButton;
    UIWindow *topWindow;
    
    HMAppDelegate *appDelegate;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        appDelegate = (HMAppDelegate*)[[UIApplication sharedApplication] delegate];
        dismissCameraButton = [[UIButton alloc] init];
        [dismissCameraButton addTarget:self action:@selector(dismissCameraPopover:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonFloatMargin = 0;
        cameraPopover = [[HMMediaOptions alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 290)];
        cameraPopover.delegate = self;
        
        
        self.textViewInsets = UIEdgeInsetsMake(80, 40, 0, 45);
        
        self.textView = [UITextView new];
        [self.textView setFont:[HMTheme fontWithSize:20]];
        
        self.imageView = [UIImageView new];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        
        [self addSubview:self.textView];
        [self.textView addSubview:self.imageView];
        
        // register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        // register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.textView action:@selector(resignFirstResponder)]];
        
        [self.textView setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
        [self.textView setAutocorrectionType:UITextAutocorrectionTypeDefault];
        
        [self.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
        
        cameraButton = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImageView *iv2 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 38, 38)];
        [iv2 setContentMode:UIViewContentModeScaleAspectFit];
        [iv2 setImage:[UIImage imageNamed:@"Camera"]];
        [cameraButton addSubview:iv2];
        [cameraButton addTarget:self action:@selector(cameraPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cameraButton];
        
        sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [sendButton.titleLabel setFont:[HMTheme boldFontWithSize:0]];
        [sendButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [sendButton setTitle:@"Post" forState:UIControlStateNormal];
        [sendButton setTitleColor:[HMTheme tintColor] forState:UIControlStateNormal];
        [sendButton setTitleColor:[HMTheme fadedTintColor] forState:UIControlStateHighlighted];
        [sendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [sendButton addTarget:self action:@selector(sendPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        closeButton= [[UIButton alloc] initWithFrame:CGRectZero];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 26, 26)];
        [iv setImage:[UIImage imageNamed:@"Close"]];
        [closeButton addSubview:iv];
        [closeButton addTarget:self action:@selector(closePress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        [self setupCanvas];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    _selectedMovieURL = nil;
    
    [self updateCanvas];
}

- (void)setSelectedMovieURL:(NSURL *)selectedMovieURL {
    _selectedMovieURL = selectedMovieURL;
    _selectedImage = nil;
    
    [self updateCanvas];
}

- (void)setupCanvas {
    CGFloat initialButtonHeight = self.frame.size.height - buttonFloatMargin - 44;
    [closeButton setFrame:CGRectMake(0, 0, 44, 44)];
    [cameraButton setFrame:CGRectMake(0, initialButtonHeight, self.textViewInsets.left, 44)];
    [sendButton setFrame:CGRectMake(self.frame.size.width-self.textViewInsets.right, initialButtonHeight, self.textViewInsets.right, 44)];
    
    [self.textView setFrame:self.bounds];
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    [self.textView setTextContainerInset:self.textViewInsets];
    
    [self.textView setTextContainerInset:self.textViewInsets];
}

// formats the canvas based on media present
- (void)updateCanvas {
    if (self.selectedImage) {
        [self.imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.imageView setImage:self.selectedImage];
        self.textViewInsets = UIEdgeInsetsMake(self.imageView.frame.size.height + 25, self.textViewInsets.left, self.textViewInsets.bottom, self.textViewInsets.right);
    } else if (self.selectedMovieURL) {
        self.movieView = [[MPMoviePlayerController alloc] initWithContentURL:self.selectedMovieURL];
        [self.movieView prepareToPlay];
        [self.movieView.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.textView addSubview:self.movieView.view];
        self.textViewInsets = UIEdgeInsetsMake(self.movieView.view.frame.size.height + 25, self.textViewInsets.left, self.textViewInsets.bottom, self.textViewInsets.right);
    }
    
    [self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
    [self.textView setScrollEnabled:NO];
    [self.textView setScrollEnabled:YES];
    
    [self.textView setTextContainerInset:self.textViewInsets];
}

#pragma mark - Button actions
- (void)closePress:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyCanvasDidCancel:)]) {
        [self.delegate storyCanvasDidCancel:self];
    }
}

- (void)cameraPress:(id)sender {
    [cameraPopover reloadData];
    
    topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    NSArray *arr = [[UIApplication sharedApplication] windows];
    for (NSInteger i = arr.count-1; i >= 0; i--) {
        if ([[arr objectAtIndex:i] rootViewController]) {
            topWindow = [arr objectAtIndex:i];
            break;
        }
    }
    
    [dismissCameraButton setFrame:topWindow.bounds];
    [topWindow addSubview:dismissCameraButton];
    
    CGRect frame = cameraPopover.frame;
    frame.origin = CGPointMake(0, topWindow.frame.size.height);
    cameraPopover.frame = frame;
    frame.origin = CGPointMake(0, topWindow.frame.size.height-cameraPopover.frame.size.height);
    [topWindow addSubview:cameraPopover];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         cameraPopover.frame = frame;
                         [topWindow setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
                     } completion:^(BOOL finished) {
                     }];
}

- (void)dismissCameraPopover:(id)sender {
    [dismissCameraButton removeFromSuperview];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = cameraPopover.frame;
                         frame.origin = CGPointMake(0, topWindow.frame.size.height);
                         cameraPopover.frame = frame;
                         [topWindow setBackgroundColor:[UIColor clearColor]];
                     } completion:^(BOOL finished) {
                         [cameraPopover removeFromSuperview];
                     }];

}

- (void)sendPress:(id)sender {
    // have delegate handle this
    Story *story = [NSEntityDescription insertNewObjectForEntityForName:@"Story"
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    story.author = appDelegate.user;
    story.createdAt = [NSDate date];
    story.message = self.textView.text;
    
    if (self.selectedImage) {
        Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:appDelegate.managedObjectContext];
        [ServiceEndpoint upLoadImage:^(id response) {
            [ServiceEndpoint postStory:^(id response) {
            } failure:^(NSError *error) {
                NSLog(@"Error: %@:", error);
            } userID:[NSString stringWithFormat:@"%ld", [story.author.userID longValue]] hash:response storyContent:story.message];
        } failure:^(NSError *error) {
            NSLog(@"upload image failed error as :%@", error);
        } image:self.selectedImage];
        story.image = image;
    } else if (self.selectedMovieURL) {
        Video *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:appDelegate.managedObjectContext];
        story.video = video;
        [ServiceEndpoint upLoadVideo:^(id response) {
            [ServiceEndpoint postStory:^(id response) {
            } failure:^(NSError *error) {
                NSLog(@"Error: %@:", error);
            } userID:[NSString stringWithFormat:@"%ld", [story.author.userID longValue]] hash:response storyContent:story.message];
        } failure:^(NSError *error) {
            NSLog(@"upload image failed error as :%@", error);
        } video:[NSData dataWithContentsOfURL:self.selectedMovieURL]];
    } else {
        [ServiceEndpoint postStory:^(id response) {
            
        } failure:^(NSError *error) {
            
        } userID:[NSString stringWithFormat:@"%ld", [story.author.userID longValue]]
                              hash:nil storyContent:story.message];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(storyCanvas:didPostStory:)]) {
        [self.delegate storyCanvas:self didPostStory:nil];
    }
}

#pragma mark - HMMediaOptionsDelegate
- (void)mediaOptions:(HMMediaOptions *)mediaOptions didSelectImage:(UIImage *)image {
    // use image
    [self dismissCameraPopover:nil];
    self.selectedImage = image;
}

- (void)mediaOptionsDidSelectLibrary:(HMMediaOptions *)mediaOptions {
    // Dismiss and show library
    [self dismissCameraPopover:nil];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [topWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (void)mediaOptionsDidSelectPhoto:(HMMediaOptions *)mediaOptions {
    // Dismiss and show photopicker.
    [self dismissCameraPopover:nil];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    picker.videoMaximumDuration = 60;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    
    picker.delegate = self;

    [topWindow.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (void)mediaOptionsDidSelectCancel:(HMMediaOptions *)mediaOptions {
    // Dismiss
    [self dismissCameraPopover:nil];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([info[UIImagePickerControllerMediaType] isEqualToString: (NSString *)kUTTypeImage]) {
        self.selectedImage = info[UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(self.selectedImage, nil, nil, nil);
    } else if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeMovie]) {
        self.selectedMovieURL = info[UIImagePickerControllerMediaURL];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([self.selectedMovieURL path])) {
            UISaveVideoAtPathToSavedPhotosAlbum([self.selectedMovieURL path], nil, nil, nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillHide:(NSNotification *)notification
{
    // TODO: test this!
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&keyboardTransitionAnimationCurve];
    
    CGFloat keyboardTransitionDuration = [[userInfo objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:keyboardTransitionDuration];
    [UIView setAnimationCurve:keyboardTransitionAnimationCurve];
    
    CGRect frame = self.textView.frame;
    frame.size.height += keyboardSize.height;
    [self.textView setFrame:frame];
    
    frame = sendButton.frame;
    frame.origin.y += keyboardSize.height;
    sendButton.frame = frame;
    
    frame = cameraButton.frame;
    frame.origin.y += keyboardSize.height;
    cameraButton.frame = frame;
    
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // keyboard notification fires even if keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIViewAnimationCurve keyboardTransitionAnimationCurve;
    [[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&keyboardTransitionAnimationCurve];
    
    CGFloat keyboardTransitionDuration = [[userInfo objectForKeyedSubscript:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:keyboardTransitionDuration];
    [UIView setAnimationCurve:keyboardTransitionAnimationCurve];
    
    CGRect frame = self.textView.frame;
    frame.size.height -= keyboardSize.height + 10;
    [self.textView setFrame:frame];
    
    frame = sendButton.frame;
    frame.origin.y -= keyboardSize.height;
    sendButton.frame = frame;
    
    frame = cameraButton.frame;
    frame.origin.y -= keyboardSize.height;
    cameraButton.frame = frame;
    
    [UIView commitAnimations];
    
    keyboardIsShown = YES;
}


@end
