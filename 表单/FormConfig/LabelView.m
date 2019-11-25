//
//  LabelView.m
//  THStandardEdition
//
//  Created by Aaron on 2018/7/23.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "LabelView.h"
#import "UILabel+LabelHeightAndWidth.h"
@interface LabelView()
@end
@implementation LabelView

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75*SCREEN_WIDTH_6, 50.f)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    if (self.moduleInfo.alignmentRight) {
        label.textAlignment = NSTextAlignmentRight;
    }
    label.textColor = self.moduleInfo.labColor?self.moduleInfo.labColor:HUI_TEXT_COLOR;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    self.titlelab = label;
    [self.contentView addSubview:label];
    CGFloat cellH = [UILabel getHeightByWidth:SCREEN_WIDTH - 115*SCREEN_WIDTH_6 title:self.moduleInfo.value font:Fount14];
    self.textlab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 15, SCREEN_WIDTH - 100*SCREEN_WIDTH_6, MAX(20, cellH))];
    self.textlab.numberOfLines = 0;
    NSString *valueStr = [NSString stringWithFormat:@"%@",self.moduleInfo.value];
    if (![self.moduleInfo.value isKindOfClass:[NSNull class]] && ![valueStr isEqualToString:@"(null)"]) {
        self.textlab.text = valueStr;
    }
    self.textlab.font = Fount14;
    self.textlab.textColor = self.moduleInfo.valueColor?self.moduleInfo.valueColor:[UIColor blackColor];

    [self.contentView addSubview:self.textlab];
    self.rowH = MAX(50.f, cellH + 30);
    [self.contentView addSubview:self.textlab];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titlelab.text = self.moduleInfo.label;
    CGFloat cellH = [UILabel getHeightByWidth:SCREEN_WIDTH - 115*SCREEN_WIDTH_6 title:self.moduleInfo.value font:Fount14];
    NSString *valueStr = [NSString stringWithFormat:@"%@",self.moduleInfo.value];
    if (![self.moduleInfo.value isKindOfClass:[NSNull class]] && ![valueStr isEqualToString:@"(null)"]) {
        self.textlab.text = valueStr;
    }
    self.rowH = MAX(50.f, cellH + 30);
    self.textlab.frame = CGRectMake(75*SCREEN_WIDTH_6+ 20, 15, SCREEN_WIDTH - 100*SCREEN_WIDTH_6, MAX(20, cellH));
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *text = valueDic[self.moduleInfo.key];
        self.textlab.text = [NSString stringWithFormat:@"%@",text];
        self.moduleInfo.value = text;
    }
}
@end
