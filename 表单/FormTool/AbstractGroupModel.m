//
//  AbstractGroupModel.m
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractGroupModel.h"
#import "AbstractRowModel.h"
@interface AbstractGroupModel()
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dic;
@end
@implementation AbstractGroupModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.section = [[FormSectionDescriptor alloc] init];
    }
    return self;
}
- (instancetype)initWithGroupViewdic:(NSDictionary *)dic viewController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        self.section = [[FormSectionDescriptor alloc] init];
        self.section.groupInfo = [ModuleGroupInfo objectWithKeyValues:dic];
        [self praseRowModel];
    }
    return self;
}
- (instancetype)initWithRowViewWithDic:(NSDictionary *)dic viewController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        self.dic = dic;
        self.controller = controller;
        self.section = [[FormSectionDescriptor alloc] init];
        self.section.groupInfo.viewType = @"";
        [self praseRowModel];
    }
    return self;
}
- (void)praseRowModel{
    if (self.dic) {
        [self setRowInfo:self.dic];
        return;
    }
    for (NSDictionary *dic in self.section.groupInfo.items) {
        [self setRowInfo:dic];
    }
}
- (void)setRowInfo:(NSDictionary *)rowDic{
    AbstractRowModel *model = [[AbstractRowModel alloc] initWithRowViewDic:rowDic];
    model.moduleInfo.controller = self.controller;
    [self.section.rowDic setValue:rowDic forKey:rowDic[@"key"]];
    [self.section addFormRow:model.moduleInfo];
}
@end
