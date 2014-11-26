//
//  HMAppDelegate.m
//  Humanity
//
//  Created by Derek Omuro on 11/11/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMAppDelegate.h"
#import "HMMessageListViewController.h"
#import "HMReadStoryContainerWindow.h"

#import "Story.h"
#import "Image.h"
#import "Video.h"
#import "Message.h"

@interface HMAppDelegate ()

@end

@implementation HMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor blackColor]];
    
    self.storyWindow = [[HMReadStoryContainerWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.storyWindow setWindowLevel:UIWindowLevelStatusBar];
    UIViewController *vc = [[UIViewController alloc] init];
    [self.storyWindow setRootViewController:vc];
    [self.storyWindow makeKeyAndVisible];
    
    HMMessageListViewController *messageListVC = [[HMMessageListViewController alloc] init];
    messageListVC.managedObjectContext = [self managedObjectContext];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:messageListVC];
    
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    
    NSError *error;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"User" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSArray *arr = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if ([arr count] == 0) {
        // TODO: Insert entries in database respectively!!
        
        // The current user.
        self.user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_managedObjectContext];
        self.user.userID = @(1);
        self.user.username = @"domuro";
        self.user.isFriend = @(NO);
        
        // The author for the other stories.
        self.otherUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:_managedObjectContext];
        self.otherUser.userID = @(2);
        self.otherUser.username = @"ksekhri";
        self.otherUser.isFriend = @(YES);
        
        // Generate Story 1 with text.
        Story *story = (Story *)[NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:_managedObjectContext];
        story.storyID = @(1);
        story.message = @"My hand is trembling and I can’t make it stop. I’m using my finger to point at letters as I “type.” I can’t walk in a straight line, and my husband has to help me go use the restroom. All of that would normally be too much to bear, but today we visited our grandkids. Huntington’s confines me to a wheelchair, but seeing their smiles gives me the strength I need to continue. I’ll continue to fight for them. ";
        story.createdAt = [NSDate date];
        story.author = self.otherUser;
        
        // Generate Story 2 with Image
        Image *i = (Image *)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:_managedObjectContext];
        i.imageHash = @"FirstImageHash";
        i.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"brain graphic 001.jpg"]);
        
        Story *story2 = (Story *)[NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:_managedObjectContext];
        story2.storyID = @(2);
        story2.message = @"I’m a neurosurgery resident. I tried so hard to get here, to be the best, to have a future serving the patients in need, but a few weeks ago I found out I have a brain tumor. I was diagnosed right here at the hospital where I operate on other people’s brain tumors. I go to work in the morning in my scrubs, and then go down to the basement to get my radiation treatment. Seeing my patients bravely fight for their lives every day keeps me going. I will keep fighting.";
        story2.createdAt = [NSDate date];
        story2.author = self.otherUser;
        story2.image = i;
        
        // Generate Story 3 with Video
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mov"];
//        NSData *videoData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        Video *video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:_managedObjectContext];
        video.videoHash = @"nT0WpbXtgaxwEgNT"; //temp video hash from s3
//        video.videoData = videoData;
        
        Story *story3 = (Story *)[NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:_managedObjectContext];
        story3.storyID = @(3);
        story3.message = @"I know you must be feeling afraid, alone, and scared. I know because it was only four years ago I was at the darkest point in my life. I promise you you’re not alone. All you need to get over this depression is Hope.";
        story3.createdAt = [NSDate date];
        story3.author = self.otherUser;
        story3.video = video;
        
        self.defaultStories = @[story3, story2, story];
        
//        // Generate Message 1 from current user
//        Message *message = (Message *)[NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:_managedObjectContext];
//        message.messageID = @(1);
//        message.createdAt = [NSDate date];
//        message.message = @"This is the first message from domuro";
//        message.sender = self.user;
//        message.receiver = self.otherUser;
//        
//        // Generate Message 2 from other user
        
        
        [self saveContext];
    } else {
        for (User *u in arr) {
            if ([u.userID isEqualToNumber:@(1)]) {
                self.user = u;
            } else if ([u.userID isEqualToNumber:@(2)]) {
                self.otherUser = u;
            }
        }
        
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Story" inManagedObjectContext:_managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"storyID <= 3"]];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"storyID" ascending:NO]]];
        self.defaultStories = [_managedObjectContext executeFetchRequest:request error:&error];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.domuro.Humanity" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Humanity" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Humanity.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"com.domuro" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
