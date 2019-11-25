//
//  FormInfo.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormInfo.h"
#import "CustomTableView.h"
#import "FormBaseTableViewCell.h"
#import "UpdateService.h"
@interface FormInfo()<FromValueHandelProtocol>
@property (nonatomic, strong) CustomTableView *tableView;

@end

@implementation FormInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rowDic = [[NSMutableDictionary alloc] init];
        self.customKeyAry = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vlueChangeWithKey:) name:PostValue object:nil];
    }
    return self;
}
-(void)setIsClone:(BOOL)isClone{
    _isClone = isClone;
}
- (void)addSection:(FormSectionDescriptor *)section
{
    [self.sectionArray addObject:section];
    //把cell存入字典
    for (ModuleRowInfo *rowDes in section.moduleArray) {
        [self.rowDic setObject:rowDes forKey:rowDes.key];
    }

}
- (NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}
- (void)setRowValueWithRowKey:(NSString *)key value:(id)value
{
    
    static  NSString *valueStr = nil;
    if (![value isKindOfClass:[NSString class]]) {
        valueStr = [NSString stringWithFormat:@"%@",value];
    }else{
        valueStr = value;
    }
    NSArray *keyArray = [self.rowDic allKeys];
    if (![keyArray containsObject:key]) {
        ANLog(@"传入的key值有误，未找到对应的cell");
        return;
    }
    if (key) {
        ModuleRowInfo *moduleInfo = self.rowDic[key];
        moduleInfo.value = valueStr;
    }
    
}
- (NSArray *)getValuesRequired:(BOOL)isRequired
{
    if (isRequired) {
        if (![self validatorValue]) {
            return nil;
        }
    }
    __block BOOL isEmpty = YES;
    
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    for (FormSectionDescriptor *section in self.sectionArray) {
        NSMutableDictionary * secResult = [NSMutableDictionary dictionary];
        for (ModuleRowInfo *rowValues in section.moduleArray) {
            if (rowValues.key.length == 0) {
                ANLog(@"%@ 字段为空",rowValues.key);
            }
            if (rowValues.value == nil) {
                rowValues.value = @"";
            }
            //判断当前cell是否被删除
            NSArray *keyArray = [self.rowDic allKeys];
            if (![keyArray containsObject:rowValues.key]) {
                continue;
            }
            if (rowValues.unSubmit) {
                continue;
            }
            //如果value为字典/数组时做特殊处理
            if([rowValues.value isKindOfClass:[NSDictionary class]] && !rowValues.noAssembleDictValue)
            {
                NSDictionary *dic = (NSDictionary *)rowValues.value;
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [secResult setObject:obj forKey:key];

                    if (![rowValues.viewType isEqualToString:@"LocateView"]) {
                        if ([obj isKindOfClass:[NSString class]]) {
                            NSString *str = obj;
                            if (str.length > 0) {
                                isEmpty = NO;
                            }
                        }
                    }
                    
            }];
                
            }else if ([rowValues.viewType isEqualToString:@"PhotoTaker"]){
                NSString *imgStr = [ImageCacheTools buildStringWithImageArray:rowValues.value];
                if (imgStr.length == 0  && rowValues.required) {
                    UIAlertViewQuick(@"提示",rowValues.emptyMsg, @"确定");
                    return nil;
                }
                [secResult setObject:imgStr != nil?imgStr:@"" forKey:rowValues.key];

                [secResult setObject:rowValues.key forKey:[NSString stringWithFormat:@"image_data_key_%@",rowValues.key]];

            }else{
                [secResult setObject:rowValues.value forKey:rowValues.key];

            }
            if (!isEmpty) {
                continue;
            }
            // 做表单非空判断
          
            if ([rowValues.value isKindOfClass:[NSArray class]]) {
                NSArray *array = rowValues.value;
                if (array.count > 0) {
                    isEmpty = NO;
                }
            }
            
            if ([rowValues.value isKindOfClass:[NSString class]] && ![rowValues.value isEqualToString:@""]) {
                isEmpty = NO;
            }
            
        }
        [valueArray addObject:secResult];
    }
    if (!isRequired && isEmpty) {
        UIAlertViewQuick(@"提示", @"空数据不能保存到草稿箱", @"确定");
    }
    if (isEmpty) {
        return nil;
    }else{
        NSMutableArray *valueModel = [[NSMutableArray alloc] initWithCapacity:valueArray.count];
        for (NSDictionary *dic in valueArray) {
            AbstractValueModel *model = [[AbstractValueModel alloc] initWithDic:dic];
            [valueModel addObject:model];
        }
            return valueModel;
    }
}
//提交数据组装
- (NSMutableDictionary *)geValuesStoreSQL
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    if (![self validatorValue]) {
        return result;
    }
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (ModuleRowInfo *rowValues in section.moduleArray) {
            if (rowValues.key.length == 0) {
                ANLog(@"%@ 字段为空",rowValues.key);
            }
            if (rowValues.value == nil) {
                rowValues.value = @"";
            }
            //判断当前cell是否被删除
//            NSArray *keyArray = [self.rowDic allKeys];
//            if (![keyArray containsObject:rowValues.key]) {
//                continue;
//            }
            if (rowValues.isStore) {
                [result setObject:rowValues.value forKey:rowValues.key];
            }
        }
    }
    return result;

}
- (void)removeCellWithKey:(NSString *)key
{
    if (!key) {
        return;
    }
    FormBaseTableViewCell *cell = nil;
    
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (FormBaseTableViewCell *cell1 in section.cellArray) {
            if ([cell1.moduleInfo.key isEqualToString:key]) {
                cell = cell1;
                break;
            }
        }
    }
    
}
- (void)setRowValues:(id)object
{
    if (!object) {
        return;
    }
    NSDictionary *dic = object;
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (FormBaseTableViewCell *cell in section.cellArray) {
            [cell readFormSetValueWithDic:dic];
        }
        for (ModuleRowInfo *module in section.moduleArray) {
            module.value = dic[module.key];
        }
    }
}
- (void)setModuleValues:(id)object{
    if (!object) {
        return;
    }
    NSDictionary *dic = object;
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (ModuleRowInfo *module in section.moduleArray) {
            if (module.unSubmit) {
                continue;
            }
            module.value = dic[module.key];
        }
    }
}
- (void)setValuesFromSevice:(id )object
{
    NSDictionary *dic = object;
    for (NSString *key in dic) {
        FormSectionDescriptor *sectionDes = [[FormSectionDescriptor alloc] init];
        NSArray *array = dic[key];
        for (NSDictionary *dic in array) {
            ModuleRowInfo *rowDes = [[ModuleRowInfo alloc] init];
            rowDes.key = dic[@"key"];
            rowDes.viewType = dic[@"configType"];
            rowDes.label = dic[@"labelTitle"];
            [sectionDes addFormRow:rowDes];
        }
        [self addSection:sectionDes];
    }
}
-(BOOL)doValidatorLocaType{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (ModuleRowInfo *model in section.moduleArray) {
            [array addObject:model.viewType];
        }
    }
    if ([array containsObject:@"LocateView"]) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)validatorValue
{
    for (FormSectionDescriptor *section in self.sectionArray) {
        for (ModuleRowInfo *model in section.moduleArray) {
         FormValidationStatus *status = [model doValidation];
            if (status != nil) {
                if (status.msg) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:      status.msg
                                         delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];

                    return NO;
                }else{
                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:
//                                                                   delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];

                }
                              break;
            }
        }
    }
    return YES;
}
- (void)vlueChangeWithKey:(NSNotification *)info
{
    //接受的postValue
    ValueChainModel *model = [[ValueChainModel alloc] init];
    model = info.object;
    ModuleRowInfo *moduleInfo = nil;
    if ([self.delegate respondsToSelector:@selector(handlePostValue:)]) {
        moduleInfo = [self.delegate handlePostValue:model];
    }
    if (moduleInfo == nil) {
        return;
    }
    for (FormSectionDescriptor *section in self.sectionArray)   {
        for (FormBaseTableViewCell *cell in section.cellArray) {
            if ([cell.moduleInfo.key isEqualToString:moduleInfo.key]) {
                cell.moduleInfo.value = moduleInfo.value;
                [cell setNeedsLayout];
            }
        }
    }
}
- (ModuleRowInfo *)handlePostValue:(id)model{
    //    return nil;
    ModuleRowInfo *rowModel = nil;
    ValueChainModel *valueModel = (ValueChainModel *)model;
    for (FormSectionDescriptor *section in self.sectionArray)   {
                for (FormBaseTableViewCell *cell in section.cellArray) {
                    if ([cell.moduleInfo.chainArray containsObject:valueModel.postKey]) {

                        [cell setNeedsLayout];
            }
               
        }
    }
    rowModel.value = [NSString stringWithFormat:@"%@",@"666"];
    return rowModel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
