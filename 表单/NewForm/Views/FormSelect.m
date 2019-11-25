//
//  FormSelectView.m
//  THStandardEdition
//
//  Created by Noah on 2018/12/4.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormSelect.h"
#import "Masonry.h"
#import <ReactiveObjc.h>
#import "BRTextField.h"
#import "BRPickerView.h"
#import "TreeSelectViewController.h"

@interface FormSelect() <UIViewControllerDismissed>
@property (nonatomic, strong) BRTextField *dateLbl;
@end
@implementation FormSelect
- (void)importValue:(NSDictionary *)value {
    if (value[self.code]) {
        self.dateLbl.text = value[self.code];
    }
    self.value = value[self.code];
    if (self.readonly) {
        self.rightImageView.hidden = YES;
        self.dateLbl.placeholder = @"";
        [self.dateLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ContentMargin);
        }];
    }
}
- (NSString *)cherkValue{
    if (!self.value && self.required) {
        return [NSString stringWithFormat:@"请选择%@",self.label];
    }
    return nil;
}
- (void)creatUI {
    [super creatUI];
    [self addSubview:self.dateLbl];
    [self addSubview:self.rightImageView];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself);
        make.height.mas_equalTo(50.f);
    }];
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.rightImageView.left).with.offset(-ContentMargin);
        make.top.height.equalTo(wself.titleLbl);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-ContentMargin);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(7);
        make.centerY.equalTo(self.titleLbl);
    }];
    [self setBottomLine:self.titleLbl];
    WS(weakSelf);
    self.dateLbl.tapAcitonBlock = ^{
        [BRStringPickerView showStringPickerWithTitle:wself.label dataSource:wself.items defaultSelValue:weakSelf.value isAutoSelect:NO resultBlock:^(id selectValue) {
            wself.dateLbl.text = selectValue;
            wself.value = selectValue;
            [wself saveValueWithShowValue:wself.dateLbl.text];
        }];
    };
    RACChannelTo(wself.dateLbl, placeholder) = RACChannelTo(wself, placeholder);
}

- (BRTextField *)dateLbl {
    if (!_dateLbl) {
        BRTextField *textField = [[BRTextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor textColor];
        _dateLbl = textField;
    }
    return _dateLbl;
}


- (void)afterCreated {
    if (self.useDefault) {
        NSString * showValue = [self lastShowValue];
        id submitValue = [self lastSubmitValue];
        if (showValue && submitValue) {
            self.dateLbl.text = showValue;
            self.value = submitValue;
        }
    }
}

@end
