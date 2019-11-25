//
//  FormObject.h
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FormValueModel : NSObject
@property (nonatomic, copy) NSDictionary *value; /*组件值*/
@property (nonatomic, copy) NSString *fileName; /*图片id,用逗号拼接*/
@end

@class FormBaseCell;
typedef NS_ENUM(int, FormTableModel) {
    FORM_TABLE_SUBMIT_LOCAL  = 0, // 普通提交表单,网络获取表单配置
    FORM_TABLE_SUBMIT_NET = 1, // 普通提交表单,本地配置
    FORM_TABLE_DETAIL_LOCAL  = 2, //  表单详情接口,本地表单配置
    FORM_TABLE_DETAIL_NET = 3  // 表单详情接口,网络表单配置
};
@interface FormObject : NSObject
@property (nonatomic,assign) BOOL readonly;/*是否只读*/
@property (nonatomic,strong) NSDictionary *netValues;/*表单网络值*/
@property (nonatomic, copy) NSString *title;/*表单标题*/
@property (nonatomic, copy) NSString *formId; /*流程表单ID*/
@property (nonatomic, strong) NSArray <FormBaseCell *>*cellArray;/*表单cell数组*/
@property (nonatomic, copy) NSString *wf; /*流程表单使用,流程相关数据*/
/**
 @configs 单个组件配置
 @return cell数组
 */
+ (NSArray *)creatCellsWithArray:(NSArray *)configs;
/**
 @configs 单个组件配置 showBottom底部分割线显隐
 @return cell数组
 */
+ (NSArray *)creatCellsWithArray:(NSArray *)configs
                       showBttom:(BOOL)showBottom;
/**
 获取value
 */
- (NSDictionary *)getSubmitData;
/**
 获取value模型
 */
- (FormValueModel *)getSubmitValueModel;
@end


@interface FormManager : NSObject
/**
 @formId 表单ID 根据id获取网络配置
 @callback FormObject对象
 */
+ (void)creatByFormId:(NSString *)formId
             complete:(void(^)(FormObject *object))complete;
/**
 @formJson 配置信息
 @callback FormObject对象
 */
+ (void)creatByFormJson:(NSString *)formJson
               complete:(void(^)(FormObject *object))complete;
/**
 @formJson 配置信息 若为空则网络获取
 @formId 表单Id
 @callback FormObject对象
 */
+ (void)getFormFetchByFormId:(NSString *)formId
                    formGuid:(NSString *)guid
                    formJson:(NSString *)formJson
               complete:(void(^)(FormObject *object))complete;
/**
 普通表单提交
 @formObj 表单对象
 @callback complete 是否提交成功
 */
+ (void)submitNormolData:(FormObject *)formObj
          complete:(void(^)(BOOL))complete;
/**
 流程表单提交
 @formObj 表单对象
 @callback complete 是否提交成功
 */
+ (void)submitWfData:(FormObject *)formObj
                complete:(void(^)(BOOL))complete;
@end
