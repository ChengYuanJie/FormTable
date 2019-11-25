//
//  ModuleRowInfo.m
//  itfsm-Project
//
//  Created by Aaron on 16/7/9.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "ModuleRowInfo.h"

@implementation ModuleRowInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        _validatorArray = [NSMutableArray  array];
        _chainArray = [NSMutableArray array];
        _required = NO;
        _canSelect = NO;
        _canModify = NO;
        _changeAware = NO;
//        self.isMaxDate = YES;
        _isLocation = @"1";
    }
    return self;
}

-(void)addValidator:(nonnull id<FormValidatorProtocol>)validator
{
    if (validator == nil || ![validator conformsToProtocol:@protocol(FormValidatorProtocol)]){
        return;
    }
    
    if(![self.validatorArray containsObject:validator]) {
        [self.validatorArray addObject:validator];
    }
}
-(FormValidationStatus *)doValidation
{
    
    
    
    FormValidationStatus *validatorStatus = nil;
    if (self.required) {
        if ([self valueIsEmpty]) {
            NSString *alertMess = nil;
            if ([self.viewType isEqualToString:@"PhotoTaker"]) {
                alertMess = @"请拍摄照片";
            }else if([self.viewType isEqualToString:@"SelectView"]|| [self.viewType isEqualToString:@"TreeSelectView"] ){
                alertMess = [NSString stringWithFormat:@"请选择%@",self.label];
            }else {
                alertMess = [NSString stringWithFormat:@"请输入%@!",self.label];
            }
            validatorStatus = [FormValidationStatus formValidationStatusWithMsg:    [NSString stringWithFormat:@"%@",alertMess]
                                                                         status:NO rowDescriptor:self];
            NSLog(@"%@ 该值不可为空！",self.key);
            return validatorStatus;
        }
    }
    if (self.validatorArray.count == 0) {
        return nil;
    }
    
    for (id<FormValidatorProtocol> v in self.validatorArray) {
        if ([v conformsToProtocol:@protocol(FormValidatorProtocol) ]) {
            FormValidationStatus *vStatus = [v isValid:self];
            if (vStatus != nil && !vStatus.isValid) {
                return vStatus;
            }
            validatorStatus = vStatus;
        }
    }
    return validatorStatus;
}

- (BOOL)valueIsEmpty
{
    if ([self.value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicValue = self.value;
        for (NSString *str in dicValue.allValues) {
            if (str.length != 0){
                return NO;
            }
        }
        return YES;
    }
    
    if ([self.value isKindOfClass:[NSString class]]) {
        NSString *strValue = self.value;
        if (strValue.length == 0) {
            return YES;
        }
    }
    if (self.value == nil || [self.value isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        return YES;
    }
    if ([object isKindOfClass:[ModuleRowInfo class]]) {
        ModuleRowInfo *model = object;
        if ([model.key isEqual:self.key]) {
            return YES;
        }
    }
    return NO;
}
- (void)dealloc
{
    self.chainArray = nil;
    self.validatorArray = nil;
}

@end
