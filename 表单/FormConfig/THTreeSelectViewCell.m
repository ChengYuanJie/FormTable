

//
//  THTreeSelectViewCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/1.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "THTreeSelectViewCell.h"
#import "TreeSelectViewController.h"
#import "Database.h"
@interface THTreeSelectViewCell()<UIViewControllerDismissed>
@end
@implementation THTreeSelectViewCell
- (void)creatUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 44.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *guid = valueDic[self.moduleInfo.key];
        //实时获取
        if (self.moduleInfo.tableName) {
            [self refreshData:guid];
        }else{
            [self getDataWithText:guid];
        }
        //数据库获取
        //set值获取
        self.moduleInfo.value =  guid;
    }
}
// 本地根据guid获取数据
- (void)refreshData:(NSString *)guid
{
    NSArray *dataArray = [[Database shareDB] queryDataWithTableName:self.moduleInfo.tableName];
    for (NSDictionary *dic in dataArray) {
        if ([dic[@"guid"] isEqualToString:guid]) {
            [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        }
    }
}


// 从草稿箱进入时 保存的数据,从后台实时获取数据
- (void)getDataWithText:(NSString *)guid{
    
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.key = self.moduleInfo.tableName;
    [UpdateService queryDataWithKey:model success:^(id object) {
        [SVProgressHUD dismiss];
        NSString *code = object[@"code"];
        if (code.integerValue == 0) {
            NSArray *array = object[@"message"];
            for (NSDictionary *dic in array) {
                if ([dic[@"id"] isEqualToString:guid]) {
                    
                }
            }
        }
        
    } failure:^(id error) {
        
        
    } unconnection:^(id error) {
        
    }];
}
- (void)buttonAction:(UIButton *)sender
{
    // 获取数据源，赋值给TreeController
    TreeSelectViewController *treeController = [[TreeSelectViewController alloc]init];
    treeController.delegate = self;
    treeController.tableName = self.moduleInfo.tableName;
    UIViewController *vc = [AppDelegate shareAppDelegate].pushNavController.visibleViewController;
    [vc.navigationController pushViewController:treeController animated:YES];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 0,SCREEN_WIDTH - CGRectGetWidth(self.label.frame) - 5 , 44.f);
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (void)UIViewControllerDidDisappear:(UIViewController *)controller andMessageObject:(id)message
{
    NSDictionary *dic = message;
    [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
    self.moduleInfo.value = dic[@"guid"];

    
}
@end
