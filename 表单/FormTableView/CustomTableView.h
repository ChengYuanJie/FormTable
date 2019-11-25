//
//  CustomTableView.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormInfo.h"
#define ValueChange @"changeValue"

@interface CustomTableView : UITableView
- (instancetype)initWithFrame:(CGRect)frame  Controller:(UIViewController *)controller  formInfo:(FormInfo *) formInfo;
- (CGFloat)getTableHeight;
@end
