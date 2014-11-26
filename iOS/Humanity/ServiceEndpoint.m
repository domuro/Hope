//
//  StoryClass.m
//  AFNetwork Story
//
//  Created by Kay Lab on 11/6/14.
//  Copyright (c) 2014 Kay Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDKv2/S3.h>
#import <AWSiOSSDKv2/DynamoDB.h>
#import <AWSiOSSDKv2/SQS.h>
#import <AWSiOSSDKv2/SNS.h>
#import <AWSiOSSDKv2/AWSCore.h>
#import <AWSiOSSDKv2/AWSCredentialsProvider.h>
#import <AWSiOSSDKv2/AWSS3TransferManager.h>
#import <CommonCrypto/CommonDigest.h>

#import "Story.h"


#import "ServiceEndpoint.h"
#import "AFNetworking.h"

@implementation ServiceEndpoint

+ (AWSS3 *)s3 {
    static AWSS3 *s3 = nil;
    @synchronized(self) {
        if (s3 == nil) {
            AWSStaticCredentialsProvider *credentialsProvider  = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"AKIAJJFQTC5MZXL7HCOQ" secretKey:@"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"];
            
            AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
            
            s3 = [[AWSS3 alloc] initWithConfiguration: configuration];
        }
    }
    return s3;
}

///GET REQUESTS

/*
 + (void)getRequest:(void (^)(id response))success // TEMP BASE
 failure:(void (^)(NSError *error))failure {
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 //manager.responseSerializer = [AFJSONResponseSerializer serializer];
 //NSString* urlString = [NSString stringWithFormat: @"http://lit-brushlands-7356.herokuapp.com/db/%@", userID ];
 [manager GET:@"http://lit-brushlands-7356.herokuapp.com/db?UserID=1" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 //success(responseObject);
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 failure(error);
 NSLog(@"Error: %@", error);
 }];
 }
 */

+ (void)getName:(void (^)(id response))success
        failure:(void (^)(NSError *error))failure
         userID: (NSString*) userID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* urlString = [NSString stringWithFormat: @"http://lit-brushlands-7356.herokuapp.com/db/Name?UserID=%@", userID ];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        NSLog(@"Error: %@", error);
    }];
}

+ (void)getUserName:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
             userID: (NSString*) userID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* urlString = [NSString stringWithFormat: @"http://lit-brushlands-7356.herokuapp.com/db/name?UserID=%@", userID ];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
        //NSLog(@"Error: %@", error);
    }];
}


+ (void)getPassword:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
             userID: (NSString*) userID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString* urlString = [NSString stringWithFormat: @"http://lit-brushlands-7356.herokuapp.com/db/password?UserID=%@", userID ];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
        NSLog(@"Error: %@", error);
    }];
}

///Downloads an Image from S3
///Success response is a UIImage representing the image matching the hash
+ (void)downloadImage:(void (^)(id response))success
              failure:(void (^)(NSError *error))failure
                 hash:(NSString*) hash{
    AWSS3GetObjectRequest *getFile =[AWSS3GetObjectRequest new];
    getFile.bucket = @"humanitymedia";
    getFile.key = [NSString stringWithFormat:@"UserImage/%@.png", hash];
    //getFile.key = @"UserImage/9WDWVEdQ72bbwUGQ"; //image.jpg will be replaced with hash
    AWSS3 *S3 = [self s3];
    [[S3 getObject:getFile] continueWithBlock:^id(BFTask *task) {
        if ([task error]) {
            failure([task error]);
        } else {
            UIImage *image = [[UIImage alloc] initWithData:[[task result] body]];
            success(image);
        }
        return nil;
        
    }];
    
}

///Response object on success is NSData repressenting video file
+ (void)getNSData:(void (^)(id response))success
          failure:(void (^)(NSError *error))failure
             hash:(NSString*) hash{
    AWSS3GetObjectRequest *getFile =[AWSS3GetObjectRequest new];
    getFile.bucket = @"humanitymedia";
    getFile.key = [NSString stringWithFormat:@"UserImage/%@", hash];
    AWSS3 *S3 = [self s3];
    [[S3 getObject:getFile] continueWithBlock:^id(BFTask *task) {
        if ([task error]) {
            failure([task error]);
        } else {
            success([[task result] body]);
        }
        return nil;
    }];
    
}
///If successful, response will be NS
+ (void)getLatestStory:(void (^)(id response))success
               failure:(void (^)(id response))failure
                userID:(NSString*) userID{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager GET:[NSString stringWithFormat:@"http://lit-brushlands-7356.herokuapp.com/user/story/new?userID=%@",userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[@"status"] isEqualToString:@"error"]) {
            failure(nil);
        } else {
            if ([responseObject[@"data"] objectAtIndex:0]) {
                success([responseObject[@"data"] objectAtIndex:0]);
            }
        }
        //        NSString* JSON = responseObject;
        //        NSStringEncoding  encoding;
        //        NSData * jsonData = [JSON dataUsingEncoding:encoding];
        //        NSError * error=nil;
        //        NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        //        success(parsedData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

+ (void)getLast20Messages:(void (^)(id response))success
                  failure:(void (^)(id response))failure
                 userIDTo:(NSString*) userIDTo
               userIDFrom:(NSString*) userIDFrom{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager GET:[NSString stringWithFormat:@"http://lit-brushlands-7356.herokuapp.com/user/messages?userID1=%@&userID2=%@",userIDTo, userIDFrom] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}
///POST REQUESTS

/*
 //eventually has to take in dictionary as a parameter
 + (void)postRequest:(void (^)(id response))success //TEMP BASE
 failure:(void (^)(NSError *error))failure
 userDict:(NSDictionary*) userDict{
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 NSDictionary *parameters = @{@"name": @"Tai", @"username": @"SwagAddict", @"password": @"swagpass1994"};
 [manager POST:@"http://example.com/resources.json" parameters:userDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
 success(responseObject);
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 failure(error);
 NSLog(@"Error: %@", error);
 }];
 }
 */

///Private- Formats NS dictionary so DB can read it.
+ (NSDictionary *)generateParamsFromDictionary:(NSDictionary *)params {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    NSString *JSONString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return @{@"params" : JSONString};
}

///Response Object from server will be user ID, which will be used for the get requests (not the same as username)
+ (void)createUser:(void (^)(id response))success
           failure:(void (^)(NSError *error))failure
          userName:(NSString*) userName
             email:(NSString*) email
          password:(NSString*) password{
    NSDictionary* params = @{@"userName": userName,
                             @"email": email,
                             @"password": password};
    params = [self generateParamsFromDictionary:params];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager POST:@"http://lit-brushlands-7356.herokuapp.com/db/createUser" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}



// private
+ (NSString *)generateHash{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 16];
    for (int i=0; i<16; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform((u_int32_t)[letters length])]];
    }
    return randomString;
}

//// private
//+ (void)generateValidHash:(void (^)(id response))success
//                        failure:(void (^)(NSError *error))failure {
//    //generate hash
//    NSString *hash = [ServiceEndpoint generateHash];
//    [ServiceEndpoint isHashValid:^(id response) {
//        // check if response is yes
//        if ([response[@"isValid"] boolValue]) {
//            success(hash);
//        } else {
//            [ServiceEndpoint generateValidHash:success failure:failure];
//        }
//        // call success function
//        success(response);
//        // [ServiceEndpoint generateValidHash:success failure:failure];
//    } failure:^(NSError *error) {
//        // creativity
//    } hash:hash];
//}

//// private
//+ (void)isHashValid:(void (^)(id response))success
//           failure:(void (^)(NSError *error))failure
//              hash:(NSString*) hash{
//    NSDictionary* params = @{@"hash": hash};
//    params = [self generateParamsFromDictionary:params];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
//    [manager POST:@"http://lit-brushlands-7356.herokuapp.com/check/hash" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if(success){
//            success(hash);
//        }
//    }
//     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if(failure){
//            failure(error);
//        //NSLog(@"Error: %@", error);
//         }
//    }];
//
//}

//private
//called by upLoadImage
+ (void) createMediaTypeOnDB:(void (^)(id response))success
                     failure:(void (^)(NSError *error))failure
                        hash:(NSString*) hash
                   mediaType:(NSString*) mediaType{
    NSDictionary* params = @{@"hash": hash,
                             @"mediaType": mediaType};
    params = [self generateParamsFromDictionary:params];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager POST:@"http://lit-brushlands-7356.herokuapp.com/createMedia" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

///Upload UIImage onto S3. If successful, uploads hash name and media type onto heroku
+ (void)upLoadImage:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
              image:(UIImage*) image{
    //get hash
    NSString* hash = [self generateHash];
    //UIImage *testImage = [UIImage imageNamed:@"image.jpg"]; //TEMPORARY FOR TESTING, replace with image
    NSData * data = UIImageJPEGRepresentation(image, 1);
    AWSS3PutObjectRequest *logFile = [AWSS3PutObjectRequest new];
    logFile.bucket = @"humanitymedia";
    logFile.key = [NSString stringWithFormat:@"UserImage/%@.png", hash];
    logFile.contentType = @"NSData";
    logFile.body = data;
    logFile.contentLength = [NSNumber numberWithInteger:[data length]];
    
    AWSS3 *S3 = [self s3];
    
    [[S3 putObject:logFile] continueWithBlock:^id(BFTask *task) {
        // check if the put request was successful, then call success(nil) if it is.
        if ([task error]) {
            failure([task error]);
        }
        else{
            [self createMediaTypeOnDB:^(id response) {
                success(hash);
            } failure:^(NSError *error) {
                failure(error);
            } hash:hash mediaType:@"1"];
        };
        return nil;
    }];
}

+ (void)upLoadVideo:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
              video:(NSData*) video{
    NSString* hash = [self generateHash];
    AWSS3PutObjectRequest *logFile = [AWSS3PutObjectRequest new];
    logFile.bucket = @"humanitymedia";
    logFile.key = [NSString stringWithFormat:@"UserImage/%@", hash];
    logFile.contentType = @"NSData";
    logFile.body = video;
    logFile.contentLength = [NSNumber numberWithInteger:[video length]];
    
    AWSS3 *S3 = [self s3];
    
    [[S3 putObject:logFile] continueWithBlock:^id(BFTask *task) {
        // check if the put request was successful, then call success(nil) if it is.
        if ([task error]) {
            failure([task error]);
        }
        else{
            [self createMediaTypeOnDB:^(id response) {
                success(hash);
            } failure:^(NSError *error) {
                failure(error);
            } hash:hash mediaType:@"2"];
        };
        return nil;
    }];
    
    
}
///Hash argument should be provided in response object of uploadImage. Be sure to call postStory on postImage's success function, and make hash an empty string if the user decided NOT to upload a media. postImage's success response will give the hash of the image.
///Posts the story onto Heroku DB
+ (void)postStory:(void (^)(id response))success
          failure:(void (^)(NSError *error))failure
           userID:(NSString*) userID
             hash: (NSString*) hash
     storyContent:(NSString*) storyContent{
    NSDictionary* params;
    if (hash) {
        params = @{@"userID" :userID,
                   @"hash": hash,
                   @"message": storyContent};
    } else {
        params = @{@"userID" :userID,
                   @"message": storyContent};
    }
    
    params = [self generateParamsFromDictionary:params];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager POST:@"http://lit-brushlands-7356.herokuapp.com/postStory" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//If the message being posted is a media, call uploadImage/upLoadVideo and THEN call postMessage on the success function of uploadImage/upLoadVideo
+ (void)postMessage:(void (^)(id response))success
            failure:(void (^)(NSError *error))failure
           messsage:(NSString*) message
               hash:(NSString*) hash
           userIDTo:(NSString*) userIDTo
         userIDFrom:(NSString*) userIDFrom{
    NSDictionary* params = @{@"message": message,
                             @"hash": hash,
                             @"userIDTo": userIDTo,
                             @"userIDFrom": userIDFrom};
    params = [self generateParamsFromDictionary:params];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    [manager POST:@"http://lit-brushlands-7356.herokuapp.com/message/send" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

///for video upload use S3TransferManager (for bigger files)


@end

