//
//  FormDatePicker.h
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDate : FormBaseCell

@property (nonatomic, copy) NSString *itemType; /*选择日期的类型:yyyy-mm*/
@property (nonatomic, copy) NSString *minValue;
@property (nonatomic, copy) NSString *maxValue;
@end

NS_ASSUME_NONNULL_END
