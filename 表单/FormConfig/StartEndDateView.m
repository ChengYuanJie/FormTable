//
//  StartEndDateView.m
//  THStandardEdition
//
//  Created by Aaron on 2016/11/28.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "StartEndDateView.h"

@implementation StartEndDateView

- (void)creatUI
{
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 50.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
}
- (void)layoutSubviews{
    [super layoutSubviews];
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
    __weak typeof(self)wself = self;
    
    [[ActionDate shareActionDate] dateActionShowInController:self.moduleInfo.controller DateFormatter:@"yyyy-MM-dd" DatePickerMode:UIDatePickerModeDate CanSelectLastDate:YES complete:^(NSString *dateString) {
        __strong typeof(wself)sself = wself;
        [sself.selectButton setTitle:dateString forState:UIControlStateNormal];
        sself.moduleInfo.value = dateString;
    }];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.moduleInfo.value) {
            [_selectButton setTitle:self.moduleInfo.value forState:UIControlStateNormal];
        }
        [_selectButton setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 0,SCREEN_WIDTH - CGRectGetWidth(self.label.frame) - 5 , 44.f);
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

@end
