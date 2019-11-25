//
//  THCalendarCell.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/15.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "GQYearMonthDayDatePicker.h"
@interface THCalendarCell : FormBaseTableViewCell<GQYearMonthDayDatePickerDelegate>
@property (nonatomic, strong) GQYearMonthDayDatePicker *pickView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *certainButton;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIControl *bgControl;
@property (nonatomic, strong) FormLabel *label;

@end
