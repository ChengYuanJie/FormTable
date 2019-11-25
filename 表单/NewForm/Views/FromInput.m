//
//  FormTextArea.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormInput.h"
#import "BaseTextView.h"
#import "Masonry.h"
#import <ReactiveObjc.h>
@interface FormInput()<UITextFieldDelegate>
@property (nonatomic, strong) BaseTextView *textArea;
@property (nonatomic, strong) UITextField *textFld;
@end
@implementation FormInput

- (void)creatUI {
    [super creatUI];
    [self.itemType isEqualToString:@"textarea"]?[self creatTextArea]:[self creatTextFiled];
}
#pragma mark -- 多行输入
- (void)creatTextArea{
    [self.contentView addSubview:self.textArea];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself.contentView.top);
        make.height.mas_equalTo(50);
    }];
    [self.textArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView);
        make.left.equalTo(self.titleLbl.right);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(140);
    }];
    [self setBottomLine:self.textArea];
    RACChannelTo(wself, width) = RACChannelTo(wself.textArea, maxLenght);
    RACChannelTo(wself, value) = RACChannelTo(wself.textArea, text);
    RACChannelTo(wself, hint) = RACChannelTo(wself.textArea, plahoder);
}
#pragma mark --- 单行输入
- (void)creatTextFiled{
    WS(wself);
    [self.contentView addSubview:self.textFld];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself.contentView.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.height.mas_equalTo(50);
    }];
    [self.textFld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).with.offset(-ContentMargin);
        make.top.height.equalTo(wself.titleLbl);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];
    [self setBottomLine:self.textFld];
    RACChannelTo(wself.textFld, text) = RACChannelTo(wself, value);
    [self.textFld.rac_textSignal subscribeNext:^(id x) {
        wself.value = x;
    }];
    RACChannelTo(wself.textFld, placeholder) = RACChannelTo(wself, placeholder);
    
}

- (UITextField *)textFld {
    if (!_textFld) {
        _textFld = [[UITextField alloc] init];
        _textFld.font = [UIFont systemFontOfSize:14.f];
        _textFld.textAlignment = NSTextAlignmentRight;
        _textFld.returnKeyType = UIReturnKeyDone;
        _textFld.placeholder = @"请输入";
        _textFld.delegate = self;
    }
    return _textFld;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchText = nil;
    if (textField.text == nil) {
        searchText = string;
    }else{
        if (range.location >= textField.text.length) {
            searchText = [textField.text stringByAppendingString:string];
        }else{
            searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    
    if (self.width && searchText.length > self.width.integerValue) {
        UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"输入内容过长,长度限制为%@",self.width], @"确定");
        return NO;
    }
    if ([self.itemType isEqualToString:@"number"] && ![FormStatusValidator isPureInt:searchText] && ![FormStatusValidator isPureFloat:searchText] && searchText.length > 0){
        UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"请输入整数或小数！"], @"确定");
        return NO;
    }
    if ([self.itemType isEqualToString:@"INTPAD"] && ![FormStatusValidator isPureInt:searchText] && searchText.length > 0){
        UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"请输入整数！"], @"确定");
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFld) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)setInputType{
    if ([self.itemType isEqualToString:@"number"]){
        self.textFld.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (BaseTextView *)textArea {
    if (!_textArea) {
        _textArea = [[BaseTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140.0)];
        _textArea.plahoder = @"请输入";
    }
    return _textArea;
}

- (CGFloat)defaultHeight {
    return 170.0;
}
@end
