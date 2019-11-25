//
//  THTextViewCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/9/26.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "TextArea.h"
@implementation TextArea

- (void)creatUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20/375.f*SCREEN_WIDTH, 0, 200, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = self.moduleInfo.label;
    [self.contentView addSubview:label];
    self.xLabel.frame = CGRectMake(8*SCREEN_WIDTH_RATIO, 10, 10, 10);
    _textView = [[BaseTextView alloc] initWithFrame:CGRectMake(0, self.moduleInfo.label?30:0, SCREEN_WIDTH, 140)];
    _textView.delegate = self;
    if (self.moduleInfo.width.intValue > 0) {
        _textView.maxLenght = self.moduleInfo.width.intValue;
    }else{
        _textView.maxLenght = 50;
    }
    if (self.moduleInfo.label) {
        self.rowH = 170;
    }else{
        self.rowH = 140;
    }
    if (self.moduleInfo.unInteractionEnabled) {
        
    }
    [self.contentView addSubview:_textView];
    _textView.text = self.moduleInfo.value;
    _textView.plahoder = self.moduleInfo.hint;
    
}
-(void)setPlahoder:(NSString *)plahoder{
    self.textView.plahoder = plahoder;
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *sss = valueDic[self.moduleInfo.key];
        self.textView.text = sss;
        self.moduleInfo.value = sss;
        if (sss.length > 0) {
            [self.hintLabel setHidden:YES];
        }
    }
}

#pragma mark - UITextView Delegate Methods
-(void)textViewDidChange:(NSString *)text{
    self.moduleInfo.value = text;
    self.value = text;
}
@end
