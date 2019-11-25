//
//  THExpandCell.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/15.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "SelectView.h"
#import "BRPickerView.h"
#import "BRTextField.h"
@interface SelectView()
@property (nonatomic, strong) BRTextField *textField;
@property (nonatomic, strong) NSMutableArray *showTitles;
@end
@implementation SelectView
- (NSMutableArray *)showTitles{
    if (!_showTitles) {
        _showTitles = @[].mutableCopy;
    }
    return _showTitles;
}
- (void)creatUI{
    if (!self.moduleInfo.alignmentRight) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 230, 0, 200, 50)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = [UIColor textColor];
    [self.contentView addSubview:textField];
    self.textField = textField;
    NSMutableDictionary *sqlDict = @{}.mutableCopy;
    if (self.moduleInfo.sqlValue) {
        for (NSDictionary *dic in self.moduleInfo.dataSource) {
            [self.showTitles addObject:dic[self.moduleInfo.sql]];
            [sqlDict setObject:dic[self.moduleInfo.sqlValue] forKey:dic[self.moduleInfo.sql]];
        }
    }
   textField.placeholder = @"请选择";
    __weak typeof(self) weakSelf = self;
    textField.tapAcitonBlock = ^{
        [BRStringPickerView showStringPickerWithTitle:weakSelf.moduleInfo.label dataSource:self.showTitles.count>0?self.showTitles:weakSelf.moduleInfo.dataSource defaultSelValue:self.showTitles.count>0?self.showTitles.firstObject:weakSelf.moduleInfo.dataSource.firstObject isAutoSelect:YES resultBlock:^(id selectValue) {
            if (weakSelf.showTitles.count > 0) {
                weakSelf.textField.text = selectValue;
                weakSelf.moduleInfo.btnShowValue = selectValue;
                weakSelf.moduleInfo.value = sqlDict[selectValue];
            }else{
                weakSelf.textField.text = selectValue;
                weakSelf.moduleInfo.btnShowValue = selectValue;
                weakSelf.moduleInfo.value = selectValue;
            }
            //抛出所选值
            if (weakSelf.moduleInfo.exBlock) {
                if ([weakSelf.moduleInfo.dataSource.firstObject isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *dic in weakSelf.moduleInfo.dataSource) {
                        if ([dic[weakSelf.moduleInfo.sql] isEqualToString:selectValue]) {
                            weakSelf.moduleInfo.exBlock(dic);
                            break;
                        }
                    }
                }else{
                    weakSelf.moduleInfo.exBlock(selectValue);
                }
            }
        }];
    };
    self.rowH = 50;
    if (self.moduleInfo.value){
        if (self.showTitles.count > 0) {
            for (NSDictionary *dic in self.moduleInfo.dataSource) {
                if ([dic[self.moduleInfo.sqlValue] isEqualToString:self.moduleInfo.value]) {
                    self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
                    self.textField.text = dic[self.moduleInfo.sql];
                }
            }
        }else{
            self.moduleInfo.btnShowValue = self.moduleInfo.value;
            self.textField.text = self.moduleInfo.value;
        }
    }else{
        if (self.moduleInfo.useDefault) {
            if (self.moduleInfo.sqlValue) {
                NSDictionary *dic = self.moduleInfo.dataSource.firstObject;
                self.textField.text = dic[self.moduleInfo.sql];
                self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
                self.moduleInfo.value = dic[self.moduleInfo.sqlValue];
            }else{
                self.textField.text = self.moduleInfo.dataSource.firstObject;
                self.moduleInfo.btnShowValue = self.moduleInfo.dataSource.firstObject;
                self.moduleInfo.value = self.moduleInfo.dataSource.firstObject;
            }
        }
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.showTitles.count > 0) {
        for (NSDictionary *dic in self.moduleInfo.dataSource) {
            if ([dic[self.moduleInfo.sqlValue] isEqualToString:self.moduleInfo.value]) {
                self.textField.text = dic[self.moduleInfo.sql];
                self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
            }
        }
    }else{
        self.textField.text = self.moduleInfo.value;
        self.moduleInfo.btnShowValue = self.moduleInfo.value;
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *value = valueDic[self.moduleInfo.key];
        id object = self.moduleInfo.dataSource.firstObject;
        if ([object isKindOfClass:[NSDictionary class]]) {
            for (NSDictionary *dic in self.moduleInfo.dataSource) {
                if ([dic[self.moduleInfo.sqlValue] isEqualToString:self.moduleInfo.value]) {
                    self.textField.text = dic[self.moduleInfo.sql];
                    self.moduleInfo.btnShowValue = dic[self.moduleInfo.sql];
                    self.moduleInfo.value = value;
                }
            }
        }else{
            self.textField.text  = value;
            self.moduleInfo.btnShowValue = value;
            self.moduleInfo.value = value;
        }
    }
}



@end
