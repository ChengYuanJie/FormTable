//
//  AbstractGroupModel.h
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractModel.h"
#import "FormSectionDescriptor.h"
@interface AbstractGroupModel : AbstractModel
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) FormSectionDescriptor *section;
//**  groupView 初始化方式 **//
- (instancetype)initWithGroupViewdic:(NSDictionary *)dic viewController:(UIViewController *)controller;
//**  rowView 初始化方式  **//
- (instancetype)initWithRowViewWithDic:(NSDictionary *)dic viewController:(UIViewController *)controller;

@end
