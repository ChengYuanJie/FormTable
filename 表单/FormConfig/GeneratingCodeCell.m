//
//  GeneratingCodeCell.m
//  THStandardEdition
//
//  Created by Aaron on 2019/6/25.
//  Copyright © 2019年 程元杰. All rights reserved.
//

#import "GeneratingCodeCell.h"
#import "UIImage+Bitmap.h"
#import "LLPhotoBrowser.h"
@interface GeneratingCodeCell()<LLPhotoBrowserDelegate>
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) NSArray *imgs;
@end
@implementation GeneratingCodeCell

- (void)creatUI{
    [self addSubview:self.leftlab];
    [self addSubview:self.codeImgView];
    UIImage *cImage = [UIImage qrCodeImageWithInfo:self.moduleInfo.value centerImage:nil width:120];
    if (cImage) {
        self.imgs = @[cImage];
    }
    [self.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftlab);
        make.left.equalTo(self.leftlab.right).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(120);
    }];
    self.codeImgView.image = cImage;
    self.rowH = 140;
}
- (UILabel *)leftlab{
    if (!_leftlab) {
        _leftlab = [[UILabel alloc] init];
        _leftlab.numberOfLines = 0;
        [_leftlab sizeToFit];
        _leftlab.font = Fount14;
        _leftlab.text = self.moduleInfo.label;
    }
    return _leftlab;
}
- (UIImageView *)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
        _codeImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSize:)];
        [_codeImgView addGestureRecognizer:tap];
    }
    return _codeImgView;
}
#pragma 查看产品图片
- (void)changeSize:(UITapGestureRecognizer *)sender {
    if (self.imgs.count == 0)return;
    // 1 初始化
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc]init];
    // 2 设置代理
    photoBrowser.delegate = self;
    // 3 设置当前图片
    photoBrowser.currentImageIndex = 0;
    // 4 设置图片的个数
    photoBrowser.imageCount = self.imgs.count;
    // 5 设置图片的容器
    photoBrowser.sourceImagesContainerView = [AppDelegate shareAppDelegate].pushNavController.visibleViewController.view;
    // 6 展示
    [photoBrowser show];
}
// 代理方法 返回图片URL
- (id)photoBrowser:(LLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return self.imgs[index];
}
- (UIImage *)photoBrowser:(LLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return nil;
}

@end
