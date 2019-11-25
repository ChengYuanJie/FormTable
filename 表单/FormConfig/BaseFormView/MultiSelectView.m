//
//  THSelectButton.m
//  THStandardEdition
//
//  Created by Aaron on 2016/11/1.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "MultiSelectView.h"
@interface MultiSelectView()
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
@implementation MultiSelectView
- (void)creatUI{
//    int count = self.moduleInfo.dataSource.count % 3 ==0 ? self.moduleInfo.dataArray.count / 3 :self.moduleInfo.dataSource.count / 3 + 1;
//    self.rowH = count*44;
//    NSArray *buttonArray = nil;
//    if (self.moduleInfo.dataSource.count != 0) {
//     buttonArray = [self loadButtonsWithCount:self.moduleInfo.dataSource.count];
//    }else{
//        ANLog(@"selectButton 数组个数为0");
//        return;
//    }
//    for (UIButton *button in buttonArray) {
//        [self addSubview:button];
//    }
}
- (NSArray *)loadButtonsWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray array];
    
    NSInteger xNum = 3;
    NSInteger space = 5;
    NSInteger btnWidth = (SCREEN_WIDTH - space * (xNum + 1)) / xNum;
    NSInteger btnHight = 44 - space * 2;
    
    for (int i=0; i<count; i++) {
        int row=i/xNum;//行号
        int loc=i%xNum;//列号
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(space + (space + btnWidth) *loc, space + (space +btnHight) * row, btnWidth, btnHight)];
        [btn setBackgroundImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[self imageWithColor:[UIColor colorWithHEXRGB:0x11b7f3]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:self.moduleInfo.dataArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [array addObject:btn];
    }
    return array.copy;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)buttonAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected == 1) {
        [self.dataArray addObject:sender.titleLabel.text];
    }else{
        [self.dataArray removeObject:sender.titleLabel.text];
    }
    self.moduleInfo.value = @"";
    if (self.dataArray.count == 0) {
        return;
    }
    for (NSString *string in self.dataArray) {
        self.moduleInfo.value = [NSString stringWithFormat:@"%@,%@",self.moduleInfo.value,string];
    }
    self.moduleInfo.value = [self.moduleInfo.value substringFromIndex:1];
    ANLog(@"%@",self.moduleInfo.value);
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
