//
//  QRCodeView.m
//  CarPin
//
//  Created by Aaron on 2019/5/25.
//  Copyright © 2019年 程元杰. All rights reserved.
//

#import "QRCodeView.h"
#import "BarCodeScanController.h"
@interface QRCodeView()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *readerBtn;
@property (nonatomic, strong) UITextField *textFiled;
@end
@implementation QRCodeView

- (void)creatUI{
    self.label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    [self.contentView addSubview:self.label];
    [self addSubview:self.readerBtn];
    self.rowH = 50.f;
    _textFiled = [[UITextField alloc ] initWithFrame:CGRectZero];
    self.readerBtn.hidden = self.moduleInfo.unInteractionEnabled;
    _textFiled.font = [UIFont systemFontOfSize:14.f];
    _textFiled.textAlignment = NSTextAlignmentRight;
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.placeholder = self.moduleInfo.hint;
    [_textFiled sizeToFit];
    self.textFiled.delegate = self;
    [self.contentView addSubview:_textFiled];
    self.rowH = 50.f;
    if (self.moduleInfo.value) {
        _textFiled.text = self.moduleInfo.value;
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
            make.height.equalTo(self);
        }];
    }else{
        [self.readerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.right.height.width.mas_equalTo(30);
        }];
        [self.textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.readerBtn.left).offset(-5);
            make.height.equalTo(self);
        }];
    }
}
- (void)beginReader{
    WS(weakSelf);
    BarCodeScanController *barScan = [[BarCodeScanController alloc] init];
    barScan.successHandle = ^(NSString *result){
        weakSelf.textFiled.text = result;
        weakSelf.moduleInfo.value = result;

    };
    [[AppDelegate shareAppDelegate].pushNavController pushViewController:barScan animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.moduleInfo.value = textField.text;
}
- (UIButton *)readerBtn{
    if (!_readerBtn) {
        _readerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readerBtn addTarget:self action:@selector(beginReader) forControlEvents:UIControlEventTouchUpInside];
        [_readerBtn setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
        _readerBtn.frame = CGRectMake(SCREEN_WIDTH - 50, 10, 30, 30);
    }
    return _readerBtn;
}

@end
