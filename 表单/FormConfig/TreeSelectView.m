

//
//  THTreeSelectViewCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/1.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "TreeSelectView.h"
#import "NewTreeSelectController.h"
#import "Database.h"
@interface TreeSelectView()
@end
@implementation TreeSelectView
- (void)creatUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 50.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
}
//设置下拉框默认值,默认为上次选中的值
- (void)setDefaultValue{
    NSDictionary *dic = [STANDARD_USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%@%@",self.moduleInfo.formName,self.moduleInfo.key]];
    if (dic) {
        [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        self.moduleInfo.value = dic[@"guid"];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
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
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
                if ([dic[@"guid"] isEqualToString:guid]) {
                    
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
    NewTreeSelectController *treeController = [[NewTreeSelectController alloc]init];
    __weak typeof(self) wself = self;
    treeController.block = ^(NSDictionary *dic){
        [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        wself.moduleInfo.value = dic[@"guid"];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (self.moduleInfo.useDefault) {
            [STANDARD_USER_DEFAULT setObject:dic forKey:[NSString stringWithFormat:@"%@%@",self.moduleInfo.formName,self.moduleInfo.key]];
            [STANDARD_USER_DEFAULT synchronize];
        }
    };
    treeController.model = self.moduleInfo;
    UIViewController *vc = [AppDelegate shareAppDelegate].pushNavController.visibleViewController;
    
    [vc.navigationController pushViewController:treeController animated:YES];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"点击选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor colorWithHEXRGB:0xc2c2c2] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(0 , 0,SCREEN_WIDTH-30, self.rowH);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
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
