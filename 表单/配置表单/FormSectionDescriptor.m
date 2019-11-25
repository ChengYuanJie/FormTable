//
//  FormSectionDescriptor.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormSectionDescriptor.h"
#import "AppDelegate.h"
@implementation FormSectionDescriptor
- (instancetype)initWithContorller:(UIViewController *)contorller
{
    self = [super init];
    if (self) {
        self.controller = contorller;
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.groupInfo = [[ModuleGroupInfo alloc] init];
    }
    return self;
}
-(ModuleGroupInfo *)groupInfo{
    if(!_groupInfo){
        self.groupInfo = [[ModuleGroupInfo alloc] init];
    }
    return _groupInfo;
}
- (void)addFormRow:(ModuleRowInfo *)model
{
    if (!model) {
        return;
    }
    if (model.key == nil || model.key.length == 0) {
        ANLog(@"%@ === tag值为空",model.label);
        
    }
    __block   NSMutableArray *tagArray = [NSMutableArray array];
   [self.moduleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       ModuleRowInfo *info = obj;
       ANLog(@"cell.tag = %@",info.key);
       [tagArray addObject:info.key];
   }];
    if ([tagArray containsObject:model.key]) {
        ANLog(@"生成表单错误， 有相同tag值的cell");
        return;
    }
    [self.moduleArray addObject:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        FormBaseTableViewCell *cell = [self creatCustomCell:model];
        cell.delegate = (id)[AppDelegate shareAppDelegate].pushNavController.visibleViewController;
        if (cell) {
            [self.cellArray addObject:cell];
        }
    });
}
- (void)addFormRowSync:(ModuleRowInfo *)model {
    if (!model) {
        return;
    }
    if (model.key == nil || model.key.length == 0) {
        ANLog(@"%@ === tag值为空",model.label);
        return;
    }
    
    //过滤重复的Key
    if ([self.moduleArray containsObject:model]) {
        ANLog(@"%@ === key值重复",model.key);
        return;
    }
    [self.moduleArray addObject:model];
    [self.rowDic setObject:[model keyValues] forKey:model.key];
}


- (void)removeCellfromSection:(FormSectionDescriptor *)section
                  removeBlock:(void(^)())block
{
    
}
- (FormBaseTableViewCell *)creatCustomCell:(ModuleRowInfo *)model1;
{
    NSString *className = model1.viewType;
    NSBundle *bundle = [NSBundle mainBundle];
    Class aclass = [bundle classNamed:className];
    FormBaseTableViewCell *cell = [[aclass alloc] initWithRowDescriptor:model1];
    cell.moduleInfo = model1;
    cell.cellTag = model1.key;
    return  cell;
}
- (NSMutableArray *)cellArray
{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

- (NSMutableArray *)moduleArray
{
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray array];
    }
    return _moduleArray;
}

-(NSMutableDictionary *)rowDic{
    if (!_rowDic) {
        _rowDic = [[NSMutableDictionary alloc] init];
    }
    return _rowDic;
}

@end
