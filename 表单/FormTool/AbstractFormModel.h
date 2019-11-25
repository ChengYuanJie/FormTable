//
//  AbstractFormModel.h
//  THStandardEdition
//
//  Created by Aaron on 2017/1/4.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractModel.h"
#import "FormInfo.h"
#import "AbstractGroupModel.h"
#import "AbstractRowModel.h"
#import "FormSectionDescriptor.h"
@interface AbstractFormModel : AbstractModel
// ** form 所有信息 **//
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) FormInfo *formInfo;
/**
 *   @ form表单解析工具类 
 *   @ 接受一个字典,和使用控制器 return 一个form  细节处理在子节点处理
 */
- (instancetype)initWithContent:(NSString *)content controller:(UIViewController *)controller
;
@end
