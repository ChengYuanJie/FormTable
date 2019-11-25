//
//  FormBaseTableViewCell.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ModuleRowInfo.h"
#import "NSDate+Today.h"
#import "FormLabel.h"
#import <Masonry.h>
#import <SDWebImage/SDImageCache.h>
#import "ValueChainModel.h"
#import "FromValueHandelProtocol.h"
//#import "ViewControllerDismissed.h"
#define changMB @"changeControl"
#define ValueChange @"changeValue"
#define PostValue @"postValue"
#define  KScreenW   [UIScreen mainScreen].bounds.size.width
#define  KScreenH   [UIScreen mainScreen].bounds.size.height
#define RemovePickView @"removePickViewFromWindou"
@interface FormBaseTableViewCell : UITableViewCell
- (instancetype)initWithRowDescriptor:(ModuleRowInfo *)rowDescriptor;
@property (nonatomic, strong) ModuleRowInfo *moduleInfo;
@property (nonatomic, strong) ValueChainModel *chainModel;
@property (nonatomic, copy)   NSString *cellTag;
@property (nonatomic, copy) NSString *strr;
@property (nonatomic, assign) CGFloat bottomH;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign)BOOL isLink;
@property (nonatomic, assign) CGFloat rowH;
@property (nonatomic, weak) id <FromValueHandelProtocol>delegate;
@property (nonatomic, strong) UILabel *xLabel;
@property (nonatomic, weak) UITableView *customTableView;

- (void)reloadCell;
// 委托代理人，代理一般需使用弱引用(weak)
- (void)sendNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo;
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic;
@end
