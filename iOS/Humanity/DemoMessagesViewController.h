//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//


// Import all the things
#import "JSQMessages.h"

#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"


@class DemoMessagesViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(DemoMessagesViewController *)vc;

@end




@interface DemoMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (assign, nonatomic) NSInteger version;
@property (strong, nonatomic) DemoModelData *demoData;
@property (strong, nonatomic) NSString *name;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
