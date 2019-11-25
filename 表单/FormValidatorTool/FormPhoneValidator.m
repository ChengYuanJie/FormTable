//
//  FormPhoneValidator.m
//  THStandardEdition
//
//  Created by Aaron on 2017/3/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "FormPhoneValidator.h"

@implementation FormPhoneValidator
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
    if (![FormStatusValidator validateMobile:model.value]) {
        NSString *string = [NSString stringWithFormat:@"请输入正确的手机号"];
        return [FormValidationStatus formValidationStatusWithMsg:string status:NO rowDescriptor:model];
    }
    return nil;
}

@end
