//
//  PhotoView.m
//  itfsmlib
//
//  Created by Noah on 16/7/6.
//  Copyright © 2016年 Keyloft.com. All rights reserved.
//

#import "PhotoView.h"
#import "PhotoCell.h"
#import "UIImage+WaterMark.h"
#import "AMLoctionManager.h"
#import "LGPhoto.h"
#import "TenantEmployManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "PhotoManager.h"

@interface PhotoView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,LGPhotoPickerBrowserViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource>{
}

@property (nonatomic, weak) UIImageView *showView;

@property (nonatomic, weak) UIView *shadowView;

@property (nonatomic, weak) UIButton *deleteBtn;

@property (nonatomic, weak) NSString *extraInfo;

@property (nonatomic, assign) BOOL isDel;

@property (nonatomic, strong) PhotoManager *manager;
@end


@implementation PhotoView


- (instancetype)initPhotoView {
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    fl.minimumInteritemSpacing = 5*SCREEN_WIDTH_RATIO;
    fl.minimumLineSpacing = 5*SCREEN_WIDTH_RATIO;
    self = [[PhotoView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
    self.bounces = NO;
    [self registerNib:[UINib nibWithNibName:@"PhotoView" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PhotoCell"];
    self.delegate = self;
    self.dataSource = self;
    return self;
}

#pragma mark --UICollectionViewDelegate--
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isShowNetPic) {
        return self.picArray.count ;
    }else{
        if (self.picArray.count < 1) {
            return 1;
        } else {
            return self.picArray.count + 1;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.isRC = _isRC;
    WS(wself);
    cell.block = ^{
        [wself.picArray removeObjectAtIndex:indexPath.item];
        [wself reloadData];
        if ([wself.photoViewDelegate respondsToSelector:@selector(didDelPhoto:)]) {
            [wself.photoViewDelegate didDelPhoto:indexPath.item];
        }
    };
    if (self.isShowNetPic) {
        [cell showDel:NO];
        [cell addPic:self.picArray[indexPath.item] isFromNet:YES];
        return cell;
    }
    if (self.picArray.count == 0) {
        [cell.imgView removeFromSuperview];
        [cell showDel:NO];
        [cell addView];
        return cell;
    }
    if (indexPath.item == self.picArray.count){
        [cell.imgView removeFromSuperview];
        [cell showDel:NO];
        [cell addView];
        return cell;
    }else {
        if ([self.picArray[indexPath.item] isKindOfClass:[NSData class]]) {
            cell.imgView.image = [UIImage imageWithData:self.picArray[indexPath.item]];
        } else if ([self.picArray[indexPath.item] isKindOfClass:[NSString class]]) {
            cell.imgView.image = [UIImage imageWithData:[ImageCacheTools getImageDataWithKey: self.picArray[indexPath.item]]];
        }
        [cell.contentView addSubview:cell.imgView];
        [cell showDel:YES];
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectClick:indexPath];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = self.picWidth? self.picWidth.floatValue : (self.bounds.size.width - 4 * SpaceLength)/3;
    CGFloat height = self.picHeight? self.picHeight.floatValue : (self.bounds.size.width - 4 * SpaceLength)/3;
    
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, SpaceLength,SpaceLength,SpaceLength);
}

-(void)didSelectClick:(NSIndexPath *)indexPath
{
    if (self.isShowNetPic) {
        [self changeSize:indexPath.item];
        return;
    }
    if (indexPath.item == self.picArray.count) {
        [self getCameraPicture];
    } else {
        [self changeSize:indexPath.item];
    }
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}
- (NSMutableArray *)picArray {
    
    if (_picArray == nil) {
        _picArray = [[NSMutableArray alloc] init];
    }
    return _picArray;
}

- (void)changeSize:(NSInteger)imgIndex {
    LGPhotoPickerBrowserViewController *browserVc = [[LGPhotoPickerBrowserViewController alloc] init];
    browserVc.delegate = self;
    browserVc.dataSource = self;
    browserVc.isDeleteShow = self.isShowNetPic;
    browserVc.showType = LGShowImageTypeImageBroswer;
    browserVc.currentIndexPath = [NSIndexPath indexPathForItem:imgIndex inSection:0];
    [[AppDelegate shareAppDelegate].pushNavController presentViewController:browserVc animated:NO completion:nil];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.picArray.count;
}
- (LGPhotoPickerBrowserPhoto *) photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    id imageObj;
    if (self.isShowNetPic){
        imageObj = [self.picArray objectAtIndex:indexPath.row];
        if ([imageObj isKindOfClass:[NSString class]]) {
            if ([imageObj hasPrefix:@"http"]) {
                imageObj = [NSURL URLWithString:imageObj];
            } else {
                imageObj = [UIImage imageWithData:[ImageCacheTools getImageDataWithKey:imageObj]];
            }
        }else if ([imageObj isKindOfClass:[NSData class]]){
            imageObj = [UIImage imageWithData:imageObj];
        }
    } else {
        id imgData = [self.picArray objectAtIndex:indexPath.row];
        if ([imgData isKindOfClass:[NSString class]]) {
            if ([imgData hasPrefix:@"data:image/jpg;base64,"]) {
                imgData = [imgData stringByReplacingOccurrencesOfString:@"data:image/jpg;base64," withString:@""];
                imageObj = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:imgData options:NSDataBase64DecodingIgnoreUnknownCharacters]];
            } else {
                imageObj = [UIImage imageWithData:[ImageCacheTools getImageDataWithKey:imgData]];
            }
        } else if ([imgData isKindOfClass:[NSData class]]) {
            imageObj = [UIImage imageWithData:imgData];
        }
    }
    LGPhotoPickerBrowserPhoto *photo = [LGPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
    UICollectionViewCell *cell = (UICollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    UIImageView *imageView = [[cell.contentView subviews] lastObject];
    photo.toView = imageView;
    photo.thumbImage = imageView.image;
    return photo;
}

-(void)updateImageCount:(NSUInteger)count{
    [self.picArray removeObjectAtIndex:count];
    [self reloadData];
    if ([self.photoViewDelegate respondsToSelector:@selector(didDelPhoto:)]) {
        [self.photoViewDelegate didDelPhoto:count];
    }
}
- (void)getCameraPicture {
    if (self.maxPicCount == 0) {
        self.maxPicCount = [TenantEmployManager shareTenantEmployManager].max_pics_limit.intValue;
    }
    if (self.picArray.count >= self.maxPicCount) {
        UIAlertViewQuick(@"提示", [NSString stringWithFormat:@"图片数量不能超过%ld张",(long)self.maxPicCount], @"确定");
        return;
    }
    
    if (self.canSelect) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"打开相册", nil];
        [actionSheet showInView:actionSheet];
    }else{
        [self selectCamareType];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self selectCamareType];
            break;
        case 1:
            [self selectImageFromAlbum];
            break;
        case 2:
            break;
        default:
            break;
    }
}
- (void)selectImageFromAlbum{
    [self presentPhotoPickerViewController];
}
// 打开相册
- (void)presentPhotoPickerViewController{
    // 创建控制器
    self.manager = [[PhotoManager alloc] init];
    self.manager.photoType = PHOTO_IMG;
    self.manager.extraInfo = self.extraInfo;
    self.manager.waterPrintColor = self.waterPrintColor;
    self.manager.waterPrint = self.waterPrint;
    self.manager.isNeedWater = self.isNeedWater;
    self.manager.maxPicCount = self.maxPicCount != 0? self.maxPicCount - self.picArray.count:self.maxPicCount;
    __weak typeof(self) wself = self;
    [self.manager photo:^(NSArray *datas) {
        [wself handlePicImage:datas];
    }];
}
// 打开相机
- (void)selectCamareType{
    self.manager = [[PhotoManager alloc] init];
    self.manager.photoType = PHOTO_ONLY;
    self.manager.extraInfo = self.extraInfo?self.extraInfo:[AMLoction getLastLocl].address;
    self.manager.waterPrint = self.waterPrint;
    self.manager.waterPrintColor = self.waterPrintColor;
    self.manager.maxPicCount = self.maxPicCount != 0? self.maxPicCount - self.picArray.count:[TenantEmployManager shareTenantEmployManager].max_pics_limit.intValue;
    self.manager.isNeedWater = self.isNeedWater;
    __weak typeof(self) wself = self;
    [self.manager photo:^(NSArray *datas) {
        [wself handlePicImage:datas];
    }];
}

- (void)handlePicImage:(NSArray *)array {
    [self.picArray addObjectsFromArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
        if ([self.photoViewDelegate respondsToSelector:@selector(didTakePhoto:)]) {
            [self.photoViewDelegate didTakePhoto:self.picArray.count];
        }
    });
}

@end

