//
//  FormDatePicker.h
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormDatePicker : FormBaseCell

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *minValue;
@property (nonatomic, copy) NSString *maxValue;
@end

NS_ASSUME_NONNULL_END
