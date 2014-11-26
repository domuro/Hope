//
//  HMMediaOptions.m
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMMediaOptions.h"
#import "HMTheme.h"
#import "HMLatestPicturesTableViewCell.h"

@interface HMMediaOptions () <UITableViewDataSource, UITableViewDelegate, HMLatestPictureTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HMMediaOptions

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView setScrollEnabled:NO];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)reloadData {
    HMLatestPicturesTableViewCell *cell = (HMLatestPicturesTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell getPhotos];
}

#pragma mark - UITableViewDelegate and DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 134;
    } else {
        return 52;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row?@"CellID":@"LatestID"];
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [[HMLatestPicturesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LatestID"];
            [(HMLatestPicturesTableViewCell*)cell setDelegate:self];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        }
    }
    
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        NSArray *labels = @[@"Photo Library", @"Take Photo or Video", @"Cancel"];
        [cell.textLabel setText:labels[indexPath.row-1]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:[HMTheme tintColor]];
        [cell.textLabel setFont:[HMTheme fontWithSize:20]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate) {
        switch (indexPath.row) {
            case 1:
                // photo library
                [self.delegate mediaOptionsDidSelectLibrary:self];
                break;
            case 2:
                // take photo
                [self.delegate mediaOptionsDidSelectPhoto:self];
                break;
            default:
                // cancel or something weird happened
                [self.delegate mediaOptionsDidSelectCancel:self];
                break;
        }
    }
}

#pragma mark - HMLatestPictureTableViewCellDelegate
- (void)didSelectImage:(UIImage *)image {
    // use this image
    [self.delegate mediaOptions:self didSelectImage:image];
}

@end