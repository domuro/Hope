//
//  HMLatestPicturesTableViewCell.m
//  Humanity
//
//  Created by Derek Omuro on 11/17/14.
//  Copyright (c) 2014 domuro. All rights reserved.
//

#import "HMLatestPicturesTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface HMPictureCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation HMPictureCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}
@end

static NSString * const photoCellID = @"PhotoCellID";
static NSString * const assetKey = @"AssetKey";
static NSString * const thumbnailKey = @"ThumbnailKey";

@interface HMLatestPicturesTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) NSMutableArray *assetsArr;

@end

@implementation HMLatestPicturesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setItemSize:CGSizeMake(124, 124)];
        [layout setSectionInset:UIEdgeInsetsMake(0, 4, 0, 4)];
        [layout setMinimumInteritemSpacing:4];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 132) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[HMPictureCell class] forCellWithReuseIdentifier:photoCellID];
        [self addSubview:self.collectionView];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = library;
        self.assets = [NSMutableArray new];
        self.assetsArr = [NSMutableArray new];
        
        [self getPhotos];
        
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource and Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count > 5?5:self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellID forIndexPath:indexPath];
    [[(HMPictureCell *)cell imageView] setImage:[self.assets objectAtIndex:self.assets.count-1-indexPath.row][thumbnailKey]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ALAssetRepresentation *rep = [self.assetsArr[indexPath.row][assetKey] defaultRepresentation];
    CGImageRef iref = [rep fullScreenImage];
    if (iref) {
        if (self.delegate) {
            [self.delegate didSelectImage:[UIImage imageWithCGImage:iref]];
        }
    }
}

#pragma mark - ALAssetsLibrary
- (void)getPhotos
{
    NSMutableArray *groups = [NSMutableArray array];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        } else {
            // this is the end
            [self processAssetGroup:[groups objectAtIndex:0]];
        }
        
        self.assetsArr = [NSMutableArray arrayWithCapacity:[self.assets count]];
        NSEnumerator *reverseEnumerator = [self.assets reverseObjectEnumerator];
        
        for (id object in reverseEnumerator)
        {
            [self.assetsArr addObject:object];
        }
        
    } failureBlock:^(NSError *error) {
        // TODO: access not granted.
    }];
}

- (void)processAssetGroup:(ALAssetsGroup *)group
{
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.assets = [[NSMutableArray alloc] initWithCapacity:group.numberOfAssets];
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (!result) return;
        [self.assets addObject:@{assetKey: result, thumbnailKey: [UIImage imageWithCGImage:result.thumbnail]}];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

@end

