//
//  StoryClass.h
//  AFNetwork Story
//
//  Created by Kay Lab on 11/6/14.
//  Copyright (c) 2014 Kay Lab. All rights reserved.
//

@interface ServiceEndpoint : NSObject


+(NSString*)generateHash;
/*
 + (void)getRequest:(void (^)(id response))success
 failure:(void (^)(NSError *error))failure;
 */

+ (void)getName:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure
         userID: (NSString*) userID;

+ (void)getUserName:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
             userID: (NSString*) userID;

+ (void)getPassword:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
             userID: (NSString*) userID;

+ (void)downloadImage:(void (^)(id response))success
              failure:(void (^)(NSError *error))failure
                 hash:(NSString*) hash;

+ (void)getLatestStory:(void (^)(id response))success
               failure:(void (^)(id response))failure
                userID:(NSString*) userID;

+ (void)getNSData:(void (^)(id response))success
          failure:(void (^)(NSError *error))failure
             hash:(NSString*) hash;

+ (void)getLast20Messages:(void (^)(id response))success
                  failure:(void (^)(id response))failure
                 userIDTo:(NSString*) userIDTo
               userIDFrom:(NSString*) userIDFrom;

//post
/*
 + (void)postRequest:(void (^)(id response))success
 failure:(void(^)(NSError *error))failure;
 */

+ (void)createUser:(void (^)(id response))success
           failure:(void (^)(NSError *error))failure
          userName:(NSString*) userName
             email:(NSString*) email
          password:(NSString*) password;

+ (void)upLoadImage:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
              image:(UIImage*) image;

+ (void)upLoadVideo:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
              video:(NSData*) video;


+ (void)postStory:(void (^)(id response))success
          failure:(void (^)(NSError *error))failure
           userID:(NSString*) userID
             hash: (NSString*) hash
     storyContent:(NSString*) storyContent;

+ (void)postMessage:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
           messsage:(NSString*) message
               hash:(NSString*) hash
           userIDTo:(NSString*) userIDTo
         userIDFrom:(NSString*) userIDFrom;
@end