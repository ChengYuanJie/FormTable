//
//  QRCodeView.h
//  CarPin
//
//  Created by Aaron on 2019/5/25.
//  Copyright © 2019年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeView : FormBaseTableViewCell
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) FormLabel *label;
@end

NS_ASSUME_NONNULL_END
