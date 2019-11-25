
//
//  THDataAndTimeCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/8.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "DatePicker.h"
#import "WSDatePickerView.h"

@interface DatePicker ()

@property (nonatomic, strong) DatePicker *picker;

@end

@implementation DatePicker
- (void)creatUI
{
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 44.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.moduleInfo.value){
        [self.selectButton setTitle:self.moduleInfo.value forState:UIControlStateNormal];
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *sss = valueDic[self.moduleInfo.key];
        [_selectButton setTitle:sss forState:UIControlStateNormal];
        self.moduleInfo.value = sss;
    }
}

- (void)buttonAction:(UIButton *)sender
{
    [self.superview.superview endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    WSDatePickerView *datepicker;
    if (self.moduleInfo.defultDate) {
        datepicker = [[WSDatePickerView alloc] initWithDateStyle:[self datePickerType]  scrollToDate:self.moduleInfo.defultDate CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:[self buildTimeType]];
            if (self.moduleInfo.exBlock) {
                self.moduleInfo.exBlock(dateString);
            }else{
                [self.selectButton setTitle:dateString forState:UIControlStateNormal];
                self.moduleInfo.value = dateString;
                self.value = dateString;
                if (self.moduleInfo.exctuedBlock) {
                    self.moduleInfo.exctuedBlock();
                }
            }
            
        }];
    }else{
        datepicker = [[WSDatePickerView alloc] initWithDateStyle:[self datePickerType] CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:[self buildTimeType]];
            if (self.moduleInfo.exBlock) {
                self.moduleInfo.exBlock(dateString);
            }else{
                [self.selectButton setTitle:dateString forState:UIControlStateNormal];
                self.moduleInfo.value = dateString;
                self.value = dateString;
                if (self.moduleInfo.exctuedBlock) {
                    self.moduleInfo.exctuedBlock();
                }
            }
            
        }];
    }
    datepicker.cancelBlock = ^(){
        [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    };
    if (self.moduleInfo.isMaxDate) {
       datepicker.maxLimitDate = [NSDate date];
    }
    if (self.moduleInfo.minDate > 0) {
        datepicker.minLimitDate = [[NSDate alloc] initWithTimeIntervalSince1970:self.moduleInfo.minDate];
    }
    if (self.moduleInfo.isMinDate) {
        datepicker.minLimitDate = [NSDate date];
    }
    //    datepicker.dateLabelColor = randomColor;//年-月-日-时-分 颜色
    //    datepicker.datePickerColor = randomColor;//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor tintColor];//确定按钮的颜色
    [datepicker show];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.moduleInfo.value) {
            [_selectButton setTitle:self.moduleInfo.value forState:UIControlStateNormal];
        } else {
            [_selectButton setTitle:@"点击选择" forState:UIControlStateNormal];
        }
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _selectButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 0,SCREEN_WIDTH - CGRectGetWidth(self.label.frame) - 53 , 44.f);
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (NSString *)buildTimeType{
    NSString *type;
    if ([self.moduleInfo.type isEqualToString:@"ALL"]) {
        type = @"yyyy-MM-dd HH:mm:ss";
        return type;
    }else if ([self.moduleInfo.type isEqualToString:@"YEAR_MONTH_DAY"]){
        type = @"yyyy-MM-dd";
        return type;

    }else if ([self.moduleInfo.type isEqualToString:@"HOURS_MINS"]){
        type = @"HH:mm";
        return type;

    }else if ([self.moduleInfo.type isEqualToString:@"HOURS"]){
        type = @"HH";
        return type;
        
    }else if ([self.moduleInfo.type isEqualToString:@"MONTH_DAY_HOUR_MIN"]){
        type = @"MM-dd HH:mm";
        return type;

    }else if ([self.moduleInfo.type isEqualToString:@"YEAR_MONTH_DAY_HOUR_MINS"]){
        type = @"yyyy-MM-dd HH:mm";
        return type;
        
    }else{
        type = @"yyyy-MM-dd";
        return type;
    }
}
- (WSDateStyle)datePickerType{
    if ([self.moduleInfo.type isEqualToString:@"ALL"]) {
        return DateStyleShowYearMonthDayHourMinute;
    }else if ([self.moduleInfo.type isEqualToString:@"YEAR_MONTH_DAY"]){
        return DateStyleShowYearMonthDay;
    }else if ([self.moduleInfo.type isEqualToString:@"HOURS_MINS"]){
        return DateStyleShowHourMinute;
    }else if ([self.moduleInfo.type isEqualToString:@"HOURS"]){
        return DateStyleShowHour;
    }else if ([self.moduleInfo.type isEqualToString:@"MONTH_DAY_HOUR_MIN"]){
        return DateStyleShowMonthDayHourMinute;
    }else if ([self.moduleInfo.type isEqualToString:@"YEAR_MONTH_DAY_HOUR_MINS"]){
        return DateStyleShowYearMonthDayHourMinute;
    }else{
        return DateStyleShowYearMonthDayHourMinute;
    }
}

@end
