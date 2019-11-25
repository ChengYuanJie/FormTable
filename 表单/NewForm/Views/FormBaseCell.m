//
//  FormBaseCell.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormBaseCell.h"
#import "Masonry.h"
#import "FormStatusValidator.h"
#import <ReactiveObjc.h>
@interface FormBaseCell ()
@end

@implementation FormBaseCell

- (instancetype)initWithConfig:(NSDictionary *)config showBottom:(BOOL)showBottom{
    if (self = [super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showBottom = showBottom;
        self.config = config;
        [self setKeyValues:self.config];
        [self creatUI];
        [self afterCreated];
    }
    return self;
}

- (void)creatUI {
    WS(wself);
    [self addSubview:self.xLabel];
    [self addSubview:self.titleLbl];
    [self addSubview:self.bottomView];
    self.xLabel.hidden = !self.required;
    self.hidden = self.isHiddenCell;
    [self.xLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wself.titleLbl);
        make.left.equalTo(wself).with.offset(ContentMargin);
        make.width.mas_equalTo(10.f);
        make.height.mas_equalTo(30.0f);
    }];
    RACChannelTo(wself.titleLbl, text) = RACChannelTo(wself, label);
}
- (void)setShowBottom:(BOOL)showBottom{
    _showBottom = showBottom;
}
- (void)setBottomLine:(UIView *)view{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(view.bottom);
        make.height.mas_equalTo(self.showBottom?10.f:1.0);
    }];
}
- (void)saveValueWithShowValue:(NSString *)showValue {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:[STANDARD_USER_DEFAULT objectForKey:@"form_selected_values"]];
    [dictM setObject:@{@"showValue":showValue?showValue:@"",@"submitValue":self.value} forKey:self.label];
    [STANDARD_USER_DEFAULT setObject:dictM forKey:@"form_selected_values"];
}

- (NSString *)lastShowValue {
    NSDictionary *dict = [STANDARD_USER_DEFAULT objectForKey:@"form_selected_values"];
    if ([dict[self.label] isKindOfClass:[NSDictionary class]]) {
        return dict[self.label][@"showValue"];
    } else {
        return nil;
    }
}
- (id)lastSubmitValue {
    NSDictionary *dict = [STANDARD_USER_DEFAULT objectForKey:@"form_selected_values"];
    if ([dict[self.label] isKindOfClass:[NSDictionary class]]) {
        return dict[self.label][@"submitValue"];
    } else {
        return nil;
    }
}
- (void)afterCreated {
    
}
#pragma mark Lazy
- (UILabel *)xLabel {
    if (!_xLabel) {
        _xLabel = [[UILabel alloc] init];
        _xLabel.text = @"*";
        _xLabel.font = [UIFont systemFontOfSize:18.0];
        _xLabel.textColor  = [UIColor redColor];
        _xLabel.hidden = YES;
    }
    return _xLabel;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = HUI_COLOR;
    }
    return _bottomView;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.numberOfLines = 0;
        [_titleLbl sizeToFit];
        _titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _titleLbl;
}
- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"箭头1"];
    }
    return _rightImageView;
}
#pragma mark Setter
- (void)setReadonly:(BOOL)readonly {
    _readonly = readonly;
    self.userInteractionEnabled = !readonly;
}

#pragma mark Function
- (CGFloat)defaultHeight {
    return 50.0f;
}
- (CGFloat)cellHeight {
    return self.isHiddenCell?0.0:([self defaultHeight] + (self.showBottom?10:0));
}

- (id)exportValue {
    return self.value;
}
#warning 子类重写
- (void)importValue:(NSDictionary *)value {
    if (value[self.code]) {
        self.value = value[self.code];
    }
}
- (NSString *)cherkValue {
    NSString *result;
    if (self.required) {
        if ([self.value isKindOfClass:[NSString class]]) {
            NSString *result = self.value;
            if (result.length < 1) {
                return [NSString stringWithFormat:@"请填写%@",self.label];
            }
        } else if ([self.value isKindOfClass:[NSDictionary class]] || [self.value isKindOfClass:[NSArray class]]) {
            NSDictionary *result = self.value;
            if (result.count < 1) {
                return [NSString stringWithFormat:@"请填写%@",self.label];
            }
        }
    }
    for (NSString *validate in self.validators) {
        SEL sel = NSSelectorFromString(validate);
        if ([FormStatusValidator respondsToSelector:sel]) {
            if (![FormStatusValidator performSelector:sel withObject:self.value]) {
                result = [self resultByValidator:validate];
            }
        }
    }
    return result;
}
- (NSString *)resultByValidator:(NSString *)validate {
    if ([validate isEqualToString:@"validateEmail:"]) {
        return [NSString stringWithFormat:@"%@ 请输入正确的邮箱地址",self.label];
    } else if ([validate isEqualToString:@"validateMobile:"]) {
        return [NSString stringWithFormat:@"%@ 请输入正确的手机号",self.label];
    } else if ([validate isEqualToString:@"validateIdentityCard:"]) {
        return [NSString stringWithFormat:@"%@ 请输入正确的身份证号",self.label];
    } else if ([validate isEqualToString:@"isPureFloat:"]) {
        return [NSString stringWithFormat:@"%@ 请输入小数",self.label];
    } else if ([validate isEqualToString:@"isPureInt:"]) {
        return [NSString stringWithFormat:@"%@ 请输入整数",self.label];
    }
    return nil;
}
- (UITableView *)tableView

{
    
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        
        tableView = tableView.superview;
        
    }
    
    return (UITableView *)tableView;
    
}
- (void)dealloc {
    
}
@end
