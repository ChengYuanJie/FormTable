


//
//  THLabelCell.m
//  director
//
//  Created by Aaron on 16/7/25.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "TextView.h"

@implementation TextView
- (void)creatUI{
    
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.label.frame)+5 , 0,SCREEN_WIDTH-CGRectGetMaxX(self.label.frame)-35, 50)];
    [self.contentView addSubview:self.valueLabel];
     _valueLabel.textAlignment = NSTextAlignmentRight;
    _valueLabel.font = [UIFont systemFontOfSize:14.f];
    self.rowH = 50;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _valueLabel.text = self.moduleInfo.value;
}

- (void)buttonAction:(UIButton *)sender
{
//    [self.moduleInfo.controller.navigationController popViewControllerAnimated:YES];
    self.chainModel.reciveKey = @"c";
    self.chainModel.postKey = self.moduleInfo.key;
    self.chainModel.value = self.moduleInfo.value;

    [self sendNotificationWithObject:self.chainModel userInfo:nil];
}
@end
