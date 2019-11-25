//
//  FormSelectRadio.m
//  THStandardEdition
//
//  Created by Aaron on 2019/8/29.
//  Copyright © 2019 程元杰. All rights reserved.
//

#import "FormSelectRadio.h"
#import "Masonry.h"
#import "UILabel+LabelHeightAndWidth.h"
@interface FormSelectRadio ()
@property (nonatomic, strong) UIView *labelsView;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, assign) CGFloat baseViewHeight;
@end
@implementation FormSelectRadio

- (void)creatUI {
    [super creatUI];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself);
        make.height.mas_equalTo(50.f);
        make.width.mas_equalTo(100.f*SCREEN_WIDTH_6);
    }];
    [self addSubview:self.labelsView];
    [self creatlabs];
}
- (NSString *)cherkValue{
    if (!self.value && self.required) {
        return [NSString stringWithFormat:@"请选择%@",self.label];
    }
    return nil;
}
- (void)selectTitle:(UIButton *)btn{
    for (UIButton *btn1 in self.btns) {
        if (btn1.tag == btn.tag) {
            self.value = btn1.titleLabel.text;
            btn1.layer.borderColor = [UIColor colorWithHEXRGB:0x157EFB].CGColor;
            btn1.backgroundColor = [UIColor colorWithHEXRGB:0xd2e7ff];
            [btn1 setTitleColor:[UIColor colorWithHEXRGB:0x157EFB] forState:UIControlStateNormal];
        }else{
            btn1.layer.borderColor = HUI_COLOR.CGColor;
            btn1.backgroundColor = [UIColor clearColor];
            [btn1 setTitleColor:HUI_TEXT_COLOR forState:UIControlStateNormal];
        }
    }
    if ([btn.titleLabel.text isEqualToString:@"其他"]) {
        [self.labelsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.baseViewHeight + 50.f);
        }];
    }else{
        [self.labelsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(MAX(self.baseViewHeight, 50.f));
        }];
    }
    [self.tableView reloadData];
}
-(void)creatlabs{
    /*
     if (!markBtn) {
     tagBtn.frame = CGRectMake(maxWdith - marginX - width, marginY, width, height);
     }else{
     if (markBtn.frame.origin.x - width - 2* marginX < 0) {
     tagBtn.frame = CGRectMake(maxWdith - marginX - width, markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width, height);
     baseViewHeight = marginY+height+baseViewHeight;
     }else{
     tagBtn.frame = CGRectMake(markBtn.frame.origin.x, markBtn.frame.origin.y, width, height);
     //                CGRect frame = markBtn.frame;
     //                frame.origin.x = tagBtn.frame.origin.x - marginX -width;
     //                markBtn.frame = frame;
     }
     }

     */
    CGFloat marginX = 8;
    CGFloat marginY = 13;
    CGFloat height = 24;
    UIButton * markBtn;
    CGFloat maxWdith = SCREEN_WIDTH - 100*SCREEN_WIDTH_6;
    CGFloat baseViewHeight = 2*marginY + height;
//        CGFloat baseViewHeight = marginY;
    CGFloat curretW = 0;
    for (int i = 0; i < self.items.count; i++) {
        CGFloat width = [UILabel getWidthWithTitle:self.items[i] font:Fount12] + 16;
        width = MAX(50*SCREEN_WIDTH_6, width);
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.labelsView addSubview:tagBtn];
        if (curretW + width + marginX > maxWdith) {
            curretW = 0.0;
            baseViewHeight = baseViewHeight + height +marginY;
            [markBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.labelsView).offset(-marginX);
            }];
            [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
                make.top.mas_equalTo(markBtn.bottom).offset(marginY);
            }];

        }else{
            if (!markBtn) {
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height);
                    make.top.mas_equalTo(marginY);
                }];
            }else{
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
//                    make.height.mas_equalTo(height);
//                    make.top.mas_equalTo(marginY);
                    make.centerY.height.mas_equalTo(markBtn);
                }];
                [markBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(tagBtn.left).offset(-marginX);
                }];
            }
        }
        curretW = curretW + width +marginX;
        if (i == self.items.count - 1){
            [tagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.labelsView).offset(-marginX);
            }];
        }
        [tagBtn setTitle:self.items[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [tagBtn setTitleColor:HUI_TEXT_COLOR forState:UIControlStateNormal];
        [self makeCornerRadius:5 borderColor:HUI_COLOR layer:tagBtn.layer borderWidth:1];
        markBtn = tagBtn;
        markBtn.tag = 100+i;
        [tagBtn addTarget:self action:@selector(selectTitle:) forControlEvents:UIControlEventTouchUpInside];
        [self.labelsView addSubview:markBtn];
        [self.btns addObject:markBtn];
    }
    self.baseViewHeight = baseViewHeight;
    [self.labelsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.mas_equalTo(150*SCREEN_WIDTH_6);
        make.height.mas_equalTo(MAX(baseViewHeight, 50.f));
    }];
    [self setBottomLine:self.labelsView];
}
-(void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth
{
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}
- (UIView *)labelsView{
    if (!_labelsView) {
        _labelsView = [[UIView alloc] init];
    }
    return _labelsView;
}
- (NSMutableArray *)btns{
    if (!_btns) {
        _btns = [[NSMutableArray alloc] init];
    }
    return _btns;
}
- (void)importValue:(NSDictionary *)value {
    NSString *title = value[self.code];
    for (UIButton *btn in self.btns) {
        if ([btn.titleLabel.text isEqualToString:title]) {
            [self selectTitle:btn];
            break;
        }
    }
    self.value = title;
}
@end
