//
//  AbstractFormModel.m
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractFormModel.h"
@interface AbstractFormModel()
@property (nonatomic, strong) AbstractGroupModel *groupMoel;
@end
@implementation AbstractFormModel
- (instancetype)initWithContent:(NSString *)content controller:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.array = [self arrayWithJsonString:content];
        self.formInfo = [[FormInfo alloc] init];
        [self praseGroupModel:controller];
        self.groupMoel =  [[AbstractGroupModel alloc] init];
    }
    return self;
}

- (void)praseGroupModel:(UIViewController *)controller{
    AbstractGroupModel *groupModel = [[AbstractGroupModel alloc] init];
    AbstractRowModel *rowModel = nil;
    for (NSDictionary *dic in self.array) {
        if ([dic[@"viewType"] isEqualToString:@"CloneView"]) {
            groupModel = [[AbstractGroupModel alloc] initWithGroupViewdic:dic viewController:controller];
            groupModel.controller = controller;
        }else{
            rowModel = [[AbstractRowModel alloc] initWithRowViewDic:dic];
            [groupModel.section addFormRow:rowModel.moduleInfo];
            [groupModel.section.rowDic setObject:dic forKey:dic[@"key"]];
        }
    }
    [self.formInfo addSection:groupModel.section];
}
- (NSArray *)arrayWithJsonString:(id)jsonString{
    if (jsonString == nil || [jsonString isKindOfClass:[NSNull class]] ) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        ANLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

@end
