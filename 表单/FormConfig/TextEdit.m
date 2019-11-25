//
//  THTextFiledCell.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "TextEdit.h"
@interface TextEdit()
@property (nonatomic, strong) UILabel *label;
@end
@implementation TextEdit
- (void)setLabStr:(NSString *)labStr{
    self.label.text = labStr;
}
- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*SCREEN_WIDTH_RATIO, 0, 75*SCREEN_WIDTH_RATIO, 50)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = self.moduleInfo.label;
    self.label = label;
    [self.contentView addSubview:label];
    _textFiled = [[UITextField alloc ] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, SCREEN_WIDTH - 116.0*SCREEN_WIDTH_RATIO, 50.f)];
    if (self.moduleInfo.value && ![self.moduleInfo.value isKindOfClass:[NSNull class]]){
        _textFiled.text = [NSString stringWithFormat:@"%@",self.moduleInfo.value];
    }
    _textFiled.font = [UIFont systemFontOfSize:14.f];
    _textFiled.textAlignment = NSTextAlignmentRight;
    _textFiled.returnKeyType = UIReturnKeyDone;
    if (self.moduleInfo.hint.length < 1 && !self.moduleInfo.unInteractionEnabled) {
        self.moduleInfo.hint = [NSString stringWithFormat:@"请输入%@",self.moduleInfo.label];
    }
    _textFiled.placeholder = self.moduleInfo.hint;
    [self keybordType];
     self.textFiled.delegate = self;
    self.rowH = 50.f;
    [self.contentView addSubview:_textFiled];
    if (self.moduleInfo.btnShowValue) {
        self.moduleInfo.value  = self.moduleInfo.btnShowValue;
    }
}
- (void)keybordType{
    if ([self.moduleInfo.inputType isEqualToString:@"NUMBER"]){
        _textFiled.keyboardType = UIKeyboardTypeDecimalPad;
    }else if ([self.moduleInfo.inputType isEqualToString:@"INTPAD"]){
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
    }else if ([self.moduleInfo.inputType isEqualToString:@"PHONE"]){
        _textFiled.keyboardType = UIKeyboardTypePhonePad;
    }
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
  if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
            NSString *value = valueDic[self.moduleInfo.key];
            self.textFiled.text = [NSString stringWithFormat:@"%@",value];
           self.moduleInfo.value = value;
        }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.moduleInfo.value = textField.text;
    self.value = textField.text;
 
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
    if (self.moduleInfo.width && searchText.length > self.moduleInfo.width.integerValue) {
        UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"输入内容过长,长度限制为%@",self.moduleInfo.width], @"确定");
        return NO;
    }
    if ([self.moduleInfo.inputType isEqualToString:@"NUMBER"]){
        if (![self isPureInt:searchText] && ![self isPureFloat:searchText] && searchText.length > 0 ) {
            UIAlertViewQuick(@"提示",[NSString stringWithFormat:@"请输入整数或者小数！"], @"确定");
            return NO;
        }
    }    
    NSString *valuStr = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%@: %@",self.moduleInfo.label,self.moduleInfo.value);
    self.value = valuStr;
    self.moduleInfo.value = valuStr;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textFiled) {
        [theTextField resignFirstResponder];
    }
    return YES;
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textFiled.placeholder = placeholder;
}
//判断字符串是否是整型
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}
@end
