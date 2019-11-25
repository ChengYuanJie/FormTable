
//
//  THLocationCell.m
//  THStandardEdition
//
//  Created by Aaron on 16/9/26.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "LocateView.h"
#import "AppDelegate.h"
#import "AMLoctionManager.h"
#import "DateUtil.h"
#import <Masonry.h>
/*
 今天妆令人特别着迷
 Oh 我说 baby
 出门前换上新的心情
 Oh 我的 lady
 你喜欢有小情绪
 像晴天的乌云
 头发长见识短的惊奇
 表情丰富令人着迷
 你的一切我都好奇像秘密
 安全带系好带你去旅行
 穿过风和雨
 我想要带你去浪漫的土耳其
 然后一起去东京和巴黎
 其实我特别喜欢迈阿密
 和有黑人的洛杉矶
 其实亲爱的你不必太过惊奇
 一起去繁华的上海和北京
 还有云南的大理保留着回忆
 这样才有意义
 
 我想要带你去浪漫的土耳其
 然后一起去东京和巴黎
 其实我特别喜欢迈阿密
 和有黑人的洛杉矶
 其实亲爱的你不必太过惊奇
 一起去繁华的上海和北京
 还有云南的大理保留着回忆
 这样才有意义
 还有云南的大理保留着回忆
 **/
@interface LocateView()

@property (nonatomic, strong) UILabel *titlelabel;
@end
@implementation LocateView

- (void)creatUI
{
    self.rowH = 60.f + self.bottomH;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20/375.f*SCREEN_WIDTH, 0, 35*SCREEN_WIDTH_RATIO, 60.f)];
    label.text = @"地址:";
    label.font = [UIFont systemFontOfSize:14];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    self.titlelabel = label;
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font = [UIFont systemFontOfSize:14];
    _locationLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _locationLabel.text = @"位置刷新中";
    _locationLabel.numberOfLines = 0;
    
    [self.contentView addSubview:_locationLabel];
    [self.contentView addSubview:self.refreshButton];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(36);
        make.right.equalTo(self).offset(-10);
    }];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.right.mas_equalTo(self.refreshButton.left).offset(-10);
        make.left.mas_equalTo(label.right);
    }];

    self.subDic = [NSMutableDictionary dictionary];
    NSMutableArray *classArrray = [NSMutableArray array];
    NSString *clssStr = nil;
    for (UIViewController *controller in [AppDelegate shareAppDelegate].pushNavController.viewControllers) {
        clssStr = NSStringFromClass([controller class]);
        [classArrray addObject:clssStr];
    }
    if ([self.moduleInfo.isLocation isEqualToString:@"1"]) {
        [self refreshLocation];
    }
}
-(void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
- (id)createInstanceByClassName:(NSString *)className
{
    NSBundle *bundle = [NSBundle mainBundle];
    Class aclass = [bundle classNamed:className];
    return [[aclass alloc]init];
}

- (void)buttonAction:(UIButton *)sender
{
    self.noSet = NO;
    [self.subDic removeAllObjects];
    [self refreshLocation];
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    self.noSet = YES;
    [self.refreshButton.layer removeAllAnimations];
    for (NSString *key in valueDic.allKeys) {
        if ([key isEqualToString:[NSString stringWithFormat:@"address"]]) {
            self.locationLabel.text = valueDic[key];
            [_subDic setValue:valueDic[key] forKey:key];
        }
        if ([key isEqualToString:[NSString stringWithFormat:@"lon"]]) {
            [_subDic setValue:valueDic[key] forKey:key];
        }
        if ([key isEqualToString:[NSString stringWithFormat:@"lat"]]) {
            [_subDic setValue:valueDic[key] forKey:key];
        }
    }
    self.moduleInfo.value = self.subDic;
}

- (void)refreshLocation
{
    
    [self startAnimation];
    NSString *addStr  = nil;
    NSString *lngStr  = nil;
    NSString *latStr  = nil;
    NSString *proStr  = nil;
    NSString *disStr  = nil;
    NSString *strStr  = nil;
    NSString *conStr  = nil;
    NSString *typeStr  = nil;
    NSString *timeStr  = nil;
    
    if (![self.moduleInfo.key isEqualToString:@"dingwei"]) {
        addStr = [NSString stringWithFormat:@"%@_address",self.moduleInfo.key];
        lngStr = [NSString stringWithFormat:@"%@_lng",self.moduleInfo.key];
        latStr = [NSString stringWithFormat:@"%@_lat",self.moduleInfo.key];
        proStr = [NSString stringWithFormat:@"%@_province",self.moduleInfo.key];
        disStr = [NSString stringWithFormat:@"%@_district",self.moduleInfo.key];
        conStr = [NSString stringWithFormat:@"%@_county",self.moduleInfo.key];
        strStr = [NSString stringWithFormat:@"%@_street",self.moduleInfo.key];
        typeStr = [NSString stringWithFormat:@"%@_type",self.moduleInfo.key];
        timeStr = [NSString stringWithFormat:@"%@_time",self.moduleInfo.key];
    }else{
        addStr = @"address";
        lngStr = @"lon";
        latStr = @"lat";
        
    }
    double stratTime = [DateUtil getNowNetTime];
    [[AMLoctionManager shareAMLoctionManager] startLocateForegroundWithFinished:^(AMLoction *location) {
        if (location) {
            if (!location.latitude) {
                location.latitude = @"";
            }
            if (!location.longtitude) {
                location.longtitude = @"";
            }
            self.location = location;
            if (!self.noSet) {
                self.locationLabel.text = location.address;
            }else{
                return;
            }
            double endTime = [DateUtil getNowNetTime];
            if (![self.moduleInfo.key isEqualToString:@"dingwei"]) {
                [_subDic setValue:location.address forKey:addStr];
                [_subDic setValue:location.longtitude forKey:lngStr];
                [_subDic setValue:location.latitude forKey:latStr];
                [_subDic setValue:location.province forKey:proStr];
                [_subDic setValue:location.city forKey:disStr];
                [_subDic setValue:location.district forKey:conStr];
                [_subDic setValue:location.street forKey:strStr];
                [_subDic setValue:[NSString stringWithFormat:@"%.lf",endTime - stratTime] forKey:timeStr];
                [_subDic setValue:@"GPS" forKey:typeStr];
            }else{
                [_subDic setValue:location.address forKey:addStr];
                [_subDic setValue:location.longtitude forKey:lngStr];
                [_subDic setValue:location.latitude forKey:latStr];
                [_subDic setValue:location.province forKey:@"province"];
                [_subDic setValue:location.city forKey:@"city"];
                [_subDic setValue:location.district forKey:@"county"];
            }
            self.moduleInfo.value =_subDic;
            [self.refreshButton.layer removeAllAnimations];
        }
    } isShowAlert:NO];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setImage:[UIImage imageNamed:@"刷新1"] forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}
// button旋转
- (void)startAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = 0;
    animation.duration = 2;
    animation.toValue =[NSNumber numberWithFloat: M_PI * 2.0 ];
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 500;
    [self.refreshButton.layer addAnimation:animation forKey:nil];
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titlelabel.text = titleStr;
}
@end
