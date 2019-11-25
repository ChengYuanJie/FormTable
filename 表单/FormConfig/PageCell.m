//
//  PageCell.m
//  THStandardEdition
//
//  Created by Aaron on 2018/9/10.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "PageCell.h"

#import "SelectUser.h"
#import "Database.h"
#import "FormPageVC.h"
#import "IMUser.h"
@interface PageCell()
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) FormLabel *label;
@property (nonatomic, strong) UIButton *selectButton;
@end
@implementation PageCell
- (void)creatUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
    self.rowH = 50.f;
    [self.contentView addSubview:self.selectButton];
    if (self.moduleInfo.btnShowValue) {
        [self.selectButton setTitle:self.moduleInfo.btnShowValue forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        self.moduleInfo.value = valueDic[self.moduleInfo.key];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _valueLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5,0 , 200, self.frame.size.height);
}
- (void)buttonAction:(UIButton *)sender
{
    __weak typeof (self)wself = self;
    FormPageVC *serVC = [[FormPageVC alloc] init];
    serVC.block = ^(NSDictionary *dic) {
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        wself.moduleInfo.value = dic[self.moduleInfo.sqlValue];
    };
    serVC.module = self.moduleInfo;
    UIViewController *vc = [AppDelegate shareAppDelegate].pushNavController.visibleViewController;
    [vc.navigationController pushViewController:serVC animated:YES];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.moduleInfo.value) {
            [_selectButton setTitle:self.moduleInfo.value forState:UIControlStateNormal];
        }
        [_selectButton setTitle:self.moduleInfo.hint?self.moduleInfo.hint:@"点击选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor colorWithHEXRGB:0xc2c2c2] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(100*SCREEN_WIDTH_6 , 0,SCREEN_WIDTH-150*SCREEN_WIDTH_6, self.rowH);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}@end
