//
//  FormSelectView.m
//  THStandardEdition
//
//  Created by Noah on 2018/12/4.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormSelectView.h"
#import "Masonry.h"
#import <ReactiveObjc.h>
#import "BRTextField.h"
#import "BRPickerView.h"
#import "TreeSelectViewController.h"

@interface FormSelectView() <UIViewControllerDismissed>
@property (nonatomic, strong) BRTextField *dateLbl;
@end
@implementation FormSelectView

- (void)creatUI {
    [super creatUI];
        WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.top.equalTo(wself.contentView.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.width.mas_equalTo(100*SCREEN_WIDTH_6);
    }];
    [self.contentView addSubview:self.dateLbl];
    [self.dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wself.contentView.right).with.offset(-ContentMargin);
        make.top.equalTo(wself.contentView.top);
        make.bottom.equalTo(wself.bottomView.top);
        make.left.equalTo(wself.titleLbl.right).with.offset(ContentMargin);
    }];

    self.dateLbl.tapAcitonBlock = ^{
        switch (wself.selectType) {
            case FormSelectTypePresent:
            {
                [BRStringPickerView showStringPickerWithTitle:wself.label dataSource:wself.dataSource defaultSelValue:wself.value?wself.value:wself.dataSource.firstObject isAutoSelect:NO resultBlock:^(id selectValue) {
                    wself.dateLbl.text = selectValue;
                    wself.value = selectValue;
                    [wself saveValueWithShowValue:wself.dateLbl.text];
                }];
            }
                break;
            case FormSelectTypePush:
            {
                // 获取数据源，赋值给TreeController
                TreeSelectViewController *treeController = [[TreeSelectViewController alloc]init];
                treeController.delegate = wself;
                treeController.tableName = wself.tableName;
                [wself.FormController.navigationController pushViewController:treeController animated:YES];
            }
                break;
            default:
                break;
        }
    };
    RACChannelTo(wself, hint) = RACChannelTo(wself.dateLbl, placeholder);
}

- (void)UIViewControllerDidDisappear:(UIViewController *)controller andMessageObject:(id)message {
    NSDictionary *dic = message;
    self.dateLbl.text = dic[self.showKey];
    self.value = dic[self.submitKey];
    [self saveValueWithShowValue:self.dateLbl.text];
}

- (BRTextField *)dateLbl {
    if (!_dateLbl) {
        BRTextField *textField = [[BRTextField alloc]init];
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = [UIColor textColor];
        textField.placeholder = @"请选择";
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
