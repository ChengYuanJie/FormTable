//
//  THSearchCell.m
//  director
//
//  Created by Aaron on 16/8/3.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "THSelectView.h"
#import "Database.h"
@implementation THSelectView
- (void)creatUI{
    if (!self.moduleInfo.alignmentRight) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, 50) title:self.moduleInfo.label];
    
    [self.contentView addSubview:self.label];
    self.rowH = 50.f;
    [self.contentView addSubview:self.selectButton];
    if (self.moduleInfo.btnShowValue) {
        [self.selectButton setTitle:self.moduleInfo.btnShowValue forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
//设置下拉框默认值,默认为上次选中的值
- (void)setDefaultValue{
    NSDictionary *dic = [STANDARD_USER_DEFAULT objectForKey:[NSString stringWithFormat:@"%@%@",self.moduleInfo.formName,self.moduleInfo.key]];
    NSLog(@"%@",dic[self.moduleInfo.sql]);
    if (dic) {
        [self.selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        self.moduleInfo.value = dic[self.moduleInfo.sqlValue];
        [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *guid = valueDic[self.moduleInfo.key];
        //实时获取
        if (self.moduleInfo.tableName){
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
    NSString *selectStr = [NSString stringWithFormat:@"select * from %@ order by name desc",self.moduleInfo.tableName];
    if (self.moduleInfo.sqlWhere.length > 0) {
        selectStr = [NSString stringWithFormat:@"select * from %@ where %@  order by name asc",self.moduleInfo.tableName,self.moduleInfo.sqlWhere];
    }
    NSArray *dataArray = [[Database shareDB] queryDataFromDBWithSqlString:selectStr];
    for (NSDictionary *dic in dataArray) {
        if ([dic[self.moduleInfo.sqlValue] isEqualToString:guid]) {
            self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
            [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
            [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
// 从草稿箱进入时 保存的数据,从后台实时获取数据
- (void)getDataWithText:(NSString *)guid{
    __weak typeof (self)wself = self;
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.key = self.moduleInfo.tableName;
    [UpdateService queryDataWithKey:model success:^(id object) {
        [SVProgressHUD dismiss];
        NSString *code = object[@"code"];
        if (code.integerValue == 0) {
            NSArray *array = object[@"message"];
            for (NSDictionary *dic in array) {
                if ([dic[@"id"] isEqualToString:guid]) {
                    wself.valueLabel.text = dic[self.moduleInfo.sql];
                    
                }
            }
        }
        
    } failure:^(id error) {
        
        
    } unconnection:^(id error) {
        
        
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _valueLabel.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5,0 , 200, self.frame.size.height);
    if (self.moduleInfo.btnShowValue) {
        [self.selectButton setTitle:self.moduleInfo.btnShowValue forState:UIControlStateNormal];
        [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
- (void)buttonAction:(UIButton *)sender
{
    //判断事件是否
    if (self.moduleInfo.exctuedBlock){
        self.moduleInfo.exctuedBlock();
        return;
    }
    FormSearchViewController *serVC = [[FormSearchViewController alloc] init];
    UIViewController *vc = [AppDelegate shareAppDelegate].pushNavController.visibleViewController;
    serVC.modouleInfo = self.moduleInfo;
    __weak typeof (self)wself = self;
    serVC.returnValues = ^(id obj){
        NSDictionary *dic = obj;
        self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
        [_selectButton setTitle:dic[self.moduleInfo.sql] forState:UIControlStateNormal];
        wself.moduleInfo.value = dic[self.moduleInfo.sqlValue?self.moduleInfo.sqlValue:@"guid"];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (self.moduleInfo.useDefault) {
            [STANDARD_USER_DEFAULT setObject:dic forKey:[NSString stringWithFormat:@"%@%@",self.moduleInfo.formName,self.moduleInfo.key]];
            [STANDARD_USER_DEFAULT synchronize];
        }
        if (self.moduleInfo.extentionStr && self.moduleInfo.exBlock) {
            self.moduleInfo.exBlock(dic[self.moduleInfo.extentionStr]);
        }
        if (self.moduleInfo.btnBlock) {
            self.moduleInfo.btnBlock(dic);
        }
    };
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
        _selectButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame)+5 , 0,SCREEN_WIDTH-CGRectGetMaxX(self.label.frame)-35, self.rowH);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
@end
