//
//  Audio.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Story;

@interface Audio : NSManagedObject

@property (nonatomic, retain) NSData * audioData;
@property (nonatomic, retain) NSString * audioHash;
@property (nonatomic, retain) Message *message;
@property (nonatomic, retain) Story *story;

@end
