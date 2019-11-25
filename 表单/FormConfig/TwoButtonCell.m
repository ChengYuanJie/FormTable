//
//  TwoButtonCell.m
//  THStandardEdition
//
//  Created by Noah on 2018/6/7.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "TwoButtonCell.h"
#import <Masonry.h>
@interface TwoButtonCell ()
@property (nonatomic, strong) UIButton *buttonA;
@property (nonatomic, strong) UIButton *buttonB;
@end
@implementation TwoButtonCell
- (void)creatUI{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*SCREEN_WIDTH_RATIO, 0, 75*SCREEN_WIDTH_RATIO, 50)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = self.moduleInfo.label;
    [self.contentView addSubview:label];
    
    self.buttonA = [self creatBtn];
     [_buttonA setTitle:self.moduleInfo.dataSource.firstObject forState:UIControlStateNormal];
    [_buttonA addTarget:self action:@selector(didClickFirstBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonB = [self creatBtn];
     [_buttonB setTitle:self.moduleInfo.dataSource.lastObject forState:UIControlStateNormal];
    [_buttonB addTarget:self action:@selector(didClickSecendBtn) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.moduleInfo.dataSource containsObject:self.moduleInfo.value]) {
        if ([self.moduleInfo.dataSource indexOfObject:self.moduleInfo.value] == 0) {
            self.buttonA.selected = YES;
        } else {
            self.buttonB.selected = YES;
        }
    }

    [self.contentView addSubview:self.buttonA];
    [self.contentView addSubview:self.buttonB];
    
    [self.buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).with.offset(-20);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [self.buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonB.left).with.offset(-20);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    self.rowH = 50.f;
}

- (UIButton *)creatBtn {
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundImage:[self imageWithColor:[UIColor tintColor]] forState:UIControlStateSelected];
    
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor tintColor].CGColor;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

- (void)didClickFirstBtn {
    self.buttonA.selected = YES;
    self.buttonB.selected = NO;
    self.moduleInfo.value = self.buttonA.titleLabel.text;
}
- (void)didClickSecendBtn {
    self.buttonB.selected = YES;
    self.buttonA.selected = NO;
    self.moduleInfo.value = self.buttonB.titleLabel.text;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
