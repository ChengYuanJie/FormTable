//
//  StatusRefreshCell.h
//  THStandardEdition
//
//  Created by Noah on 2019/8/8.
//  Copyright © 2019 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusRefreshCell : FormBaseTableViewCell
@property (nonatomic, strong) UILabel *textlab;
@property (nonatomic, strong) UILabel *titlelab;
@property (nonatomic, strong) UIButton *refreshButton;
@end

NS_ASSUME_NONNULL_END
