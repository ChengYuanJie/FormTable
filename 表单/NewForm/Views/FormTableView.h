//
//  FormTableView.h
//  THStandardEdition
//
//  Created by Aaron on 2018/12/20.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface FormTableView : UITableView
@property (nonatomic, strong) FormObject *formInfo;
@end

NS_ASSUME_NONNULL_END
