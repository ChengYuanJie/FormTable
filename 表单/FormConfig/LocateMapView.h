//
//  LocateMapView.h
//  director
//
//  Created by Aaron on 16/7/27.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMLoction.h"
#import "BaseShadowView.h"
#import <MAMapKit/MAMapKit.h>

typedef void (^afterLocateHandle)(AMLoction *location);
@interface LocateMapView : BaseShadowView
/**带地图的定位组件(默认内容高度为242px，其中地图高度为150px)*/
/**
 *  是否显示定位地图
 */
@property (nonatomic,assign) BOOL useMapview;
/**定位位置信息（包含经纬度和位置）*/
@property (nonatomic,strong) AMLoction *location;
/**定位完成后回调*/
@property (nonatomic,copy) afterLocateHandle afterLocate;
/**是否可以选择地址*/
@property (nonatomic,assign) BOOL isCanChoose;
@property (nonatomic,copy) NSString *addr;
/**
 *  开始定位
 */
- (void)startLocate;
- (void)stopLocation;
/**
 *  增加圆形覆盖物
 */
-(instancetype) initWithFrame:(CGRect) frame useMapView:(BOOL)useMapView  complete:(afterLocateHandle) afterLocate;
- (void)setMapViewCenter:(NSString *)lat lon:(NSString *)lon;
@end
