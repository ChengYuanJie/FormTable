//
//  PrefectureCell.h
//  THStandardEdition
//
//  Created by Aaron on 2016/12/6.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "DQAreasView.h"
#import "DQAreasModel.h"
@interface DistrictSelectView : FormBaseTableViewCell<DQAreasViewDelegate>

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) FormLabel *label;
@property (nonatomic, strong) DQAreasView *areasView;//所在地
@property (nonatomic, strong) NSDictionary *subDic;

@end
