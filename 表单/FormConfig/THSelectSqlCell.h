//
//  THSelectSqlCell.h
//  director
//
//  Created by Aaron on 16/7/25.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "FormBaseTableViewCell.h"

@interface THSelectSqlCell : FormBaseTableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *certainButton;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, copy)   NSString *starValue; //判断是否为初始值
@property (nonatomic, strong) FormLabel *label;
@end
