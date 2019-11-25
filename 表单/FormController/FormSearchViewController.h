//
//  FormSearchViewController.h
//  director
//
//  Created by Aaron on 16/8/3.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleRowInfo.h"

typedef void (^ReturnValuesFromSQL)(id returnValue);
@interface FormSearchViewController : UIViewController
@property (nonatomic, copy) NSString *textTitle; //标题
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *sqlWhere;
@property (nonatomic, copy) NSString *ascKey;
@property (nonatomic, copy) NSString *showProperty;
@property (nonatomic, strong) ModuleRowInfo *modouleInfo;
@property (nonatomic, copy) ReturnValuesFromSQL returnValues;
@property (nonatomic, strong) NSMutableArray *sqlArray;
@property (nonatomic, strong) NSArray *returnArray;
@end
