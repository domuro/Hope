//
//  HMLatestPicturesTableViewCell.h
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMLatestPictureTableViewCellDelegate <NSObject>

- (void)didSelectImage:(UIImage *)image;

@end

@interface HMLatestPicturesTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HMLatestPictureTableViewCellDelegate> delegate;
- (void)getPhotos;

@end
