//
//  FormLocationValidator.m
//  THStandardEdition
//
//  Created by Aaron on 2017/3/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "FormLocationValidator.h"

@implementation FormLocationValidator
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model{
    AMLoction *location = [[AMLoction alloc] init];
    location.latitude = model.value[@"lat"];
    location.longtitude = model.value[@"lon"];
    location.address = model.value[@"address"];
    if(![location isValid]) {
        NSString *string = [NSString stringWithFormat:@"定位地址不可用，请刷新定位"];
        return [FormValidationStatus formValidationStatusWithMsg:string status:NO rowDescriptor:model];
    }
    return nil;
}
@end
