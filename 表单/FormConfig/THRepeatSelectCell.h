//
//  THRepeatSelectCell.h
//  THStandardEdition
//
//  Created by Aaron on 16/10/12.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "ViewControllerDismissed.h"
@interface THRepeatSelectCell : FormBaseTableViewCell<UIViewControllerDismissed>
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) FormLabel *label;

@end
