//
//  AbstractRowModel.m
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractRowModel.h"
@interface AbstractRowModel()
@property (nonatomic, strong) NSDictionary *dic;
@end
@implementation AbstractRowModel
- (instancetype)initWithRowViewDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.dic = dic;
        self.moduleInfo = [[ModuleRowInfo alloc] init];
        self.moduleInfo = [ModuleRowInfo objectWithKeyValues:dic];
    }
    return self;
}
@end
