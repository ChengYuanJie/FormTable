//
//  SwitchCell.m
//  THStandardEdition
//
//  Created by Aaron on 2018/8/27.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "SwitchCell.h"
@interface SwitchCell()
@end
@implementation SwitchCell

- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    [label sizeToFit];
    label.text = self.moduleInfo.label;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:label];
    self.rowH = 50;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"否"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"是"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-65);
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.right.mas_equalTo(self.right).offset(-15);
    }];
    if (!self.moduleInfo.value){
        self.moduleInfo.value = @"0";
    }else{
        [btn setImage:[UIImage imageNamed:self.moduleInfo.value] forState:UIControlStateNormal];
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *text = valueDic[self.moduleInfo.key];
        self.moduleInfo.value = text;
    }
}
- (void)switchButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.moduleInfo.value = sender.selected?@"1":@"0";
}
@end
