//
//  Video.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Story;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * videoHash;
@property (nonatomic, retain) NSData * videoData;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) Message *message;

@end
