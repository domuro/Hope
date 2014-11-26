//
//  User.h
//  Humanity
//
//  Created by Derek Omuro on 11/18/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Story;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarImageHash;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *sentMessages;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) NSSet *receivedMessages;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addSentMessagesObject:(Message *)value;
- (void)removeSentMessagesObject:(Message *)value;
- (void)addSentMessages:(NSSet *)values;
- (void)removeSentMessages:(NSSet *)values;

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

- (void)addReceivedMessagesObject:(Message *)value;
- (void)removeReceivedMessagesObject:(Message *)value;
- (void)addReceivedMessages:(NSSet *)values;
- (void)removeReceivedMessages:(NSSet *)values;

@end
