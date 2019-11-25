//
//  FormPhotoTaker.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormPhotoTaker.h"
#import "PhotoView.h"
#import <ReactiveObjc.h>
#import "Masonry.h"
#define MOER_PIC_HEIGHT 282.f*SCREEN_HEIGHT_6
#define ONE_PIC_HEIGHT 130.f*SCREEN_HEIGHT_6
@interface FormPhotoTaker ()<PhotoViewDelegate>

@property (nonatomic, strong) PhotoView *photoView;

@end

@implementation FormPhotoTaker

- (void)creatUI {
    [super creatUI];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.right.equalTo(wself.right).with.offset(-ContentMargin);
        make.top.equalTo(wself.top);
    }];
    [self addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.titleLbl.bottom).offset(ContentMargin);
        make.height.mas_equalTo(ONE_PIC_HEIGHT);
    }];
    [self setBottomLine:self.photoView];
    RACChannelTo(wself, value) = RACChannelTo(wself.photoView, picArray);
}

- (PhotoView *)photoView {
    if (!_photoView) {
        _photoView = [[PhotoView alloc] initPhotoView];
        _photoView.photoViewDelegate = self;
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoView.scrollEnabled = NO;
        _photoView.maxPicCount = self.maxCount;
        _photoView.isShowNetPic = self.readonly;
    }
    return _photoView;
}

#pragma mrk -- didTakePhotoDelegate
- (void)didTakePhoto:(NSInteger)count {
    [self reloadRowHeight];
    [self.tableView reloadData];
}
-(void)didDelPhoto:(NSInteger)count{
    [self didTakePhoto:count];
}
- (void)reloadRowHeight{
    NSInteger picCount = self.photoView.picArray.count +1;
    NSInteger count = 1;
    if (picCount % 3 == 0) {
        count = picCount / 3;
    } else {
        count = picCount / 3 + 1;
    }
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(count*ONE_PIC_HEIGHT);
    }];
}
- (CGFloat)defaultHeight {
    NSInteger picCount = self.photoView.picArray.count +1;
    NSInteger count = 1;
    if (picCount % 3 == 0) {
        count = picCount / 3;
    } else {
        count = picCount / 3 + 1;
    }
    return ((SCREEN_WIDTH - SpaceLength * 6.0) / 3.0) * (CGFloat)count + SpaceLength*((CGFloat)count-1.0) + SpaceLength * 2.0 + 33.0*SCREEN_WIDTH_6;
}
- (id)exportValue {
    NSMutableArray *array = [NSMutableArray array];
    for (NSData *data in self.value) {
        NSString *guid = [NSUUID getCapitalsUUID];
        [ImageCacheTools saveImage:data name:guid];
        [array addObject:guid];
    }
    return array;
}

- (void)importValue:(NSDictionary *)value {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *imageIdarray = [value[self.code] componentsSeparatedByString:@","];
        for (NSString *strData in imageIdarray) {
            NSData *data = [ImageCacheTools getImageDataWithKey:strData];
            // 判断是本地图片还是网络题片
            if (!data) {
                NSString *url = [[NetLinkConfigManager shareNetLinkManager] getDataServiceImgWithFileName:strData];
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            }
            if ([data length] >  0){
                [self.photoView.picArray addObject:data];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.photoView reloadData];
        });
    });

}
- (NSString *)cherkValue{
    if (!self.photoView.picArray.count && self.required) {
        return [NSString stringWithFormat:@"请拍摄%@",self.label];
    }
    return nil;
}
- (NSString *)warningText{
    if (self.required) {
        return [NSString stringWithFormat:@"请拍摄%@",self.label];
    }
    return nil;
}
- (void)setReadonly:(BOOL)readonly {
    self.userInteractionEnabled = !readonly;
    self.photoView.isShowNetPic = readonly;
    [self.photoView reloadData];
}
@end
