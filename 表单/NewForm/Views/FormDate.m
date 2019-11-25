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
#import "NSDate+Today.h"
#import "BRTextField.h"
@interface FormDate ()

@property (nonatomic, strong) BRTextField *dateLbl;
@property (nonatomic, strong) NSDate *selectDate;

@end
@implementation FormDate

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
    self.dateLbl.tapAcitonBlock = ^{
        [wself buttonAction];
    };
    if (!self.value) {
        self.value = [DateUtil getDateFormatStringWithType:[self getDateStrType]];
    }
    RACChannelTo(wself.dateLbl, placeholder) = RACChannelTo(wself, placeholder);
    RACChannelTo(wself.dateLbl, text) =  RACChannelTo(wself, value);
}
- (NSString *)cherkValue{
    if (!self.value && self.required) {
        return [NSString stringWithFormat:@"请选择%@",self.label];
    }
    return nil;
}
- (void)importValue:(NSDictionary *)value {
    [super importValue:value];
    if (self.readonly) {
        self.rightImageView.hidden = YES;
        self.dateLbl.placeholder = @"";
        [self.dateLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-ContentMargin);
        }];
    }
}

- (void)buttonAction
{
    
//    NSDate *maxDate = self.maxValue?[DateUtil getDateWithFormat:self.maxValue andType:self.type]:nil;
//    NSDate *minDate = self.minValue?[DateUtil getDateWithFormat:self.minValue andType:self.type]:nil;
//
//    NSDate *showDate = [NSDate date];
//    if (self.value && [self.value length] > 4) {
//        showDate = [DateUtil getDateWithFormat:self.value andType:self.type];
//    } else if (minDate) {
//        showDate = minDate;
//    } else if (maxDate) {
//        showDate = maxDate;
//    }
    self.selectDate = [NSDate date];
    WS(weakSelf);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:[self getDatetype] scrollToDate:self.selectDate CompleteBlock:^(NSDate *selectDate) {
        weakSelf.value = [DateUtil getFormatWithDate:selectDate andType:[self getDateStrType]];
        weakSelf.dateLbl.text = weakSelf.value;
        weakSelf.selectDate = selectDate;
    }];

//    if (maxDate) {
//        datepicker.maxLimitDate = maxDate;
//    }
//    if (minDate) {
//        datepicker.minLimitDate = minDate;
//    }
    datepicker.doneButtonColor = [UIColor tintColor];//确定按钮的颜色
    [datepicker show];
}

- (BRTextField *)dateLbl {
    if (!_dateLbl) {
        BRTextField *textField = [[BRTextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = self.placeholder;
        textField.textColor = [UIColor blackColor];
        _dateLbl = textField;
    }
    return _dateLbl;
}
- (WSDateStyle)getDatetype{
    if ([self.itemType isEqualToString:@"date"]) {
        return DateStyleShowYearMonthDay;
    }else if ([self.itemType isEqualToString:@"year-month"]){
        return DateStyleShowYearMonth;
    }
    return DateStyleShowYearMonthDayHourMinute;
}
- (NSString *)getDateStrType{
    if ([self.itemType isEqualToString:@"date"]) {
        return @"yyyy-MM-dd";
    }else if ([self.itemType isEqualToString:@"year-month"]){
        return @"yyyy-MM";
    }
    return @"yyyy-MM-dd HH:mm:ss";
}
- (NSString *)warningText{
    if (self.required) {
        return [NSString stringWithFormat:@"请选择日期"];
    }
    return nil;
}
@end
