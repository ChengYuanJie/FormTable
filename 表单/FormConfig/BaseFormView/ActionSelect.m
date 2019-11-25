
//
//  ActionSelect.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/17.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "ActionSelect.h"
@interface ActionSelect()<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
// 选择的数据
@property (nonatomic, strong) NSArray * selectArray;
// IOS8以后系统版本使用，用于推出日期选择控件
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *certainButton;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, copy)   NSString *starValue; //判断是否为初始值


@end
@implementation ActionSelect
+ (instancetype)shareAction
{
    static id _shareAction = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareAction = [[self alloc]init];
    });
    return _shareAction;
}

- (void)dateActionShowInController:(UIViewController *)controller
                       selectArray:(NSArray *)selectArray
                     CanSelectLast:(BOOL)canSelect
                          complete:(void (^)(NSString *))complete
{
    _complete = [complete copy];
    self.controller = controller;
    self.selectArray = selectArray;
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:selectArray];
    self.starValue = selectArray[0];
    [self setupUI];
}
- (void)setupUI
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
    if (IOS_VERSION >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self)wself = self;
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [wself action];
        }];
        alertController.popoverPresentationController.sourceView = self.controller.view;
        alertController.popoverPresentationController.sourceRect = self.controller.view.frame;
        [alertController addAction:alertAction];
        [alertController.view addSubview:self.pickView];
        [wself.controller presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet showInView:self.controller.view];
        [actionSheet addSubview:self.pickView];
    }
}
#pragma mark--buttonAction
- (void)buttonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0,SCREEN_WIDTH - 200 , SCREEN_HEIGHT, 200)  ;
    } completion:nil];
    self.valueLabel.text = self.dataList[0];
}

- (void)certainButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    } completion:nil];
    if ([self.valueLabel.text isEqualToString:self.starValue]) {
    }else{
        
    }
}

- (void)cancleButtonAction:(UIButton *)sender
{
    self.valueLabel.text = @"请选择性别";
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    } completion:nil];
}
#pragma mark-- pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataList.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dataList[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.starValue = self.dataList[row];
}
#pragma mark 点击确定后调用的方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self action];
}

- (void)action
{
    //有时差问题
    
    
    if (_complete) {
        _complete(self.starValue);
    }
}

#pragma mark -- lazy
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:self.cancleButton];
        [_bgView addSubview:self.certainButton];
        _bgView.backgroundColor = [UIColor orangeColor];
        [_bgView addSubview:self.pickView];
    }
    return _bgView;
}
- (UIButton *)certainButton
{
    if (!_certainButton) {
        _certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certainButton setTitle:@"确定" forState:UIControlStateNormal];
        _certainButton.frame = CGRectMake(SCREEN_WIDTH - 50, 10/667.f*SCREEN_WIDTH, 40, 20);
        [_certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_certainButton addTarget:self action:@selector(certainButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certainButton;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleButton.frame = CGRectMake(10/375.f*SCREEN_WIDTH, 10/667.f*SCREEN_HEIGHT, 40, 20);
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
- (UIPickerView *)pickView
{
    if (!_pickView ) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40/667.f*SCREEN_HEIGHT, SCREEN_WIDTH, 150 - 40/667.f*SCREEN_HEIGHT_RATIO)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

@end
