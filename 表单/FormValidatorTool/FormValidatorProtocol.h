//
//  FormValidatorProtocol.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FormValidationStatus;
@class ModuleRowInfo;
@protocol FormValidatorProtocol <NSObject>
@required
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model;
@end
