//
//  ModuleGroupInfo.h
//  THStandardEdition
//
//  Created by Aaron on 2017/8/15.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "BaseObject.h"

@interface ModuleGroupInfo : BaseObject
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *viewType;
@end
