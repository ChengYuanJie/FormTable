
//
//  LocateMapView.m
//  director
//
//  Created by Aaron on 16/7/27.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "LocateMapView.h"
#import "AMLoctionManager.h"
#import "AMLoction.h"
#import "CustomButton.h"
#import "UIView+resetFrame.h"
#import "UIColor+Theme.h"
#import "UIColor+Theme.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MaPNearPoiViewController.h"
#import "IMLocationModel.h"
#import "Masonry.h"
@interface LocateMapView()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic,strong) UILabel *locateLabel;
@property (nonatomic,strong) UIButton *commondBtn;
@property (nonatomic, strong) AMapSearchAPI *search; // 高德POI搜索
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) NSMutableArray *annotationArray;
@property (nonatomic,strong) NSMutableArray *overlayArray;
@property (nonatomic, assign) float mapHeight;
@property (nonatomic, assign) BOOL noLocated;

@end

@implementation LocateMapView
/**带地图的定位组件(默认内容高度为220px，其中地图高度为150px)*/
-(instancetype) initWithFrame:(CGRect) frame useMapView:(BOOL)useMapView  complete:(afterLocateHandle) afterLocate {
    self = [super initWithFrame:frame];
    if (self) {
        self.afterLocate = afterLocate;
        self.layer.masksToBounds= YES;
        [self initUI];
        self.useMapview = useMapView;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.location =[[AMLoction alloc] init];
        [self initUI];
        self.useMapview = YES;
        [self startLocate];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.locateLabel];
    [self addSubview:self.commondBtn];
    [self.locateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0);
        make.bottom.equalTo(self);
        make.right.equalTo(self.commondBtn.left).with.offset(-10.0);
        make.height.mas_equalTo(66.0f);
    }];

    [self.commondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-16.0);
        make.centerY.equalTo(self.locateLabel);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(40.0f);
    }];
}
-(void)setAddr:(NSString *)addr{
    _addr = addr;
    self.locateLabel.text = addr;
}
- (void)setUseMapview:(BOOL)useMapview {
    _useMapview = useMapview;
    if (_useMapview) {
        self.mapView.frame = CGRectMake(0, 0, self.frame.size.width, 150.0);
        [self insertSubview:self.mapView belowSubview:self.locateLabel];
    } else {
        [self.mapView removeFromSuperview];
    }
}

/**
 *  开始定位
 */
- (void)startLocate
{
    __weak typeof (self)wself = self;
     [[AMLoctionManager shareAMLoctionManager] startLocateForegroundWithFinished:^(AMLoction *location) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.commondBtn.layer removeAnimationForKey:@"rotation"];
         });
         if (_noLocated) {
             _noLocated = NO;
             return ;
         }
         if (wself.annotationArray.count>0) {
             [wself.mapView removeAnnotations:wself.annotationArray];
             [wself.annotationArray removeAllObjects];
         }
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.latitude.floatValue, location.longtitude.floatValue);
         MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
         startAnnotation.coordinate = coordinate;
         startAnnotation.title = @"我的位置";
         [wself.annotationArray insertObject:startAnnotation atIndex:0];
         [wself.mapView addAnnotation:startAnnotation];
         wself.mapView.centerCoordinate = coordinate;
         _location = location;
         wself.locateLabel.text = location.address;
         if(wself.afterLocate){
             wself.afterLocate(location);
         }
     } isShowAlert:NO];
    
}
- (void)stopLocation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.commondBtn.layer removeAnimationForKey:@"rotation"];
    });
    _noLocated = YES;
}
- (void)setMapViewCenter:(NSString *)lat lon:(NSString *)lon{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = coordinate;
    startAnnotation.title = @"我的位置";
    [self.annotationArray insertObject:startAnnotation atIndex:0];
    [self.mapView addAnnotation:startAnnotation];
    self.mapView.centerCoordinate = coordinate;
}
#pragma mark -lazy
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150.0)];
        _mapView.showsUserLocation = YES;
        _mapView.zoomLevel = 15;
        _mapView.delegate = self;
        _mapView.zoomEnabled = YES;
        _mapView.mapType = MAMapTypeStandard;
        _mapView.compassOrigin = CGPointMake(SCREEN_WIDTH - 70, _mapView.compassOrigin.y);
    }
    return _mapView;
}

- (UILabel *)locateLabel{
    if (!_locateLabel) {
        _locateLabel = [[UILabel alloc]init];
        _locateLabel.textColor = [UIColor textColor];
        _locateLabel.backgroundColor = [UIColor clearColor];
        _locateLabel.numberOfLines = 0;
        _locateLabel.font = [UIFont systemFontOfSize:16];
    }
    return _locateLabel;
}
- (UIButton *)commondBtn{
    if (!_commondBtn) {
        _commondBtn = [[UIButton alloc] init];
        [_commondBtn setImage:[UIImage imageNamed:@"刷新1"] forState:UIControlStateNormal];
        [_commondBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commondBtn;
}
- (NSMutableArray *)annotationArray{
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}
- (NSMutableArray *)overlayArray{
    if (!_overlayArray) {
        _overlayArray = [NSMutableArray array];
    }
    return _overlayArray;
}

- (void)btnClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [rotation setToValue:@(M_PI*2)];
        [rotation setDuration:1];
        [rotation setRepeatCount:HUGE_VALF];
        [self.commondBtn.layer addAnimation:rotation forKey:@"rotation"];
    });
    
    [self startLocate];
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    UIViewController *viewC = [AppDelegate shareAppDelegate].pushNavController.visibleViewController;
    if (self.isCanChoose) {
        MaPNearPoiViewController *share = [[MaPNearPoiViewController alloc] init];
        __weak typeof(self)wself = self;
        share.shareBlock = ^(UIImage *image,IMLocationModel *model){
            
            [wself.location setWithAddress:model.exInfo andLongitude:[NSString stringWithFormat:@"%f",model.longtitude] andLatitude:[NSString stringWithFormat:@"%f",model.latitude]];

            if (wself.annotationArray.count>0) {
                [wself.mapView removeAnnotations:wself.annotationArray];
                [wself.annotationArray removeAllObjects];
            }
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(wself.location.latitude.floatValue, wself.location.longtitude.floatValue);
            MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
            startAnnotation.coordinate = coordinate;
            startAnnotation.title = @"我的位置";
            [wself.annotationArray insertObject:startAnnotation atIndex:0];
            [wself.mapView addAnnotation:startAnnotation];
            wself.mapView.centerCoordinate = coordinate;
            wself.locateLabel.text = wself.location.address;
            if(wself.afterLocate){
                wself.afterLocate(wself.location);
            }
        };
        [viewC.navigationController pushViewController:share animated:YES];
    }
}

-(void) setLocation:(AMLoction *)location {
    _location = location;
    self.locateLabel.text = location.address;
}

@end
