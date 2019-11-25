//
//  THSelectGendarCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/17.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "THSelectGendarCell.h"

@implementation THSelectGendarCell
- (void)creatUI
{
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 44.f;
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
    NSArray *array = @[@"男",@"女"];
    [[ActionSelect shareAction] dateActionShowInController:self.moduleInfo.controller selectArray:array CanSelectLast:YES complete:^(NSString *selectString) {
        __strong typeof(wself)sself = wself;
        [sself.selectButton setTitle:selectString forState:UIControlStateNormal];
        sself.moduleInfo.value = selectString;
    }];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.moduleInfo.value) {
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
