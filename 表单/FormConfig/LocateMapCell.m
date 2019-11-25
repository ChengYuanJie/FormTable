//
//  LocateMapCell.m
//  director
//
//  Created by Aaron on 16/7/27.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "LocateMapCell.h"
@interface LocateMapCell ()
@property (nonatomic, strong) UIView *bgView;
@end
@implementation LocateMapCell
- (void)creatUI{
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    CGFloat margin = 20/375.f*SCREEN_WIDTH;
    CGFloat height = self.moduleInfo.isShowMap?(220 + 2*margin):(70 + 2*margin);
    self.subDic = [NSMutableDictionary dictionary];
    
    NSString *addStr  = nil;
    NSString *lngStr  = nil;
    NSString *latStr  = nil;
    NSString *proStr  = nil;
    NSString *disStr  = nil;
    NSString *strStr  = nil;
    NSString *conStr  = nil;
    NSString *typeStr  = nil;
    NSString *timeStr  = nil;
    if(![self.moduleInfo.key isEqualToString:@"dingwei"] && ![self.moduleInfo.key isEqualToString:@"lonlat"]){
        addStr = [NSString stringWithFormat:@"%@_address",self.moduleInfo.key];
        lngStr = [NSString stringWithFormat:@"%@_lng",self.moduleInfo.key];
        latStr = [NSString stringWithFormat:@"%@_lat",self.moduleInfo.key];
        proStr = [NSString stringWithFormat:@"%@_province",self.moduleInfo.key];
        disStr = [NSString stringWithFormat:@"%@_district",self.moduleInfo.key];
        conStr = [NSString stringWithFormat:@"%@_county",self.moduleInfo.key];
        strStr = [NSString stringWithFormat:@"%@_street",self.moduleInfo.key];
        typeStr = [NSString stringWithFormat:@"%@_type",self.moduleInfo.key];
        timeStr = [NSString stringWithFormat:@"%@_time",self.moduleInfo.key];
    }else{
        addStr = @"address";
        lngStr = @"lon";
        latStr = @"lat";
    }
    double stratTime = [DateUtil getNowNetTime];
    __weak typeof (self)wself = self;
    self.mapView = [[LocateMapView alloc] initWithFrame:CGRectMake(margin, margin, SCREEN_WIDTH - 2*margin, height - 2*margin) useMapView:self.moduleInfo.isShowMap complete:^(AMLoction *location){
        wself.location = location;
        double endTime = [DateUtil getNowNetTime];
        if ([self.moduleInfo.key isEqualToString:@"lonlat"]) {
            [_subDic setValue:location.address forKey:addStr];
            [_subDic setValue:location.longtitude forKey:lngStr];
            [_subDic setValue:location.latitude forKey:latStr];
        } else if (![self.moduleInfo.key isEqualToString:@"dingwei"]) {
            [_subDic setValue:location.address forKey:addStr];
            [_subDic setValue:location.longtitude forKey:lngStr];
            [_subDic setValue:location.latitude forKey:latStr];
            [_subDic setValue:location.province forKey:proStr];
            [_subDic setValue:location.city forKey:disStr];
            [_subDic setValue:location.district forKey:conStr];
            [_subDic setValue:location.street forKey:strStr];
            [_subDic setValue:[NSString stringWithFormat:@"%.lf",endTime - stratTime] forKey:timeStr];
            [_subDic setValue:@"GPS" forKey:typeStr];
        } else{
            [_subDic setValue:location.address forKey:addStr];
            [_subDic setValue:location.longtitude forKey:lngStr];
            [_subDic setValue:location.latitude forKey:latStr];
            [_subDic setValue:location.province forKey:@"province"];
            [_subDic setValue:location.city forKey:@"city"];
            [_subDic setValue:location.district forKey:@"county"];
            [_subDic setValue:location.geoHash?:@"" forKey:@"geoHash"];
            if (self.moduleInfo.haveCityCode) {
                [_subDic setValue:location.citycode forKey:@"citycode"];
            }
        }
        wself.moduleInfo.value = _subDic.copy;
    }];
    self.mapView.isCanChoose = self.moduleInfo.isCanChoose;
    if ([self.moduleInfo.isLocation isEqualToString:@"1"]) {
        [self.mapView startLocate];
    }
    self.rowH = height;
    [self.contentView addSubview:self.mapView];
}
- (void)reloadLoction{
    [self.mapView startLocate];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self.subDic[@"address"] length] > 0) {
        self.moduleInfo.value = _subDic;
    }
    if ([self.moduleInfo.value[@"address"] length] > 0) {
        self.mapView.addr = self.moduleInfo.value[@"address"];
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    [_subDic setValue:valueDic[@"address"]?valueDic[@"address"]:@"" forKey:@"address"];
    [_subDic setValue:[NSString stringWithFormat:@"%@",valueDic[@"lon"]?valueDic[@"lon"]:@""] forKey:@"lon"];
    [_subDic setValue:[NSString stringWithFormat:@"%@",valueDic[@"lat"]?valueDic[@"lat"]:@""] forKey:@"lat"];
    [_subDic setValue:valueDic[@"city"]?valueDic[@"city"]:@"" forKey:@"city"];
    [_subDic setValue:valueDic[@"province"]?valueDic[@"province"]:@"" forKey:@"province"];
    if (self.moduleInfo.haveCityCode) {
        [_subDic setValue:valueDic[@"citycode"]?valueDic[@"citycode"]:@"" forKey:@"citycode"];
    }
    [_subDic setValue:valueDic[@"county"]?valueDic[@"county"]:@"" forKey:@"county"];
    [self.mapView stopLocation];
    self.mapView.addr = valueDic[@"address"];
    [self.mapView setMapViewCenter:valueDic[@"lat"] lon:valueDic[@"lon"]];
}

@end
