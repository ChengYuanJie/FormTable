//
//  FormConfig.h
//  THStandardEdition
//
//  Created by Aaron on 2017/9/19.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormInfo.h"
@interface FormConfig : NSObject
+(FormInfo *)creatFormInfoWithFeatureCode:(NSString *)featureCode controller:(UIViewController *)controller;
//获取自定义字段
+(void)checkCustomRow:(FormSectionDescriptor*)section controller:(UIViewController *)vc form:(FormInfo *)form;
@end
