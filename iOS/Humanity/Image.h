//
//  Image.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Story;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageHash;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) Message *message;

@end
