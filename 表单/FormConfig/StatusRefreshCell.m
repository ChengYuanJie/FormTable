//
//  StatusRefreshCell.m
//  THStandardEdition
//
//  Created by Noah on 2019/8/8.
//  Copyright © 2019 程元杰. All rights reserved.
//

#import "StatusRefreshCell.h"
#import "UILabel+LabelHeightAndWidth.h"

@implementation StatusRefreshCell

- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 50.f)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    if (self.moduleInfo.alignmentRight) {
        label.textAlignment = NSTextAlignmentRight;
    }
    label.textColor = self.moduleInfo.labColor?self.moduleInfo.labColor:HUI_TEXT_COLOR;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    self.titlelab = label;
    [self.contentView addSubview:label];
    CGFloat cellH = [UILabel getHeightByWidth:SCREEN_WIDTH - 115*SCREEN_WIDTH_6 title:self.moduleInfo.btnShowValue font:Fount14];
    self.textlab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+ 10, 15, SCREEN_WIDTH - 100-50, MAX(20, cellH))];
    self.textlab.numberOfLines = 0;
    NSString *valueStr = [NSString stringWithFormat:@"%@",self.moduleInfo.btnShowValue];
    if (![self.moduleInfo.btnShowValue isKindOfClass:[NSNull class]] && ![valueStr isEqualToString:@"(null)"]) {
        self.textlab.text = valueStr;
    }
    self.textlab.textColor = [UIColor colorWithHEXRGB:0x87d74f];
    self.textlab.font = Fount14;
    
    [self.contentView addSubview:self.textlab];
    
    
    [self.contentView addSubview:self.refreshButton];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(36);
        make.width.width.mas_equalTo(36);
        make.right.equalTo(self).offset(-10);
    }];
    
    self.rowH = MAX(50.f, cellH + 30);
    [self buttonAction:self.refreshButton];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titlelab.text = self.moduleInfo.label;
    CGFloat cellH = [UILabel getHeightByWidth:SCREEN_WIDTH - 115*SCREEN_WIDTH_6 title:self.moduleInfo.btnShowValue font:Fount14];
    NSString *valueStr = [NSString stringWithFormat:@"%@",self.moduleInfo.btnShowValue];
    if (![self.moduleInfo.btnShowValue isKindOfClass:[NSNull class]] && ![valueStr isEqualToString:@"(null)"]) {
        self.textlab.text = valueStr;
    }
    self.rowH = MAX(50.f, cellH + 30);
    self.textlab.frame = CGRectMake(75+ 25, 15, SCREEN_WIDTH - 100-50, MAX(20, cellH));
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *text = valueDic[self.moduleInfo.key];
        self.textlab.text = [NSString stringWithFormat:@"%@",text];
        self.moduleInfo.btnShowValue = text;
    }
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"刷新1"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}
// button旋转
- (void)startAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.duration = 2;
    animation.toValue =[NSNumber numberWithFloat: M_PI * 2.0 ];
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 500;
    [self.refreshButton.layer addAnimation:animation forKey:nil];
}

- (void)buttonAction:(UIButton *)btn {
    [self startAnimation];
    
    THNetServiceModel *netModel = [[THNetServiceModel alloc] init];
    netModel.customBaseUrl = [NSString stringWithFormat:@"%@/order-service/v1/order/query?tenant_id=%@&emp_guid=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,[STANDARD_USER_DEFAULT objectForKey:KEY_TENANT_ID],[STANDARD_USER_DEFAULT objectForKey:KEY_USERGUID]];
    netModel.subDic = @{
                        @"key":self.moduleInfo.qurayType,
                        @"condition":@[@{
                                           @"code":@"guid",
                                           @"op":@"=",
                                           @"value":self.value?:@""
                                           }]
                        };
    [MBProgressHUD show];
    [UpdateService requestWith:netModel httpType:HttpTypePost success:^(id object) {
        NSString *cus_confirm =[NSString stringWithFormat:@"%@",[object[@"message"][@"records"] firstObject][@"cus_confirm"]];
        self.textlab.text = [cus_confirm integerValue]?@"客户已确认":@"客户未确认";
        self.moduleInfo.btnShowValue = [cus_confirm integerValue]?@"客户已确认":@"客户未确认";
        [self.refreshButton.layer removeAllAnimations];
        [MBProgressHUD hideHUD];
    } failure:^(id error) {
        self.moduleInfo.btnShowValue = @"客户未确认";
        self.textlab.text = @"客户未确认";
        [self.refreshButton.layer removeAllAnimations];
        [MBProgressHUD hideHUD];
    } unconnection:^(id error) {
        self.moduleInfo.btnShowValue = @"客户未确认";
        self.textlab.text = @"客户未确认";
        [self.refreshButton.layer removeAllAnimations];
        [MBProgressHUD showError:MESSAGE_NoNetwork];
    }];
}

@end
