//
//  THSearchCell.m
//  director
//
//  Created by Aaron on 16/8/3.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "SelectUser.h"
#import "Database.h"
#import "THChooseUserViewController.h"
#import "IMUser.h"
@interface SelectUser()
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) FormLabel *label;
@property (nonatomic, strong) UIButton *selectButton;
@end
@implementation SelectUser
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
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]){
        self.moduleInfo.value = valueDic[self.moduleInfo.key];
    }
}
// 本地根据guid获取数据
- (void)refreshData:(NSString *)guid
{
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@ order by name desc",self.moduleInfo.tableName];
    NSArray *dataArray = [[Database shareDB] queryDataFromDBWithSqlString:selectStr];
    for (NSDictionary *dic in dataArray){
        if ([dic[@"guid"] isEqualToString:guid]) {
            [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
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
    
    THChooseUserViewController *serVC = [[THChooseUserViewController alloc ]initWithChooseUsersHandle:^(id object) {
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (![object isKindOfClass:[NSArray class]]) {
            IMUser *user = object;
            [_selectButton setTitle:user.name forState:UIControlStateNormal];
            if ([self.moduleInfo.sqlValue isEqualToString:@"guid"]) {
                wself.moduleInfo.value = user.guid;
            }else{
                wself.moduleInfo.value = user.name;
            }
        }else{
            NSArray *ary = object;
            NSMutableArray *nameAry = @[].mutableCopy;
            for (IMUser *user in ary) {
                [nameAry addObject:user.name];
            }
            NSString *nameStr = [nameAry componentsJoinedByString:@","];
            [_selectButton setTitle:nameStr forState:UIControlStateNormal];
            wself.moduleInfo.value = nameStr;
        }
    }];
    serVC.isMuilt = self.moduleInfo.isCanChoose;
    serVC.selectValue = [self.moduleInfo.value componentsSeparatedByString:@","];
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
}
@end
