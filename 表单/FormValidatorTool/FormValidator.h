//
//  FormValidator.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormValidatorProtocol.h"
#import "FormValidationStatus.h"
#import "ModuleRowInfo.h"
#import "FormStatusValidator.h"
@interface FormValidator : NSObject<FormValidatorProtocol>
@property (nonatomic, weak) id<FormValidatorProtocol>delegate;
+(FormValidator *)validator;
//-(FormValidationStatus *)isValid:(ModuleRowInfo *)model;
@end
