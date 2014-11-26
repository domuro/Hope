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

#import "DemoModelData.h"

#import "NSUserDefaults+DemoSettings.h"


/**
 *  This is for demo/testing purposes only.
 *  This object sets up some fake model data.
 *  Do not actually do anything like this.
 */

@implementation DemoModelData

- (instancetype)initWithVersion:(NSInteger)version {
    self.version = version;
    self = [self init];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if ([NSUserDefaults emptyMessagesSetting]) {
            self.messages = [NSMutableArray new];
        }
        else {
            [self loadFakeMessages];
        }
        
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        JSQMessagesAvatarImage *jsqImage = [JSQMessagesAvatarImageFactory avatarImageWithUserInitials:@"JSQ"
                                                                                      backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                                                            textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                                                 font:[UIFont systemFontOfSize:14.0f]
                                                                                             diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_cook"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *jobsImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *wozImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_woz"]
                                                                                      diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.avatars = @{ kJSQDemoAvatarIdSquires : jsqImage,
                          kJSQDemoAvatarIdTB : cookImage,
                          kJSQDemoAvatarIdJG : jobsImage,
                          kJSQDemoAvatarIdSC : wozImage };
        
        
        self.users = @{ kJSQDemoAvatarIdJG : kJSQDemoAvatarDisplayNameJG,
                        kJSQDemoAvatarIdTB : kJSQDemoAvatarDisplayNameTB,
                        kJSQDemoAvatarIdSC : kJSQDemoAvatarDisplayNameSC,
                        kJSQDemoAvatarIdSquires : kJSQDemoAvatarDisplayNameSquires };
        
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

- (void)loadFakeMessages
{
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    switch (self.version) {
        case 0:
            
            self.messages = [[NSMutableArray alloc] initWithObjects:
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdTB//kJSQDemoAvatarIdCF
                                                senderDisplayName:@"Anni Liu"
                                                             date:[NSDate distantPast]
                                                             text:@"I was a ballet dancer. One of the best in town. Then I got in a car accident, and now my legs are gone. What will I do if I can’t dance anymore? I have no other talent. I forgone college so I can dance. Now I’m legless. What am I to do? I want to jump like her again. "],
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate date]
                                                             text:@"I can't say anything to make you feel better, but I empathize with your pain. My son recently lost his left leg due to a drunk driver."],
                             nil];
            [self addPhotoMediaMessage];
            
            break;
        case 1:
            self.messages = [[NSMutableArray alloc] initWithObjects:
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdTB
                                                senderDisplayName:kJSQDemoAvatarDisplayNameTB
                                                             date:[NSDate distantPast]
                                                             text:@"My friends don’t know, but I vomit out my food every day. The sight of myself in the mirror is disgusting."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate distantPast]
                                                             text:@"I was anorexic 9 years ago. I remember how it felt to look in the mirror and see nothing but my flaws."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate date]
                                                             text:@"You can't let your looks define you, you are so much more than what your scale says."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdTB
                                                senderDisplayName:kJSQDemoAvatarDisplayNameTB
                                                             date:[NSDate date]
                                                             text:@"I can’t go hang out with my friends anymore because they might find out."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameJG
                                                             date:[NSDate date]
                                                             text:@"You just have to take it one step at a time. I promise it will get better."],
                             nil];
            
            
            break;
        case 2:
            self.messages = [[NSMutableArray alloc] initWithObjects:
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSC
                                                senderDisplayName:kJSQDemoAvatarDisplayNameJG
                                                             date:[NSDate distantPast]
                                                             text:@"After over a year of fighting, I'm proud to say I'm finally in remission!"],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate distantPast]
                                                             text:@"That's incredible news! I hope I can say this for myself one day soon."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSC
                                                senderDisplayName:kJSQDemoAvatarDisplayNameJG
                                                             date:[NSDate date]
                                                             text:@"With a positive attitude anything's possible. I wish you all the best."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate date]
                                                             text:@"Thank you for your blessings, I just wish I knew which way to go with my treatment."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdJG
                                                senderDisplayName:kJSQDemoAvatarDisplayNameJG
                                                             date:[NSDate date]
                                                             text:@"I can understand how confusing treatment options can be, let me tell you about how I made my decision."],
                             nil];
            
            break;
        default:
            
            self.messages = [[NSMutableArray alloc] initWithObjects:
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate distantPast]
                                                             text:@"I'm extremely impressed with your strength through these difficult times."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSC
                                                senderDisplayName:@"Tai Cao"
                                                             date:[NSDate distantPast]
                                                             text:@"I can't genuinely say that I'm strong. In some ways I just feel like I'm just surviving."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate distantPast]
                                                             text:@"When you're depressed sometimes surviving is all you can do."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSC
                                                senderDisplayName:@"Tai Cao"
                                                             date:[NSDate date]
                                                             text:@"I'm really glad we can talk like this. "],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate date]
                                                             text:@"That's what friends are for, I'm here for you."],
                             
                             [[JSQMessage alloc] initWithSenderId:kJSQDemoAvatarIdSquires
                                                senderDisplayName:kJSQDemoAvatarDisplayNameSquires
                                                             date:[NSDate date]
                                                             text:@"I've been there, I promise things will get better."],
                             nil];
            
            
            
            break;
    }
    
    
    
    
    
    /**
     *  Setting to load extra messages for testing/demo
     */
    if ([NSUserDefaults extraMessagesSetting]) {
        NSArray *copyOfMessages = [self.messages copy];
        for (NSUInteger i = 0; i < 4; i++) {
            [self.messages addObjectsFromArray:copyOfMessages];
        }
    }
    
    
    /**
     *  Setting to load REALLY long message for testing/demo
     *  You should see "END" twice
     */
    if ([NSUserDefaults longMessageSetting]) {
        JSQMessage *reallyLongMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                            displayName:kJSQDemoAvatarDisplayNameSquires
                                                                   text:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END"];
        
        [self.messages addObject:reallyLongMessage];
    }
}

- (void)addPhotoMediaMessage
{
    JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageNamed:@"goldengate"]];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSC
                                                   displayName:@"Anni Liu"
                                                         media:photoItem];
    
    [self.messages addObject:photoMessage];
}

- (void)addLocationMediaMessageCompletion:(JSQLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:37.795313 longitude:-122.393757];
    
    JSQLocationMediaItem *locationItem = [[JSQLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    
    JSQMessage *locationMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                      displayName:kJSQDemoAvatarDisplayNameSquires
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    JSQVideoMediaItem *videoItem = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    JSQMessage *videoMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdSquires
                                                   displayName:kJSQDemoAvatarDisplayNameSquires
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

@end
