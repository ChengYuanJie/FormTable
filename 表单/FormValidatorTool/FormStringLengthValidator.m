//
//  FormStringLengthValidator.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/19.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormStringLengthValidator.h"

@implementation FormStringLengthValidator
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
    NSString *Str = (NSString *)model.value;
    NSInteger length = Str.length;
    if (length == 0) {
        NSString *string = [NSString stringWithFormat:@"%@ 不能为空",model.label];
        return [FormValidationStatus formValidationStatusWithMsg:string status:NO rowDescriptor:model];
    }else if(length > 10){
        NSString *string = [NSString stringWithFormat:@"%@ 字符长度过长",model.label];
        return [FormValidationStatus formValidationStatusWithMsg:string status:NO rowDescriptor:model];
    }
    return nil;
}

@end
