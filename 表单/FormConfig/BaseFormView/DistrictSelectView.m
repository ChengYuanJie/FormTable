//
//  PrefectureCell.m
//  THStandardEdition
//
//  Created by Aaron on 2016/12/6.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "DistrictSelectView.h"

@implementation DistrictSelectView

- (void)creatUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _label = [[FormLabel alloc] initWithFrame:CGRectMake(0,self.frame.size.height , 0, self.frame.size.height) title:self.moduleInfo.label];
    self.rowH = 50.f;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:self.selectButton];
    self.areasView = [DQAreasView new];
    self.areasView.delegate = self;
    self.areasView.province = self.moduleInfo.province;
    if (!self.moduleInfo.districtKey || [self.moduleInfo.districtKey isEqualToString:@""]) {
        if (!self.subDic) {
            self.subDic = @{self.moduleInfo.cityKey:@"",self.moduleInfo.provinceKey:@""};
        }
    } else {
        if (!self.subDic) {
            self.subDic = @{self.moduleInfo.cityKey:@"",self.moduleInfo.provinceKey:@"",self.moduleInfo.districtKey:@""};
        }
    }
    self.moduleInfo.value = self.subDic;
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
        [self.selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (!self.moduleInfo.districtKey || [self.moduleInfo.districtKey isEqualToString:@""]) {
        self.subDic = @{@"province":pstr!=nil?pstr:@"",@"city":cstr!=nil?cstr:@""};
    } else {
        self.subDic = @{@"province":pstr!=nil?pstr:@"",@"city":cstr!=nil?cstr:@"",@"county":str!=nil?str:@""};
    }
    
   self.moduleInfo.value = self.subDic;

}
- (void)buttonAction:(UIButton *)sender
{
  [KeyBoardManager hideKeyBoard];
  [self.areasView startAnimationFunction];
    
}
//点击选中哪一行 的代理方法county
- (void)clickAreasViewEnsureBtnActionAreasDate:(DQAreasModel *)model{
    [self.selectButton setTitle: [NSString stringWithFormat:@"%@ %@ %@",model.Province,model.city,model.county] forState:UIControlStateNormal];
    if (!self.moduleInfo.districtKey || [self.moduleInfo.districtKey isEqualToString:@""]) {
        self.subDic = @{self.moduleInfo.provinceKey:model.Province,self.moduleInfo.cityKey:model.city};
    } else {
        self.subDic = @{self.moduleInfo.provinceKey:model.Province,self.moduleInfo.cityKey:model.city,self.moduleInfo.districtKey:model.county};
    }

    self.selectButton.titleLabel.numberOfLines = 0;
    self.selectButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.moduleInfo.value = self.subDic;
    [_selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:self.moduleInfo.hint?self.moduleInfo.hint:@"点击选择" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor colorWithHEXRGB:0xc2c2c2] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(0 , 0,SCREEN_WIDTH-30, self.rowH);
        _selectButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_selectButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
@end
