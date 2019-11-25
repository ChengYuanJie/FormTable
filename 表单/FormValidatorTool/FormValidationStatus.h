//
//  FormValidationStatus.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModuleRowInfo.h"
@interface FormValidationStatus : NSObject
@property(nonatomic, copy) NSString *msg;
@property BOOL isValid;
@property (nonatomic, weak)  ModuleRowInfo*model;

+(FormValidationStatus *)formValidationStatusWithMsg:(NSString *)msg status:(BOOL)status rowDescriptor:(ModuleRowInfo *)model;
@end
