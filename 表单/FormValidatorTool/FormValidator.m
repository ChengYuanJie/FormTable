//
//  FormValidator.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormValidator.h"

@implementation FormValidator
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.delegate = self;
    }
    return self;
}
+(FormValidator *)validator
{
    return [[self alloc] init];
}
-(FormValidationStatus *)isValid:(ModuleRowInfo *)model
{
       return nil;
}
@end
