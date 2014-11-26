//
//  Story.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Audio, Image, Message, User, Video;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * storyID;
@property (nonatomic, retain) User *author;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) Audio *audio;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) Image *image;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
