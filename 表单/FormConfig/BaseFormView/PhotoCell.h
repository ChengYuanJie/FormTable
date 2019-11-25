//
//  PhotoCell.h
//  itfsmlib
//
//  Created by Noah on 16/7/6.
//  Copyright © 2016年 Keyloft.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DeleteImageBlock) ();
@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic,copy) DeleteImageBlock block;
- (void)addView;
- (void)showDel:(BOOL)isShow;
@property (nonatomic,assign) BOOL isRC; // 是否切圆角
- (void)addPic:(id)object isFromNet:(BOOL)isNet;
@end
