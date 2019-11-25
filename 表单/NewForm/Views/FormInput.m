//
//  FormTextArea.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormInput.h"
#import <ReactiveObjc.h>
@interface FormInput()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *plahoderLabel;
@end
@implementation FormInput

- (void)creatUI {
    [super creatUI];
    [self.itemType isEqualToString:@"textarea"]?[self creatTextArea]:[self creatTextFiled];
}
- (void)importValue:(NSDictionary *)value {
    self.textField.text = value[self.code]?:@"";
    self.textView.text = value[self.code];
    self.value = value[self.code];
    if (self.readonly ) {
        self.plahoderLabel.hidden = YES;
        self.textField.placeholder = @"";
    }
    if ([value[self.code] length] >0) {
        self.plahoderLabel.hidden = YES;
    }
}
- (NSString *)cherkValue{
    if (self.required && (!self.value || [self.value length] == 0)) {
        return [NSString stringWithFormat:@"请输入%@",self.label];
    }
    return nil;
}
#pragma mark -- 多行输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.plahoderLabel.hidden = YES;
    }else{
        self.plahoderLabel.hidden = NO;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.value = textView.text;
}
- (void)creatTextArea{
    [self addSubview:self.textView];
    [self addSubview:self.plahoderLabel];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself);
        make.height.mas_equalTo(50.f);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).offset(-ContentMargin);
        make.left.equalTo(wself.titleLbl.right).offset(ContentMargin);
        make.top.equalTo(wself).offset(ContentMargin);
        make.height.mas_equalTo(80.f);
    }];
    [self.plahoderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.textView).offset(3.f);
        make.centerY.equalTo(wself.titleLbl);
    }];
    [self setBottomLine:self.textView];
    if (!self.placeholder.length) {
        self.placeholder = [NSString stringWithFormat:@"请输入%@",self.label];
    }
    RACChannelTo(self.textView, text) = RACChannelTo(self, value);
    RACChannelTo(self.plahoderLabel, text) = RACChannelTo(self, placeholder);
}
- (UILabel *)plahoderLabel{
    if (!_plahoderLabel) {
        _plahoderLabel = [[UILabel alloc] init];
        [_plahoderLabel sizeToFit];
        _plahoderLabel.font =  [UIFont systemFontOfSize:14];
        _plahoderLabel.textColor = HUI_TEXT_COLOR;
    }
    return _plahoderLabel;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = Fount14;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}
#pragma mark --- 单行输入
- (void)creatTextFiled{
    WS(wself);
    [self addSubview:self.textField];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(1.0);
        make.top.equalTo(wself.top);
        make.height.mas_equalTo(50.f);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).with.offset(-ContentMargin);
        make.top.height.equalTo(wself.titleLbl);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];
    [self setBottomLine:self.titleLbl];
    RACChannelTo(wself.textField, text) = RACChannelTo(wself, value);
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        wself.value = x;
    }];
    if (!self.placeholder.length) {
        self.placeholder = [NSString stringWithFormat:@"请输入%@",self.label];
    }
    RACChannelTo(wself.textField, placeholder) = RACChannelTo(wself, placeholder);
    [self setInputType];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14.f];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.placeholder = @"请输入";
        _textField.delegate = self;
    }
    return _textField;
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
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)setInputType{
    if ([self.itemType isEqualToString:@"number"]){
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (CGFloat)defaultHeight {
    return 170.0;
}
- (NSString *)warningText{
    if (self.required) {
        return [NSString stringWithFormat:@"请输入%@",self.label];
    }
    return nil;
}

@end
