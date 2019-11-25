//
//  TextButtonRow.m
//  THStandardEdition
//
//  Created by Aaron on 2018/7/23.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "TextButtonRow.h"
#import "UILabel+LabelHeightAndWidth.h"
@interface TextButtonRow()
@property (nonatomic, strong) UILabel *textlab;
@end
@implementation TextButtonRow

- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 75*SCREEN_WIDTH_6, 20)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    label.textColor = HUI_TEXT_COLOR;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = self.moduleInfo.label;
    [self.contentView addSubview:label];
    self.textlab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 15, SCREEN_WIDTH - 215*SCREEN_WIDTH_6, 20)];
    self.textlab.numberOfLines = 0;
    self.textlab.text = self.moduleInfo.value;
    self.textlab.font = Fount14;
    [self.contentView addSubview:self.textlab];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnW = [UILabel getWidthWithTitle:self.moduleInfo.hint font:Fount14];
    [btn setTitle:self.moduleInfo.hint forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_WIDTH - 15-btnW - 20, 10, btnW + 20, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 15;
    btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    btn.layer.borderColor = HUI_COLOR.CGColor;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rowH = 50;
    [self.contentView addSubview:self.textlab];
    [self.contentView addSubview:btn];
}
- (void)buttonClick:(UIButton *)sender{
    if (self.moduleInfo.btnBlock) {
        self.moduleInfo.btnBlock(nil);
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *text = valueDic[self.moduleInfo.key];
        self.textlab.text = text;
        self.moduleInfo.value = text;
    }
}
@end
