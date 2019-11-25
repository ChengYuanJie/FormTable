//
//  ModuleRowInfo.h
//  itfsm-Project
//
//  Created by Aaron on 16/7/9.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FormValidatorProtocol.h"
#import "FormValidationStatus.h"
#import "QueryNet.h"
typedef void(^ButtonClick)(id);
typedef void(^ExtentionStrBlock)(id);
typedef void(^ExctuedBlock)(void);
@interface ModuleRowInfo : BaseObject
@property (nonatomic,copy) ButtonClick btnBlock;
@property (nonatomic,copy) ExtentionStrBlock exBlock;
@property (nonatomic,copy) ExctuedBlock exctuedBlock; //
@property (nonatomic,copy) NSString *extentionStr;
//用户不可交互
@property (nonatomic, assign) BOOL unInteractionEnabled;
//不需要提交
@property (nonatomic, assign) BOOL unSubmit;
@property (nonatomic,strong) NSArray *noShowKeys; //下拉菜单不需要展示的数据
@property (nonatomic,assign) BOOL hiddenSeperate; //是否隐藏分割线
/**
 * 存储每列中的单元格信息
 * AbstractCell array * cellList.count 可以看
 做是每一行cell 有几列控件
 */
@property (nonatomic, strong) NSArray * cellList;
@property (nonatomic,assign) CGFloat rowH;
@property (nonatomic,assign) BOOL isHiddenCell;
@property (nonatomic,assign) BOOL showBottom;
/**
 * 存储每列中的单元格信息
 * AbstractCell array
 * cellList.count 可以看做是每一行cell 有几列控件
 */

// 当前页面控制器
@property (nonatomic, weak) id controller;
/**
 * 行控件类型
 */
@property (nonatomic, copy) NSString * viewType;

/**
 *  本地数据--数组类型
 */
@property (nonatomic, strong) NSArray *dataSource;
/**
 * row标题
 */
@property (nonatomic, copy) NSString * label;

/**
 *  row tag值
 */
//@property (nonatomic, copy) NSString * tag;

/**
 *  标签默认显示内容
 */
@property (nonatomic, copy) NSString * hint;
/**
 *  搜索框文案
 */
@property (nonatomic, copy) NSString * searchHint;
/**
 *  textfiled输入长度
 */
@property (nonatomic, copy) NSString * width;
/**
 *  分组属性：数字型，相同的为一组
 */
@property (nonatomic, copy) NSString * section;
/**
 * @pamra 是否可以与其它控件联动,默认为NO
 */
@property (nonatomic, assign) BOOL changeAware;
/**
 *  @pamra 可以发生联动的数组   存的是cell对应的tag值
 */
@property (nonatomic, strong) NSMutableArray *chainArray;
/**
 *  @pamra 可以发生联动的数组
 *  联动方法
 *  1、loadData（刷新数据）
 *  2、eval(表达式计算):表达式
 */
@property (nonatomic, copy) NSString *responseFunc;
/**
 *  @pamra 联动目标key值集合,逗号分隔
 */
@property (nonatomic, copy) NSString *responseKeys;


/**
 *value ---cell
 */
@property (nonatomic, strong) id value;

@property (nonatomic,copy) NSString *btnShowValue;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *labColor;
@property (nonatomic, strong) UIColor *valueColor;
@property (nonatomic, strong) NSDictionary *valueDic;
@property (nonatomic, assign) BOOL alignmentRight;
//控件显示的默认值
@property (nonatomic, strong) NSString *defalutValue;

//想后台提交数据时所用的key
@property (nonatomic, copy)  NSString *key;
/**
 * 需要添加的验证方法
 */
@property (nonatomic, strong) NSMutableArray *validatorArray;
/**
 * @pamra 是否需要写入数据库
 * @return YES or NO 默认是yes
 */

//查询表名
//@property (nonatomic, strong) NSString *tableName;

//是否必填（true/false），默认为false
@property (nonatomic, assign) BOOL required;
//需要从数据库中查询的字段
@property (nonatomic, strong) NSString *sql;
//需要从数据库中查询的字段
@property (nonatomic, strong) NSString *sqlWhere;
//需要从数据库中查询的所需值
@property (nonatomic, strong) NSString *sqlValue;
//是否默认上次选择
@property (nonatomic,assign) BOOL useDefault;

@property (nonatomic,copy) NSString *formName;
/* 需要从数据库中查询的方式
 * 1为本地查询
 * 2为实时查询
 * 4queryNet 查询
 */
@property (nonatomic, strong) NSString *qurayType;
@property (nonatomic,strong) QueryInfo *queryInfo;

// 图片类
/**
 *  @pamra 是否可以选择图片    默认为No
 */
@property (nonatomic, assign) BOOL canSelect;
/**
 *  @pamra 是否可以修改图片   默认为No
 */
@property (nonatomic, assign) BOOL canModify;
/*
 是否是展示网络图片
 */
@property (nonatomic,assign) BOOL isNetPic;
/**
 *  @pamra 选择相机类型
 */
@property (nonatomic, strong) NSString *cameraType;


/**
 *  @pamra 最大拍照数  默认为5张
 */
@property (nonatomic, assign) NSInteger maxPicCount;
/**
 * @pamra 是否自动拍照
 */
@property (nonatomic,copy) NSString *isAutoTakeImg;
@property (nonatomic, assign) BOOL isStore;

//  空值验证时提示语，默认为：Label + “不能为空”
@property (nonatomic, copy) NSString *emptyMsg;
/**
 *  验证信息字符串格式：(验证器编码(参数*):提示消息字符串)
 */
@property (nonatomic, copy) NSString *validate;
//  字符串长度限制（textFiled）”
@property (nonatomic, assign) NSInteger limitLength;

/**
 组件输入类型:
 1、NORMAL(普通)
 2、NUMBER(数字)
 3、EMAIL(电子邮件)
 */
@property (nonatomic, copy) NSString *inputType;
@property (nonatomic, copy) NSString *type; // 一般为组件值的类型

// ********** 定位组件LocateView **************//

@property (nonatomic, copy) NSString *locType; //定位类型
@property (nonatomic, copy) NSString *waitSeconds; //定位等待时间
@property (nonatomic, copy) NSString *fieldLng; // 经度名字 默认lng
@property (nonatomic, copy) NSString *fieldLat; // 纬度名字 Lat
@property (nonatomic, copy) NSString *fieldLocAddress; // 中文地址字段名，默认loc_address
@property (nonatomic, copy) NSString *fieldLocType; // 定位类型字段名，默认loc_type
@property (nonatomic, assign) NSInteger fieldLocTime;  // 定位时间字段名，默认loc_time，长整型
@property (nonatomic, copy) NSString *isLocation; //默认是需要定位
// ********** 定位组件LocateMapCell **************//
@property (nonatomic, assign) BOOL isCanChoose; //是否可选地址，默认NO;
@property (nonatomic, assign) BOOL isShowMap; //是否显示地图，默认YES;
@property (nonatomic, assign) BOOL haveCityCode; //是否需要citycode;
// ********** 图片操作组件PhotoTaker **************//
/**
 *   水印类型(支持定制扩展)(后台Web应用不支持)
 *   1、TYPE1:（2行：时间+地址）
 */
@property (nonatomic, copy) NSString *waterPrint;
@property (nonatomic, copy) NSString *waterPrintColor; // 水印颜色:RGB字符串表示

// ********** 单选组件(跳转界面后选择) ExpandSelectView **************//

@property (nonatomic, copy) NSString *title; //弹出框标题，默认为“请选择”
/**
 *  1、数据关联的数据库表名（字符串格式，本地查询数据用）
 *  2、网络交互model（字符串格式，网络查询数据用，优先级高于本地查询）
 *  3、数据集(ID|Name,ID|Name)
 */
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *idKey; // 非SET数据集时获取信息ID时所用键值，默认为id
@property (nonatomic, copy) NSString *nameKey; // 非SET数据集时获取信息名称时所用键值，默认为name
@property (nonatomic,assign) BOOL noAssembleDictValue; //是否组装字典类型的值 默认未组装
// ********** 开始结束日期选择组件(StartEndDateView) **************//
@property (nonatomic, copy) NSString *maxSpan; // 最大间隔天数，为0或空则不控制
@property (nonatomic, copy) NSString *maxDate; // 最大日期，长整型
@property (nonatomic, strong) NSDate *defultDate;
@property (nonatomic, copy) NSString *fieldStartDate; // 开始时间对应字段，默认为：sartDate
@property (nonatomic, copy) NSString *fieldEndDate;  //结束时间对应字段，默认为：endDate
@property (nonatomic, copy) NSString *startYear; // 开始时间对应字段，默认为：sartDate
@property (nonatomic, copy) NSString *endYear;  //结束时间对应字段，默认为：endDate

//DatePicker 最小日期
@property (nonatomic, assign) NSTimeInterval minDate;
//DatePicker 是否有最大日期
@property (nonatomic, assign) BOOL isMaxDate;
@property (nonatomic, assign) BOOL isMinDate;
// ********** 语音组件(VoiceView) **************//

@property (nonatomic,copy) NSString *maxSeconds;
// ********** 视频组件(VideoView) **************//

@property (nonatomic,copy) NSString *maxSize;

//省市区所用key
@property (nonatomic,copy) NSString *provinceKey;
@property (nonatomic, copy) NSString *province;
@property (nonatomic,copy) NSString *cityKey;
@property (nonatomic,copy) NSString *districtKey;
- (void)addValidator:(id<FormValidatorProtocol>)validator;
-(FormValidationStatus *)doValidation;
@end
