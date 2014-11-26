//
//  ZKMerchantCell.m
//  ZakaConsumer
//
//  Created by Diep Nguyen on 4/23/14.
//  Copyright (c) 2014 Zaka, Inc. All rights reserved.
//

#import "ZKMerchantCell.h"
#import "HMTheme.h"

@implementation ZKMerchantHeader

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 16, 0, 16};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

@implementation ZKMerchantCell{
    UIImageView *_checkedImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImage.clipsToBounds = YES;
        [self.contentView addSubview:self.avatarImage];
        
        self.merchantIndicatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 46, 19, 19)];
        self.merchantIndicatorImage.image = [UIImage imageNamed:@"ZakaMarkIcon"];
        [self.contentView addSubview:self.merchantIndicatorImage];
    
        int width = [[UIScreen mainScreen] bounds].size.width - 75;
        self.fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 12, width, 25)];
        self.fullNameLabel.backgroundColor = [UIColor clearColor];
        self.fullNameLabel.textColor = [UIColor blackColor];
        self.fullNameLabel.font = [HMTheme fontWithSize:16];
        [self.contentView addSubview:self.fullNameLabel];
        
        self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 35, width, 30)];
        self.categoryLabel.backgroundColor = [UIColor clearColor];
        self.categoryLabel.textColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
        self.categoryLabel.font = [HMTheme fontWithSize:12];
        self.categoryLabel.textAlignment = NSTextAlignmentLeft;
        [self.categoryLabel setNumberOfLines:0];
        [self.contentView addSubview:self.categoryLabel];
        
        self.referralButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 4, 70, 70)];
        self.referralButton.center = CGPointMake(290, self.avatarImage.center.y);
        [self.referralButton setImage:[UIImage imageNamed:@"arrow-icon-addBusiness"] forState:UIControlStateNormal];
        self.referralButton.showsTouchWhenHighlighted = YES;
        self.referralButton.userInteractionEnabled = NO;
        [self.contentView addSubview:self.referralButton];
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
//        }
        
        _checkedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _checkedImage.center = CGPointMake(25, 35);
        _checkedImage.image=[UIImage imageNamed:@"CheckBox_normal"];
        [_checkedImage setHidden:YES];
        [self addSubview:_checkedImage];
        
        self.zakaBadge = [[UIImageView alloc] initWithFrame:CGRectMake(60-15, 60-15, 20, 20)];
        [self.zakaBadge setImage:[UIImage imageNamed:@"zaka-badge"]];
        [self.zakaBadge setHidden:YES];
        [self.contentView addSubview:self.zakaBadge];
    }
    return self;
}

- (void)setReferralMode:(BOOL)referralMode{
    _referralMode = referralMode;
    [self.referralButton setHidden:_referralMode];
    [_checkedImage setHidden:!_referralMode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
