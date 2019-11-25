//
//  FormEmptyValidator.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormEmptyValidator.h"

@implementation FormEmptyValidator
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
    NSString *Str = [NSString stringWithFormat:@"%@",model.value];
    if (Str.length == 0 || Str == nil) {
        NSString *string = [NSString stringWithFormat:@"请填写%@",model.label];
       return [FormValidationStatus formValidationStatusWithMsg:string status:NO rowDescriptor:model];
    }
  return nil;
}

@end
