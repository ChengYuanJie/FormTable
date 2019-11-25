//
//  FormStatusValidator.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/18.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormStatusValidator : NSObject
/**
 *  @pmara 判断字符串是否是邮箱地址
 */
+ (BOOL)validateEmail:(NSString *)email;
/**
 *  @pmara 判断字符串是电话号码
 */
+ (BOOL)validateMobile:(NSString *)mobile;
/**
 *  @pmara 判断字符串是否为车牌号码
 */
+ (BOOL)validateCarNo:(NSString *)carNo;
/**
 *  @pmara 判断字符串是否为用户名
 */
+ (BOOL)validateUserName:(NSString *)name;
/**
 *  @pmara 判断字符串是否为密码类型
 */
+ (BOOL)validatePassword:(NSString *)passWord;
/**
 *  @pmara 判断字符串是否为昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname;
/**
 *  @pmara 判断字符串是否为身份证
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
/**
 *  @pmara 判断字符串是否为浮点
 */
+ (BOOL)isPureFloat:(NSString*)string;
/**
 *  @pmara 判断字符串是否为整型
 */
+ (BOOL)isPureInt:(NSString*)string;
@end
