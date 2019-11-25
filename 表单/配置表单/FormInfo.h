//
//  FormInfo.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FormSectionDescriptor.h"
#import "ModuleRowInfo.h"
#define ValueChange @"changeValue"
#import "FormValidationStatus.h"
#import "AbstractValueModel.h"
typedef NS_ENUM(NSInteger, NetWorkType){
    MergeNetWork = 1 << 1, // 合并提交方式
    InsertNetWork = 1 << 2, // 插入提交方式
    UpdateNetWork = 1 << 3 // 更新提交方式 

};

@interface FormInfo : NSObject
/**
 * 模块标题
 */
@property (nonatomic, copy) NSString * title;

/**
 * 是否显示标题栏右侧按钮
 */
@property (nonatomic, assign) BOOL rightBtnShow;

/**
 *  网络请求方式
 */
@property (nonatomic, copy) NSString *netWorkType;
/**
 *  网络请求model
 */
@property (nonatomic, copy) NSString *netModel;

/**
 * tableView的组的个数
 */
@property (nonatomic, assign) int sectionCount;
/**
 * tableView的row的个数
 */
@property (nonatomic, assign) int rowCount; //tableView行的个数
/**
 * 存放字典，每一组row的个数
 * @prama section:row , sectionArray.count 为组的个数
 */
@property (nonatomic, strong) NSMutableArray *sectionArray;
/**
 * 存放每一行控件的个数
 */
@property (nonatomic, strong) NSMutableArray *configCount;
/**
 *
 */
@property (nonatomic, strong) NSMutableDictionary *rowDic;

@property (nonatomic, strong) FormSectionDescriptor *section;

@property (nonatomic, weak) id <FromValueHandelProtocol>delegate;

/**自定义字段集合 **/
@property (nonatomic,strong) NSMutableArray *customKeyAry;
/**自定义字段是否回写数据库 **/
@property (nonatomic,assign) BOOL isSyneCustomKey;
@property (nonatomic,assign) BOOL isClone; //克隆控件单独处理
@property (nonatomic, copy) NSString *tableName; //数据库表名
@property (nonatomic, copy) NSString *versionCode; // 提交数据时通知后台变更的版本code
//提交时s需要的x参数
@property (nonatomic,strong) NSArray *before;
//+ (instancetype)shareFormInfo;
//增加组
- (void)addSection:(FormSectionDescriptor *)section;
//给每一行控件赋值  从后台获取的json串
- (void)setValuesFromSevice:(id )object;
//给控件赋值
- (void)setRowValues:(id)object;
//给模型赋值
- (void)setModuleValues:(id)object;
//给单个cell进行赋值
- (void)setRowValueWithRowKey:(NSString *)key value:(id)value;
//获取值
- (NSArray *)getValuesRequired:(BOOL)isRequired;
//需要回写到本地数据库的值
- (NSMutableDictionary *)geValuesStoreSQL;
//删除某一行cell
- (void)removeCellWithKey:(NSString *)key;
//表单验证方法
- (BOOL)validatorValue;
// 验证是否有定位组件
- (BOOL )doValidatorLocaType;

@end
