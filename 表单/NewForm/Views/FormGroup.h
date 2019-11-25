//
//  FormGroupCell.h
//  SmartForm
//
//  Created by Noah on 2019/8/29.
//  Copyright © 2019 SF. All rights reserved.
//

#import "FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormGroup : FormBaseCell

@property (nonatomic, strong) NSArray *subRows;

@end

NS_ASSUME_NONNULL_END
