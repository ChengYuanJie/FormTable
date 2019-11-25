//
//  THTextFiledCell.h
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"

@interface TextEdit : FormBaseTableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,copy) NSString *labStr;
@end
