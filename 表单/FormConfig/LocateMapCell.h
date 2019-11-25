//
//  LocateMapCell.h
//  director
//
//  Created by Aaron on 16/7/27.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "LocateMapView.h"
#import "AMLoction.h"
@interface LocateMapCell : FormBaseTableViewCell
@property (nonatomic, strong) LocateMapView *mapView;
@property (nonatomic, strong) AMLoction *location;
@property (nonatomic, strong) NSMutableDictionary *subDic;
- (void)reloadLoction;
@end
