//
//  FormTextArea.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/13.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormTextArea.h"
#import "BaseTextView.h"
#import "Masonry.h"
#import <ReactiveObjc.h>


@interface FormTextArea()

@property (nonatomic, strong) BaseTextView *textArea;

@end
@implementation FormTextArea

- (void)creatUI {
    [super creatUI];
    [self.contentView addSubview:self.textArea];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.right.equalTo(wself.contentView.right).with.offset(ContentMargin);
        make.top.equalTo(wself.contentView.top);
        make.height.mas_equalTo(30*SCREEN_WIDTH_6);
    }];
    [self.textArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself.contentView);
        make.top.equalTo(wself.titleLbl.bottom);
        make.bottom.equalTo(wself.bottomView.top);
    }];
    RACChannelTo(wself, width) = RACChannelTo(wself.textArea, maxLenght);
    RACChannelTo(wself, value) = RACChannelTo(wself.textArea, text);
    RACChannelTo(wself, hint) = RACChannelTo(wself.textArea, plahoder);
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
