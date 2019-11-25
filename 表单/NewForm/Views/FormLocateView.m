//
//  FormLocateView.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormLocateView.h"
#import "LocateMapView.h"
#import "UIView+resetFrame.h"
#import <ReactiveObjc.h>

@interface FormLocateView ()

@property (nonatomic, strong) LocateMapView *mapView;

@end
@implementation FormLocateView

- (void)creatUI {
    [super creatUI];
    [self addSubview:self.mapView];
    WS(wself);
    RACChannelTo(wself, isCanChoose) = RACChannelTo(wself.mapView, isCanChoose);
    [self.mapView startLocate];
}

- (LocateMapView *)mapView {
    if (!_mapView) {
        WS(wself);
        _mapView = [[LocateMapView alloc] initWithFrame:CGRectMake(ContentMargin, ContentMargin, SCREEN_WIDTH - 2.0*ContentMargin, [self mapViewHeight] - 2*ContentMargin) useMapView:YES complete:^(AMLoction *location){
            NSMutableDictionary *dictM = @{}.mutableCopy;
            [dictM setValue:location.address forKey:@"address"];
            [dictM setValue:location.longtitude forKey:@"lon"];
            [dictM setValue:location.latitude forKey:@"lat"];
            [dictM setValue:location.province forKey:@"province"];
            [dictM setValue:location.city forKey:@"city"];
            [dictM setValue:location.district forKey:@"county"];
            wself.value = dictM.copy;
        }];
    }
    return _mapView;
}
- (void)setIsShowMap:(BOOL)isShowMap {
    _isShowMap = isShowMap;
    self.mapView.sizeHeight = [self mapViewHeight];
    self.mapView.useMapview = _isShowMap;
}

- (CGFloat)mapViewHeight {
    return _isShowMap?220.0:70.0;
}
- (CGFloat)defaultHeight {
    return [self mapViewHeight] + 2*ContentMargin;
}

- (void)importValue:(NSDictionary *)value {
    NSMutableDictionary *dictM = @{}.mutableCopy;
    [dictM setValue:value[@"address"]?value[@"address"]:@"" forKey:@"address"];
    [dictM setValue:value[@"lon"]?value[@"lon"]:@"" forKey:@"lon"];
    [dictM setValue:value[@"lat"]?value[@"lat"]:@"" forKey:@"lat"];
    [dictM setValue:value[@"province"]?value[@"province"]:@"" forKey:@"province"];
    [dictM setValue:value[@"city"]?value[@"city"]:@"" forKey:@"city"];
    [dictM setValue:value[@"county"]?value[@"county"]:@"" forKey:@"county"];
    
    self.value = dictM.copy;
    self.mapView.addr = dictM[@"address"];
    [self.mapView setMapViewCenter:dictM[@"lat"] lon:dictM[@"lon"]];
}

- (void)setReadonly:(BOOL)readonly {
    [super setReadonly:readonly];
    [self.mapView stopLocation];
}

@end
