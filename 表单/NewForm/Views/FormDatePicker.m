//
//  FormDatePicker.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormDate.h"
#import "WSDatePickerView.h"
#import "Masonry.h"
#import <ReactiveObjc.h>
#import "BRTextField.h"
@interface FormDate ()

@property (nonatomic, strong) BRTextField *dateLbl;

@end
@implementation FormDate

- (void)creatUI {
    [super creatUI];
    [self.contentView addSubview:self.dateLbl];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself.contentView.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.width.mas_equalTo(100*SCREEN_WIDTH_6);
    }];
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).with.offset(-ContentMargin);
        make.top.equalTo(wself.contentView.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];
    self.dateLbl.tapAcitonBlock = ^{
        [wself buttonAction];
    };
    RACChannelTo(wself, value) = RACChannelTo(wself.dateLbl, text);
    RACChannelTo(wself, hint) = RACChannelTo(wself.dateLbl, placeholder);
}

- (void)buttonAction
{
    
    NSDate *maxDate = self.maxValue?[DateUtil getDateWithFormat:self.maxValue andType:self.type]:nil;
    NSDate *minDate = self.minValue?[DateUtil getDateWithFormat:self.minValue andType:self.type]:nil;
    
    NSDate *showDate = [NSDate date];
    if (self.value && [self.value length] > 4) {
        showDate = [DateUtil getDateWithFormat:self.value andType:self.type];
    } else if (minDate) {
        showDate = minDate;
    } else if (maxDate) {
        showDate = maxDate;
    }
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:[self datePickerType] scrollToDate:showDate CompleteBlock:^(NSDate *selectDate) {
        self.value = [DateUtil getFormatWithDate:selectDate andType:self.type];
    }];

    if (maxDate) {
        datepicker.maxLimitDate = maxDate;
    }
    if (minDate) {
        datepicker.minLimitDate = minDate;
    }
    datepicker.doneButtonColor = [UIColor tintColor];//确定按钮的颜色
    [datepicker show];
}

- (BRTextField *)dateLbl {
    if (!_dateLbl) {
        BRTextField *textField = [[BRTextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor textColor];
        textField.placeholder = @"请选择日期";
        _dateLbl = textField;
    }
    return _dateLbl;
}

- (WSDateStyle)datePickerType{
    if ([self.type isEqualToString:@"yyyy-MM-dd HH:mm:ss"]) {
        return DateStyleShowYearMonthDayHourMinute;
    }else if ([self.type isEqualToString:@"yyyy-MM-dd"]){
        return DateStyleShowYearMonthDay;
    }else if ([self.type isEqualToString:@"HH:mm"]){
        return DateStyleShowHourMinute;
    }else if ([self.type isEqualToString:@"MM-dd HH:mm"]){
        return DateStyleShowMonthDayHourMinute;
    }else if ([self.type isEqualToString:@"yyyy-MM-dd HH:mm"]){
        return DateStyleShowYearMonthDayHourMinute;
    }else{
        return DateStyleShowYearMonthDayHourMinute;
    }
}



@end
