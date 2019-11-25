//
//  FormController.h
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuUIViewController.h"
#import "FormTableView.h"
@interface FormController : MenuUIViewController
@property (nonatomic, copy) NSString *formId; //表单id
@property (nonatomic, copy) NSString *formGuid;//表单guid 请求表单详情使用
@property (nonatomic, assign) FormTableModel formModel;
@end
