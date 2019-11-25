//
//  FormBaseModel.h
//  THStandardEdition
//
//  Created by Aaron on 2019/8/28.
//  Copyright © 2019 程元杰. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormBaseModel : BaseObject
#pragma mark -- 基本字段
//控件类型
@property (nonatomic, copy) NSString *type;
//控件code
@property (nonatomic, copy)  NSString *code;
//控件显示的标题
@property (nonatomic, copy) NSString * label;
//控件的值
@property (nonatomic, strong) id value;
//控件显示的占位值
@property (nonatomic, copy) NSString *placeholder;
//控件显示的上次已选值
@property (nonatomic,assign) BOOL useDefault;
//控件输入值长度最大值
@property (nonatomic, copy) NSString *width;
//是否必填
@property (nonatomic, assign) BOOL required;
@end

NS_ASSUME_NONNULL_END
