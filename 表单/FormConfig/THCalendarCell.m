//
//  THCalendarCell.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/15.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "THCalendarCell.h"

@implementation THCalendarCell
- (void)creatUI{
    ANLog(@"%@",self.moduleInfo.label);
    
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];

    [self.contentView addSubview:self.valueLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.frame;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    self.moduleInfo.value = [DateUtil getDateFormatStringWithType:@"yyyy-MM-dd"];
    [_pickView becomeFirstResponder];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.valueLabel.text = self.moduleInfo.value;
    self.value = self.valueLabel.text;
}
#pragma mark--buttonAction
- (void)buttonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, 0, KScreenH - 200, 200) ;
    } completion:nil];
}

- (void)certainButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, 0, KScreenH, 200) ;
    } completion:nil];
}

- (void)cancleButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    self.valueLabel.text = [NSDate today];
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, 0, KScreenH , 200) ;
    } completion:nil];
    self.moduleInfo.value = [NSDate today];
    self.value = self.moduleInfo.value;

}

-(void)yearMonthDayDatePicker:(GQYearMonthDayDatePicker *)yearMonthDatePicker didSectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    //[formatter setDateFormat:@"M月"];
    self.valueLabel.text = [self Formatter:date];
    self.moduleInfo.value = self.valueLabel.text;
    self.value = self.moduleInfo.value;
    ANLog(@"视图控制器中 %@", [self Formatter:date]);
}

//日期转化为字符串
- (NSString *)Formatter:(NSDate *)data {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:data];
}

#pragma mark -- lazy
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,KScreenH, KScreenW, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:self.cancleButton];
        [_bgView addSubview:self.certainButton];
        [_bgView addSubview:self.pickView];
    }
    return _bgView;
}
- (UIButton *)certainButton
{
    if (!_certainButton) {
        _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certainButton setTitle:@"确定" forState:UIControlStateNormal];
        _certainButton.frame = CGRectMake(KScreenW - 50, 10/667.f*KScreenH, 40, 20);
        [_certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_certainButton addTarget:self action:@selector(certainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certainButton;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleButton.frame = CGRectMake(10/375.f*KScreenW, 10/667.f*KScreenH, 40, 20);
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame) , 0,200 , self.frame.size.height)];
        NSString *str = [NSDate today];
        _valueLabel.text = str;
        //        _valueLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _valueLabel;
}
- (UIPickerView *)pickView
{
    if (!_pickView ) {
        _pickView = [[GQYearMonthDayDatePicker alloc]initWithFrame:CGRectMake(0, 40/667.f*KScreenH, KScreenW, 200 - 40/667.f*KScreenH)];
        _pickView.gqdelegate = self;
        _pickView.rowHeight = 40;
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.showsSelectionIndicator = YES;
    }
    return _pickView;
}
- (void)removePickViewFromWindou:(NSNotification *)info
{
    [self.bgView  removeFromSuperview];

}

@end
