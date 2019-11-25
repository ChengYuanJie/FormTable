//
//  TreeSelectViewController.h
//  itfsmlib
//
//  树形结构选择页面
//
//  Created by jcca on 14-4-24.
//  Copyright (c) 2014年 Keyloft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDismissed.h"

@interface TreeSelectViewController : UITableViewController
@property (nonatomic, assign) id<UIViewControllerDismissed>delegate;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong) NSArray * loadArray;

@end
