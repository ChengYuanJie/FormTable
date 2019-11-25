//
//  FormPageVC.h
//  THStandardEdition
//
//  Created by Aaron on 2018/9/10.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleRowInfo.h"
#import "MenuTableViewController.h"
typedef void(^ChooseBlock)(NSDictionary *);
@interface FormPageVC : MenuTableViewController
@property (nonatomic,strong) ModuleRowInfo *module;
@property (nonatomic,copy) ChooseBlock block;
@end
