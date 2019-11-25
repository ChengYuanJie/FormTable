//
//  PrefectureCell.m
//  THStandardEdition
//
//  Created by Aaron on 2016/12/6.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "PrefectureCell.h"

@implementation PrefectureCell

- (void)creatUI
{
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 50.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
    
    self.areasView = [DQAreasView new];
    self.areasView.delegate = self;

}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    NSString *pstr = nil;
    NSString *cstr = nil;
    NSString *str = nil;
    for (NSString *key in valueDic.allKeys) {
        if ([key isEqualToString:@"province"]) {
            pstr = valueDic[@"province"];
        }
        if ([key isEqualToString:@"city"]) {
            cstr = valueDic[@"city"];
        }
        if ([key isEqualToString:@"county"]) {
            str = valueDic[@"county"];
        }
    }
    if (str.length == 0) {
        [self.selectButton setTitle: [NSString stringWithFormat:@"请选择"] forState:UIControlStateNormal];
    }else{
        self.selectButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
           [self.selectButton setTitle: [NSString stringWithFormat:@"%@ %@ %@",pstr,cstr,str] forState:UIControlStateNormal];
        
    }
    self.subDic = @{@"province":pstr!=nil?pstr:@"",@"city":cstr!=nil?cstr:@"",@"county":str!=nil?str:@""};
   self.moduleInfo.value = self.subDic;

}
- (void)buttonAction:(UIButton *)sender
{
  [KeyBoardManager hideKeyBoard];
  [self.areasView startAnimationFunction];
    
}
//点击选中哪一行 的代理方法
- (void)clickAreasViewEnsureBtnActionAreasDate:(DQAreasModel *)model{
    
    [self.selectButton setTitle: [NSString stringWithFormat:@"%@ %@ %@",model.Province,model.city,model.county] forState:UIControlStateNormal];
    self.subDic = @{@"province":model.Province,@"city":model.city,@"county":model.county};
    self.selectButton.titleLabel.numberOfLines = 0;
    self.selectButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.moduleInfo.value = self.subDic;
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.moduleInfo.value) {
            [_selectButton setTitle:self.moduleInfo.value forState:UIControlStateNormal];
        }
        [_selectButton setTitle:@"请点击选择地区" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor colorWithHEXRGB:0xc2c2c2] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(110*SCREEN_WIDTH_RATIO, 0,SCREEN_WIDTH - 125*SCREEN_WIDTH_RATIO , 44.f);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
@end
