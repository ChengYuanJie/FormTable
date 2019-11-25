


//
//  THRepeatSelectCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/12.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "THRepeatSelectCell.h"
#import "RepeatSelectViewController.h"
@implementation THRepeatSelectCell
- (void)creatUI
{
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 44.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
}
- (void)buttonAction:(UIButton *)sender
{
    RepeatSelectViewController *repetVC = [[RepeatSelectViewController alloc] init];
    [[AppDelegate shareAppDelegate].pushNavController pushViewController:repetVC animated:YES];
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(CGRectGetMaxX(self.label.frame) + 5, 0,SCREEN_WIDTH - CGRectGetWidth(self.label.frame) - 5 , 44.f);
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

@end
