//
//  THTakePhotoCell.h
//  director
//
//  Created by Aaron on 16/7/26.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "CustomButton.h"
#import "PhotoView.h"
@interface PhotoTaker : FormBaseTableViewCell<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
/**
 *  是否使用前置摄像头拍照
 */
@property (nonatomic, assign) BOOL useFrontCamera;
@property (nonatomic, weak) PhotoView *photoView;
@property (nonatomic, strong) CustomButton *button;
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic,assign) NSInteger maxPic;
@property (nonatomic,assign) BOOL hiddenBot;
@property (nonatomic,copy) NSString *title;
- (void)setImgData:(NSString *)imgs;
@end
