//
//  FormBaseCell.h
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormBaseModel.h"
#import "Masonry.h"
#import "FormObject.h"
#define ContentMargin 8.0*SCREEN_WIDTH_6

NS_ASSUME_NONNULL_BEGIN

@interface FormBaseCell : UITableViewCell
#pragma mark -- 基本字段
//控件类型
@property (nonatomic, copy) NSString *type;
//控件code
@property (nonatomic, copy)  NSString *code;
//控件显示的标题
@property (nonatomic, copy) NSString * label;
//控件的值
@property (nonatomic, strong) id value;
//控件显示的占位值
@property (nonatomic, copy) NSString *placeholder;
//控件显示的上次已选值
@property (nonatomic,assign) BOOL useDefault;
//控件输入值长度最大值
@property (nonatomic, copy) NSString *width;
//是否必填
@property (nonatomic, assign) BOOL required;

@property (nonatomic, copy) NSString *hint;

@property (nonatomic, copy) NSDictionary *config; /*配置信息*/
//需要添加的验证方法
@property (nonatomic, strong) NSMutableArray *validators;
@property (nonatomic, copy) NSString *warningText; /*为空提示语*/
@property (nonatomic, assign) BOOL readonly; //用户不可交互
@property (nonatomic, assign) BOOL unSubmit; //不需要提交
@property (nonatomic, assign) BOOL hiddenSeperate; //是否隐藏分割线
@property (nonatomic, assign) BOOL isHiddenCell; //是否隐藏Cell
@property (nonatomic, assign) BOOL showBottom; //是否有底部空白

//子控件重写, 需调用[super creatUI]
- (void)creatUI;
//组件内容高度 子控件重写
- (CGFloat)defaultHeight;
//组件实际高度 tableView代理使用
- (CGFloat)cellHeight;
//验证值是否有效
- (NSString *)cherkValue;
//获取提交值
- (id)exportValue;
//插入值
- (void)importValue:(NSDictionary *)value;

@property (nonatomic, strong) UILabel *xLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImageView;

//存取上次值
- (void)saveValueWithShowValue:(NSString *)showValue;
- (NSString *)lastShowValue;
- (id)lastSubmitValue;

//初始化完成
- (void)afterCreated;
//显示底部分割线
- (void)setBottomLine:(UIView *)view;
- (instancetype)initWithConfig:(NSDictionary *)config showBottom:(BOOL)showBottom;
//- (void)refreshCurrenCell;

- (UITableView *)tableView;
@end
NS_ASSUME_NONNULL_END
