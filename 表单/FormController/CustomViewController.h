//
//  CustomViewController.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormInfo.h"
#import "UpdateService.h"
#import "CustomTableView.h"
#import "ValueChainModel.h"
#import "offlineCaheModel.h"
#import "OfflineDataModel.h"
#import "DraftManager.h"
#import "FormNumberValidator.h"
#import "FormStringLengthValidator.h"
#import "FormEmptyValidator.h"
#import "MenuModule.h"
#import "ViewControllerDismissed.h"

//#import "UIViewExt.h"
#import "offlineCaheModel+Factory.h"
@interface CustomViewController : UIViewController<UIViewControllerDismissed>
@property (nonatomic, weak) id<UIViewControllerDismissed> delegate;
@property (nonatomic, strong) CustomTableView *tableView;
@property (nonatomic, strong) FormInfo *formInfo;
@property (nonatomic, strong) MenuModule *menu;
@property (nonatomic, strong) offlineCaheModel *offlineModel;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSDictionary *transferValueDict;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSDictionary *formContent;
@property (nonatomic, copy) NSString *modelCode;
// 从拜访计划进来的需要用到拜访guid 关联后台数据库表
@property (nonatomic, copy) NSString *main_guid;
@property (nonatomic, copy) NSString *store_guid;
@property (nonatomic, copy) NSString *step_item_guid;
/**
 * 从网络获取transferValueDict
 */
@property (nonatomic,strong) NSDictionary *netDic;
// 数据更新条件字段
@property (nonatomic, copy) NSString *whereStr;
- (instancetype)initWithfeatureCode:(NSString *)featureCode;
- (instancetype)initWithFeatureCode:(NSString *)featureCode menu:(MenuModule *)menu;
@end
