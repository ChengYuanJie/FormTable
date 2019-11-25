//
//  FormSectionDescriptor.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormBaseTableViewCell.h"
#import "ModuleRowInfo.h"
#import "ModuleGroupInfo.h"
@interface FormSectionDescriptor : NSObject
@property (nonatomic, strong) FormBaseTableViewCell *cell;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) NSMutableArray *moduleArray;
@property (nonatomic,strong)  ModuleGroupInfo*groupInfo;
/**
 *  @pmara  给每一行的cell做标记
 */
@property (nonatomic, strong) NSMutableDictionary *rowDic;
- (instancetype)initWithContorller:(UIViewController *)contorller;
- (void)addFormRow:(ModuleRowInfo *)model;
- (void)addFormRowSync:(ModuleRowInfo *)model;
- (void)removeCellfromSection:(FormSectionDescriptor *)section
                  removeBlock:(void(^)())block;

- (FormBaseTableViewCell *)creatCustomCell:(ModuleRowInfo *)model1;
@end
