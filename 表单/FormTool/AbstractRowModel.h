//
//  AbstractRowModel.h
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractModel.h"
#import "ModuleRowInfo.h"
@interface AbstractRowModel : AbstractModel
@property (nonatomic, strong) ModuleRowInfo *moduleInfo;
- (instancetype)initWithRowViewDic:(NSDictionary *)dic;
@end
