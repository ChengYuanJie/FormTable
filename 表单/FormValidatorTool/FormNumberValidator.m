//
//  FormNumberValidator.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormNumberValidator.h"

@implementation FormNumberValidator

-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
    BOOL isValid = [FormStatusValidator isPureInt:model.value];
    if (isValid) {
        return nil;
    }else{
        NSString *string = [NSString stringWithFormat:@"%@ 值类型不对",model.label];
      return [FormValidationStatus formValidationStatusWithMsg:string status:isValid rowDescriptor:model];
    }
    return nil;
}

@end
