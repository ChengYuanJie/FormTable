//
//  THTakePhotoCell.m
//  director
//
//  Created by Aaron on 16/7/26.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "PhotoTaker.h"
#import "DateUtil.h"
#import "AMLoctionManager.h"
#import "WOActionTool.h"
#import "NetLinkConfigManager.h"
#define PIC_HEIGHT  160
#define PIC_WIDTH   160
#define MOER_PIC_HEIGHT 282.f*SCREEN_HEIGHT_RATIO
#define ONE_PIC_HEIGHT 170.f*SCREEN_HEIGHT_RATIO

#define SCREEN_WIDTH_6 SCREEN_WIDTH/375.f
@interface PhotoTaker()<PhotoViewDelegate>
@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation PhotoTaker
- (void)creatUI{
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    self.picArray = [[NSMutableArray alloc] init];
    PhotoView *view = [[PhotoView alloc] initPhotoView];
    view.photoViewDelegate = self;
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 15)];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = self.moduleInfo.label;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.photoView = view;
    view.canSelect = self.moduleInfo.canSelect;
    view.waterPrint = self.moduleInfo.waterPrint;
    view.waterPrintColor = self.moduleInfo.waterPrintColor;
    view.isShowNetPic = self.moduleInfo.isNetPic;
    self.rowH = ONE_PIC_HEIGHT;
    self.photoView.frame = CGRectMake(0, 38, SCREEN_WIDTH,self.rowH - 48);
    self.photoView.maxPicCount = self.moduleInfo.maxPicCount;
    ANLog(@"%f",self.photoView.frame.size.width);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.picArray = self.photoView.picArray;
    if ([self.moduleInfo.isAutoTakeImg isEqualToString:@"YES"]){
        [self.photoView getCameraPicture];
    }
    [self.contentView addSubview:self.photoView];
    UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoView.frame), SCREEN_WIDTH, 10)];
    botView.backgroundColor = HUI_COLOR;
    [self.contentView addSubview:botView];
    self.botView = botView;
    [self.photoView reloadData];
    if ([self.moduleInfo.value isKindOfClass:[NSString class]] &&  [self.moduleInfo.value length] > 0) {
        [self setImgData:self.moduleInfo.value];
    } else if ([self.moduleInfo.value isKindOfClass:[NSArray class]]) {
        self.picArray = [NSMutableArray arrayWithArray:self.moduleInfo.value];
        self.photoView.picArray = self.picArray;
        [self.photoView reloadData];
    }
}
- (void)setHiddenBot:(BOOL)hiddenBot{
    self.botView.hidden = hiddenBot;
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]){
        [self setImgData:valueDic[self.moduleInfo.key]];
    }
}
- (void)setImgData:(NSString *)imgs{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *imageIdarray = [imgs componentsSeparatedByString:@","];
        for (NSString *strData in imageIdarray) {
            NSData *data = [ImageCacheTools getImageDataWithKey:strData];
            // 判断是本地图片还是网络题片
            if (!data) {
                NSString *url = [[NetLinkConfigManager shareNetLinkManager] getImageUrlWithFile:strData key:nil];
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            }
            if ([data length] >  0){
                [self.picArray addObject:data];
            }
        }
        self.moduleInfo.value = self.picArray;
        self.photoView.picArray = self.picArray;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.photoView reloadData];
//            if (self.picArray.count > 3 && self.rowH != MOER_PIC_HEIGHT) {
//                self.rowH = MOER_PIC_HEIGHT;
//                [self reloadCellHeight];
//            }
        });
    });

}
#pragma mrk -- didTakePhotoDelegate
- (void)didTakePhoto:(NSInteger)count {
    self.moduleInfo.value = self.picArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.customTableView) {
            self.customTableView = [self tableView];
        }
        if (self.picArray.count > 2 && self.rowH != MOER_PIC_HEIGHT) {
            self.rowH = MOER_PIC_HEIGHT;
            [self reloadCellHeight];
        }
        [self.customTableView reloadData];
    });
}
-(void)didDelPhoto:(NSInteger)count{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.customTableView) {
            return;
        }
        if (self.picArray.count < 3) {
            self.rowH = ONE_PIC_HEIGHT;
            [self reloadCellHeight];
        }
        [self.customTableView reloadData];
    });
}
- (void)reloadCellHeight{
    NSIndexPath *indexPath = [self.customTableView indexPathForCell:self];
    [self.customTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    self.photoView.frame = CGRectMake(0, 38, SCREEN_WIDTH,self.rowH - 48);
    self.botView.frame = CGRectMake(0, CGRectGetMaxY(self.photoView.frame), SCREEN_WIDTH, 10);
    [self.customTableView beginUpdates];
    [self.customTableView endUpdates];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoTakerHeightChange" object:nil];
}
-(void)setMaxPic:(NSInteger)maxPic{
    _maxPic = maxPic;
    self.photoView.maxPicCount = _maxPic;
}
- (UITableView *)tableView

{
    
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        
        tableView = tableView.superview;
        
    }
    
    return (UITableView *)tableView;
    
}

@end
