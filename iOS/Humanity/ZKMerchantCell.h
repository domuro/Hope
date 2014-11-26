//
//  ZKMerchantCell.h
//  ZakaConsumer
//
//  Created by Diep Nguyen on 4/23/14.
//  Copyright (c) 2014 Zaka, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKMerchantHeader : UILabel

@end

@interface ZKMerchantCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarImage;
@property (strong, nonatomic) UIImageView *merchantIndicatorImage;
@property (strong, nonatomic) UILabel *fullNameLabel;
@property (strong, nonatomic) UIButton *referralButton;
@property (nonatomic, strong) UIImageView *zakaBadge;
@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, assign) BOOL referralMode;

@end
