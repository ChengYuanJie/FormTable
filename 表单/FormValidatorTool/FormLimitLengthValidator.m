
//
//  FormLimitLengthValidator.m
//  THStandardEdition
//
//  Created by Aaron on 2017/6/23.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "FormLimitLengthValidator.h"

@implementation FormLimitLengthValidator
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
    BOOL isValid = [self limit:model.value length:model.limitLength];
    if (isValid) {
        return nil;
    }else{
        NSString *string = [NSString stringWithFormat:@"%@ 不能大于%ld位",model.label,(long)model.limitLength];
        return [FormValidationStatus formValidationStatusWithMsg:string status:isValid rowDescriptor:model];
    }
    return nil;
}
- (BOOL)limit:(NSString*)value length:(NSInteger)length{
    BOOL isLimit = YES;
    if (value.length > length) {
        isLimit = NO;
    }
    return isLimit;
}


@end
