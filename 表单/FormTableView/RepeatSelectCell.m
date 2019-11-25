//
//  RepeatSelectCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/12.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "RepeatSelectCell.h"

@interface RepeatSelectCell()
@property (nonatomic, strong)UIImageView * selecteButton;     //选中button
@end
@implementation RepeatSelectCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
        self.selectStatus = NO;
    }
    return self;
}
- (void)creatSubViews
{
    [self.contentView addSubview:self.selecteButton];
}
- (void)setSelectStatus:(BOOL)selectStatus
{
    _selectStatus = selectStatus;
    if (selectStatus) {
        _selecteButton.image = [UIImage imageNamed:@"选中"];
    } else {
        _selecteButton.image = [UIImage imageNamed:@"选择2"];
    }
}

- (UIImageView *)selecteButton
{
    if (!_selecteButton) {
        _selecteButton = [[UIImageView alloc] initWithFrame:CGRectMake(250*SCREEN_WIDTH_RATIO, 10, 20, 20)];
    }
    return _selecteButton;
}

@end
