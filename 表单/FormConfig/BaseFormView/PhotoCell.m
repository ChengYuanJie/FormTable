//
//  PhotoCell.m
//  itfsmlib
//
//  Created by Noah on 16/7/6.
//  Copyright © 2016年 Keyloft.com. All rights reserved.
//

#import "PhotoCell.h"
#import "Util.h"
#import "UIImageView+WebCache.h"
#import "NetLinkConfigManager.h"
@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) CAShapeLayer* borderLayer;

@end

@implementation PhotoCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.contentView addSubview:self.imgView];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.userInteractionEnabled = YES;
    self.iconView.userInteractionEnabled = YES;
    self.imgView.frame = self.contentView.frame;
}
- (IBAction)closeBtn:(id)sender {
    if (self.block) {
        self.block();
    }
}
- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        _imgView.layer.borderColor = [HUI_COLOR CGColor];
        _imgView.layer.borderWidth = 1;
        _imgView.layer.cornerRadius = 12;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}
-(void)setIsRC:(BOOL)isRC{
    _isRC = isRC;
    if(_isRC){
        _imgView.layer.borderColor = [[UIColor clearColor] CGColor];
        _imgView.layer.borderWidth = 0;
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = NO;
    }
}
- (void)addView {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.layer.borderColor = [HUI_COLOR CGColor];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 12;
    view.layer.masksToBounds = YES;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 18)/2, (self.frame.size.height - 18)/2, 18, 18)];
    img.image = GetImage(@"+");
    [view addSubview:img];
    [self insertSubview:view atIndex:0];
}
- (void)addPic:(id)object isFromNet:(BOOL)isNet{
    if ([object isKindOfClass:[UIImage class]]){
        self.imgView.image = object;
    } else if ([object isKindOfClass:[NSString class]]){
        if (isNet) {
            if ([object hasPrefix:@"http"]) {
                [self.imgView sd_setImageWithURL:[NSURL URLWithString:object] placeholderImage:[UIImage imageNamed:@"defaultpic"] options:SDWebImageRefreshCached];
            } else {
                UIImage *imageObj = [UIImage imageWithData:[ImageCacheTools getImageDataWithKey:object]];
                self.imgView.image = imageObj;
            }
        }
    }else if ([object isKindOfClass:[NSData class]]){
        self.imgView.image = [UIImage imageWithData:object];
    }
    [self.contentView addSubview:self.imgView];
}
+ (UIImage *)blh_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)showDel:(BOOL)isShow {
    self.closeBtn.hidden = !isShow;
    [self.contentView bringSubviewToFront:self.closeBtn];
}


@end
