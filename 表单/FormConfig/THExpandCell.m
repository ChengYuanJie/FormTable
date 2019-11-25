//
//  THExpandCell.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/15.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "THExpandCell.h"

@implementation THExpandCell

- (void)creatUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
  _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    _valueLabel.font = [UIFont systemFontOfSize:17.f];
    _valueLabel.text = self.moduleInfo.hint;
    [self.contentView addSubview:_valueLabel];
    if (!self.moduleInfo.dataSource) {
        NSArray *array = @[@"男",@"女"];
        [self.dataList addObjectsFromArray:array];
    } else {
        [self.dataList addObjectsFromArray:self.moduleInfo.dataSource];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.frame;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rowH = 44;
    [self.contentView addSubview:button];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _valueLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5 , 0,200 , self.frame.size.height);
    _valueLabel.text = self.moduleInfo.value;
    self.starValue = _valueLabel.text;
    
}
#pragma mark--buttonAction
- (void)buttonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0,KScreenH - 200 , KScreenW, 200)  ;
    } completion:nil];
    self.valueLabel.text = self.dataList[0];
    self.moduleInfo.value =  self.valueLabel.text;
}

- (void)certainButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, KScreenH, KScreenW, 200);
    } completion:nil];
    if ([self.valueLabel.text isEqualToString:self.starValue]) {
        self.moduleInfo.value = @"";
    }else{
        self.moduleInfo.value = self.valueLabel.text;
        
    }
}

- (void)cancleButtonAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:changMB object:nil];
    self.valueLabel.text = @"请选择性别";
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, KScreenH, KScreenW, 200);
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
