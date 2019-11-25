//
//  AbstractValueModel.h
//  THStandardEdition
//
//  Created by Aaron on 2017/8/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractModel.h"

@interface AbstractValueModel : AbstractModel
@property (nonatomic, strong) NSDictionary *valueDic;
@property (nonatomic, copy) NSString *fileName;
- (instancetype)initWithDic:(NSDictionary *)dicValue;
@end
