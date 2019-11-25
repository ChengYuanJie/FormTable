//
//  PhotoView.h
//  itfsmlib
//
//  Created by Noah on 16/7/6.
//  Copyright © 2016年 Keyloft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SpaceLength 10.0f*SCREEN_WIDTH_6
@protocol PhotoViewDelegate <NSObject>
@optional
- (void)didTakePhoto:(NSInteger)count;
- (void)didDelPhoto:(NSInteger)index;
@end


@interface PhotoView : UICollectionView

- (instancetype)initPhotoView;

@property (nonatomic, strong) NSMutableArray *picArray;

@property (nonatomic, assign) NSInteger maxPicCount;

@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;

@property (nonatomic, assign) BOOL isNeedWater;

@property (nonatomic,assign) BOOL canSelect;

@property (nonatomic,copy) NSString *waterPrint;

@property (nonatomic,copy) NSString *waterPrintColor;

@property (nonatomic,copy) NSString *cameraType; //1单排 2 连拍 默认为单排

@property (nonatomic, assign) BOOL isShowNetPic;
@property (nonatomic, strong) NSNumber *picWidth;
@property (nonatomic, strong) NSNumber *picHeight;
@property (nonatomic,assign) BOOL isRC;
- (void)getCameraPicture;

@end
