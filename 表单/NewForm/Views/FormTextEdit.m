//
//  FMTextEdit.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormTextEdit.h"
#import "Masonry.h"
#import <ReactiveObjc.h>
#import "FormStatusValidator.h"

@interface FormTextEdit() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textFld;

@end
@implementation FormTextEdit

- (void)creatUI {
    [super creatUI];
    [self addSubview:self.textFld];
    WS(wself);
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself.top);
        make.bottom.equalTo(wself.bottomView.top);
    }];
    [self.textFld mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.right).with.offset(-ContentMargin);
        make.top.equalTo(wself.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];
    
    
    RACChannelTo(wself.textFld, text) = RACChannelTo(wself, value);
    [self.textFld.rac_textSignal subscribeNext:^(id x) {
        wself.value = x;
    }];
    RACChannelTo(wself.textFld, placeholder) = RACChannelTo(wself, hint);
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
    if ([self.inputType isEqualToString:@"NUMBER"] && ![FormStatusValidator isPureInt:searchText] && ![FormStatusValidator isPureFloat:searchText] && searchText.length > 0){
        UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"请输入整数或小数！"], @"确定");
        return NO;
    }
    if ([self.inputType isEqualToString:@"INTPAD"] && ![FormStatusValidator isPureInt:searchText] && searchText.length > 0){
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

- (void)setInputType:(NSString *)inputType {
    _inputType = inputType;
    if ([_inputType isEqualToString:@"NUMBER"]){
        self.textFld.keyboardType = UIKeyboardTypeDecimalPad;
    }else if ([_inputType isEqualToString:@"INTPAD"]){
        self.textFld.keyboardType = UIKeyboardTypeNumberPad;
    }else if ([_inputType isEqualToString:@"PHONE"]){
        self.textFld.keyboardType = UIKeyboardTypePhonePad;
    }
}
- (void)importValue:(NSDictionary *)value {
    self.textFld.text = value[self.code]?:@"";
    self.value = value[self.code];
    if (self.readonly ) {
        self.textFld.text = @" ";
    }
}

@end
