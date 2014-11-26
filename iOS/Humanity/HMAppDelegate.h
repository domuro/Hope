//
//  HMAppDelegate.h
//  Humanity
//
//  Created by Derek Omuro on 11/11/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "HMReadStoryContainerWindow.h"
#import "User.h"

@interface HMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HMReadStoryContainerWindow *storyWindow;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) User *user;

// TODO: This is just for DEMO!
@property (strong, nonatomic) User *otherUser;
@property (strong, nonatomic) NSArray *defaultStories;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

