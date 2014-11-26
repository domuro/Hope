//
//  Message.h
//  Humanity
//
//  Created by Derek Omuro on 11/18/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Audio, Image, Story, User, Video;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) Audio *audio;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) User *sender;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) Video *video;
@property (nonatomic, retain) User *receiver;

@end
