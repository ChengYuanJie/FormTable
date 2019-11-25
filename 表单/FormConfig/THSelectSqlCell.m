//
//  THSelectSqlCell.m
//  director
//
//  Created by Aaron on 16/7/25.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "THSelectSqlCell.h"

@implementation THSelectSqlCell

- (void)creatUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"%@",self.moduleInfo.key);
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_valueLabel];
    NSString *plistPath = [[NSBundle mainBundle]  pathForResource:@"Address" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray* arr = [data allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    [self.dataList addObjectsFromArray:arr];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.frame;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _valueLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5 , 0,200 , self.frame.size.height);
    _valueLabel.text = self.moduleInfo.hint;
    self.starValue = _valueLabel.text;
}
#pragma mark--buttonAction
- (void)buttonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
//        self.bgView.top = KScreenH - 200;
    } completion:nil];
    self.valueLabel.text = self.dataList[0];
    self.moduleInfo.value =  self.valueLabel.text;
}

- (void)certainButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
//        self.bgView.top = KScreenH;
    } completion:nil];
    if ([self.valueLabel.text isEqualToString:self.starValue]) {
        self.moduleInfo.value = @"";
    }else{
        self.moduleInfo.value = self.valueLabel.text;
    }
    
    self.chainModel.reciveKey = @"c";
    self.chainModel.postKey = self.moduleInfo.key;
    self.chainModel.value = self.moduleInfo.value;
    [self sendNotificationWithObject:self.chainModel userInfo:nil];
}

- (void)cancleButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    self.valueLabel.text = @"请选择";
    [UIView animateWithDuration:.35 animations:^{
//        self.bgView.top = KScreenH;
    } completion:nil];
    self.moduleInfo.value = @"";
}
#pragma mark-- pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataList[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.valueLabel.text = self.dataList[row];
    self.moduleInfo.value = self.valueLabel.text;

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
- (UIPickerView *)pickView
{
    if (!_pickView ) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40/667.f*KScreenH, KScreenW, 200 - 40/667.f*KScreenH)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}
- (void)removePickViewFromWindou:(NSNotification *)info
{
    [self.bgView  removeFromSuperview];
    
}



@end
