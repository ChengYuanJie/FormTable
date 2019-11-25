//
//  NewTreeSelectController.h
//  THStandardEdition
//
//  Created by Aaron on 2017/3/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ModuleRowInfo.h"
typedef void(^FinishdBlcok)(NSDictionary *dic);
@interface NewTreeSelectController : MenuTableViewController
@property (nonatomic, strong) ModuleRowInfo *model;
@property (nonatomic, copy) NSString *parent_guid;
@property (nonatomic, copy) FinishdBlcok block;
@end
