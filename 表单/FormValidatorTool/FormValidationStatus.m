//
//  FormValidationStatus.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormValidationStatus.h"

@implementation FormValidationStatus
-(instancetype)initWithMsg:(NSString*)msg status:(BOOL)isValid rowDescriptor:(ModuleRowInfo *)model {
    self = [super init];
    if (self) {
        self.msg = msg;
        self.isValid = isValid;
        self.model = model;
    }
    
    return self;
}
+(FormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(ModuleRowInfo *)model {
    return [[FormValidationStatus alloc] initWithMsg:msg status:status rowDescriptor:model];
}
@end
