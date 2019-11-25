//
//  CustomViewController.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "CustomViewController.h"
#import "ModuleRowInfo.h"
#import "FormNumberValidator.h"
#import "FromValueHandelProtocol.h"
#import "ShopInfo.h"
#import "UIViewExt.h"
#import "Database.h"
#import "offlineCaheModel+Factory.h"
#import "AbstractFormModel.h"
#import "FormLocationValidator.h"
#import "FormPhoneValidator.h"
#import "AbstractValueModel.h"
#import "FormConfig.h"
#import "TenantEmployManager.h"
#import "WOUser.h"
#import <Masonry.h>
#ifdef TARGET_PEPSI
#import "PsAgencyModel.h"
#endif
#define  KScreenW   [UIScreen mainScreen].bounds.size.width
#define  KScreenH   [UIScreen mainScreen].bounds.size.height
@interface CustomViewController ()<UIAlertViewDelegate>

@property (nonatomic, copy) NSString *featureCode; //页面样式标识
@property (nonatomic, strong) UIButton *setValue;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign)  BOOL hiddenBottom;
@end

@implementation CustomViewController

- (instancetype)initWithfeatureCode:(NSString *)featureCode
{
    self = [super init];
    if (self) {
        _featureCode = featureCode;
    }
    return self;
}
- (instancetype)initWithFeatureCode:(NSString *)featureCode menu:(MenuModule *)menu
{
    self = [super init];
    if (self) {
        _featureCode = featureCode;
        _menu = menu;
    }
    return self;
}


-(void) updateItemButton
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.submitButton];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)creatTableView
{
    self.tableView = [[CustomTableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH - NAV_HEIGHT) Controller:self formInfo:self.formInfo];
    [self.view addSubview:self.tableView];
    if (!_hiddenBottom){
        self.tableView.height = KScreenH - NAV_HEIGHT - BottomHeight - 64;
        [self.view addSubview:self.bottomView];
    }
}
- (void)creatTableDataSource
{
    self.hiddenBottom = NO;
    if (!self.formContent) {
        if (!self.modelCode){
            self.modelCode =  Code_insert_table;
        }else{
            self.hiddenBottom = YES;
        }
        if (!self.formInfo) {
            self.formInfo = [FormConfig creatFormInfoWithFeatureCode:self.featureCode controller:self];
        }
    }else{
        [self netData];
    }
    //设置标题
    dispatch_async(dispatch_get_main_queue(),^{
        self.title = self.menu.name == nil?self.titleStr:self.menu.name;
        if (self.formContent) {
            self.title = self.formContent[@"title"];
        }
        if (self.hiddenBottom){
            [self updateItemButton];
        }
    });
}
- (void)netData{
    self.hiddenBottom = YES;
    AbstractFormModel *model = [[AbstractFormModel alloc] initWithContent:self.formContent[@"content"] controller:self];
    self.formInfo  = model.formInfo;
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showMessage:@""];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self creatTableDataSource];
        dispatch_async(dispatch_get_main_queue(),^{
        [self creatTableView];
            if(self.netDic){
                [self getTransferValueDictWithNetDic:self.netDic];
                return;
            }
        [self setRowValueWithDic];
        });
    });
}

- (void)getTransferValueDictWithNetDic:(NSDictionary *)dic{
    __weak typeof(self) wself = self;
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.subDic = self.netDic[@"value"];
    model.code = self.netDic[@"code"];
    [MBProgressHUD showMessage:@""];
    [UpdateService requestWith:model httpType:HttpTypeGet success:^(id object){
        wself.transferValueDict = object[@"message"];
        [wself setRowValueWithDic];
    } failure:^(id error) {
        [MBProgressHUD showError:MESSAGE_NoNetwork];
    } unconnection:^(id error) {
        [MBProgressHUD showError:MESSAGE_NOConection];
    }];
}
- (void)setRowValueWithDic{
    [self.formInfo setRowValues:self.transferValueDict];
    [MBProgressHUD hideHUD];
    [self.tableView reloadData];
}
#pragma  mark--button点击事件
- (void)saveOffLineDataButtonAction{
    [self.view endEditing:YES];
    self.submitButton.enabled = NO;
    NSArray *valueArray = [self.formInfo getValuesRequired:NO];
    if (valueArray.count == 0) {
        self.submitButton.enabled = YES;
        return;
    }
    for (AbstractValueModel *valuemodel in valueArray) {
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
        NSString *guid = [NSUUID getCapitalsUUID];
        if (self.transferValueDict[@"guid"]) {
            guid = self.transferValueDict[@"guid"];
        }
        [mutableDic setObject:guid forKey:@"guid"];
        [mutableDic addEntriesFromDictionary:valuemodel.valueDic];
        NSDictionary *dicValue = mutableDic;
        NSDictionary *dic=@{@"code":@"sfa_store",
                            @"data":dicValue};
        offlineCaheModel *model = [[offlineCaheModel alloc] init];
        model.code = self.modelCode;
        model.targetController = NSStringFromClass([self class]);
        model.showname = self.title;
        model.comments = [dicValue[@"name"] isEqualToString:@""]?self.title:dicValue[@"name"];
        model.isOfflineDataVisible = YES;
        model.featureCode = self.featureCode;
        NSTimeInterval  interTime = [DateUtil getNowNetTime];
        model.offlinetime =(double)interTime;
        WOUser * woUser = [WOUser sharedUser];
        offlineCaheModel *saveModel = [offlineCaheModel createOfflineDataWithParamModel:model data:[woUser getParamStringWithObj:dic] dataPicture:valuemodel.fileName];
        if (self.transferValueDict) {
            if (!self.offlineModel) {
                [self insertOfflineData:saveModel];
            }else{
                [self updateOfflineData:saveModel];
            }
        }else{
            [self insertOfflineData:saveModel];
        }
    }
}
//插入草稿箱新数据
- (void)insertOfflineData:(offlineCaheModel *)model{
    [MBProgressHUD showSuccess:@"已储存"];
    [DraftManager saveofflineCaheModelWithOfflineModel:model];
    [self.navigationController popViewControllerAnimated:YES];
}
//更新草稿箱内容
- (void)updateOfflineData:(offlineCaheModel *)saveModel{
    saveModel.uid = self.offlineModel.uid;
    [DraftManager updateDraftDataWithModel:saveModel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)submitButtonAction
{
    [self.view endEditing:YES];
    self.submitButton.enabled = NO;
    NSArray *valueArray = [self.formInfo getValuesRequired:YES];
    if (valueArray.count == 0) {
        self.submitButton.enabled = YES;
        return;
    }
    // 通用code接口
    if (!self.modelCode){
        [self submitNoCodeDataWithValueArray:valueArray];
        return;
    } else if ([self.modelCode isEqualToString:@"pepsi_add_rcd"]) {
        [self submitPepsiData:valueArray];
        return;
    }
    __block BOOL isStop= NO;
    for (AbstractValueModel *valuemodel in valueArray) {
        if (isStop) {
            break;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic addEntriesFromDictionary:valuemodel.valueDic];
        if (!self.transferValueDict) {
            NSString *guid = [NSUUID getCapitalsUUID];
            [dic setObject:guid forKey:@"guid"];
        }else{
            [dic setObject:self.transferValueDict[@"guid"] forKey:@"guid"];
            //新值替换旧值
        }
        NSDictionary *dicValue = dic;
        NSDictionary *subDic;
        if ([self.modelCode isEqualToString:Code_update_table]) {
            subDic = @{@"code":@"sfa_store",
                       @"data":dicValue,
                       @"version":@"get_sfa_store",
                       @"guid":self.transferValueDict[@"guid"]};
        }else{
            [dic setObject:[STANDARD_USER_DEFAULT objectForKey:KEY_USERGUID] forKey:@"creator_id"];
            subDic = @{@"code":@"sfa_store",
                       @"data":dicValue,
                       @"version":@"get_sfa_store"};
        }

        THNetServiceModel *model = [[THNetServiceModel alloc] init];
        model.subDic = subDic;
        model.isSave = YES;
        model.isOffline = YES;
        model.fileName = valuemodel.fileName;
        model.guid = self.transferValueDict[@"guid"];
        model.showname = _menu.name == nil?self.titleStr:_menu.name;
        model.comments = dicValue[@"name"];
        model.locDb = YES;
        model.locTableName = SFA_STORE_TABLE_NAME;
        model.code = self.modelCode;
        if (![model.code isEqualToString:Code_update_table]) {
            model.needAB = YES;
            model.beforeArray = self.formInfo.before?self.formInfo.before:@[@"store_emp"];
        }
        [MBProgressHUD showMessage:@"正在提交请稍候..."];
        __weak typeof(self) wself = self;
        [UpdateService requestWith:model httpType:HttpTypePost success:^(id object){
            [wself updateTransferValueDictValue:dicValue];
            if ([self.modelCode isEqualToString:Code_update_table]) {
                [wself dataSynchronizeInsertDBWithGuid:model.guid code:wself.transferValueDict[@"code"] valueDic:dicValue];
            }else{
                [wself dataSynchronizeInsertDBWithGuid:object[@"message"][@"guid"] code:object[@"message"][@"code"] valueDic:dicValue];
            }
            [DraftManager deleteDraftWithId:wself.offlineModel.uid];
            wself.submitButton.enabled = YES;
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"提交成功！"];
            [wself.navigationController popViewControllerAnimated:YES];
        } failure:^(id error) {
            isStop = YES;
            wself.submitButton.enabled = YES;
            NSString *message = error[@"message"];
            if (!message) {
                message = @"提交失败";
            }
            [MBProgressHUD hideHUD];
            UIAlertViewQuick(@"提示",message, @"确定");
        } unconnection:^(id error) {
            [MBProgressHUD hideHUD];
            isStop = YES;
            wself.submitButton.enabled = YES;
            if (model.isSave) {
            UIAlertViewChoiceTag(1001, @"提示", @"当前无网络，请到 系统设置->离线缓存 查看数据", @[@"确定"], self);
            }

            [DraftManager deleteDraftWithId:wself.offlineModel.uid];
        }];
    }
}
//百事提交
- (void)submitPepsiData:(NSArray *)valueAray {
#ifdef TARGET_PEPSI
    for (AbstractValueModel *valuemodel in valueAray) {
        [MBProgressHUD showMessage:@"正在提交请稍候..."];
        __weak typeof(self) wself = self;
        THNetServiceModel *model = [[THNetServiceModel alloc] init];
        NSMutableDictionary *subDict = [NSMutableDictionary dictionaryWithDictionary:valuemodel.valueDic];        
        [subDict setObject:[UserInfo shareUserInfo].userGuid forKey:@"saleman_guid"];
        model.subDic = subDict;
        model.tableName = @"sfa_store_peisi";
        model.guid = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [UpdateService insertService:model success:^(id object) {
            dispatch_group_t firstGroup = dispatch_group_create();
            [PsAgencyModel downloadFromNet:firstGroup];
            dispatch_group_notify(firstGroup, dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"提交成功！"];
                [wself.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(id error) {
            wself.submitButton.enabled = YES;
            [MBProgressHUD hideHUD];
            UIAlertViewQuick(@"提示",@"提交失败", @"确定");
        } unconnection:^(id error) {
            wself.submitButton.enabled = YES;
            [MBProgressHUD hideHUD];
            UIAlertViewQuick(@"提示",@"网络连接失败", @"确定");
        }];
        return;
    }
#endif
}
//拜访无code提交
- (void)submitNoCodeDataWithValueArray:(NSArray *)valueAray{
    __block BOOL isStop= NO;
    for (int i = 0; i < valueAray.count; i ++) {
        AbstractValueModel *valuemodel = valueAray[i];
        if (isStop) {
            break;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic addEntriesFromDictionary:valuemodel.valueDic];
        [dic setObject:self.main_guid forKey:@"visit_guid"];
        [dic setObject:self.store_guid forKey:@"store_guid"];
        [dic setObject:[STANDARD_USER_DEFAULT objectForKey:VISIT_STEPS_GUID]  forKey:@"step_guid"];
        [dic setObject:self.step_item_guid forKey:@"step_item_guid"];
        THNetServiceModel *model = [[THNetServiceModel alloc] init];
        model.subDic = @{@"guid":self.formContent[@"action_guid"],@"data":dic};
        model.code = @"submit_visit_form";
        model.fileName = valuemodel.fileName;
        model.isSave = YES;
        model.showname = @"拜访任务";
        model.comments = self.formContent[@"title"];
        [MBProgressHUD showMessage:@"正在提交请稍候..."];
        __weak typeof(self) wself = self;
        [UpdateService requestWith:model httpType:HttpTypePost success:^(id object) {
            wself.submitButton.enabled = YES;
            if (i == valueAray.count - 1) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"提交成功"];
                [self goBack];
            }
        } failure:^(id error) {
            isStop = YES;
            wself.submitButton.enabled = YES;
            NSString *message = error[@"message"];
            if (!message) {
                message = @"网络环境差";
            }
            UIAlertViewQuick(@"提示",message, @"确定");
            [MBProgressHUD hideHUD];
            [wself.navigationController popViewControllerAnimated:YES];
        } unconnection:^(id error) {
            wself.submitButton.enabled = YES;
            if (i == valueAray.count - 1) {
                [SVProgressHUD dismiss];
                UIAlertViewChoiceTag(1002, @"提示", @"当前无网络，请到系统设置->离线缓存 查看数据", @[@"确定"], self);
            }
        }];
    }
}
// 更新transferValueDict内容
- (void)updateTransferValueDictValue:(NSDictionary *)dic{
    NSArray *keyArray = self.transferValueDict.allKeys;
    NSMutableDictionary *dicValue = [[NSMutableDictionary alloc] init];
    [dicValue addEntriesFromDictionary:self.transferValueDict];
    for (NSString *keyStr in dic) {
        if ([keyArray  containsObject:keyStr]) {
            [dicValue setObject:dic[keyStr] forKey:keyStr];
        }
    }
    self.transferValueDict = dicValue;
    if ([self.delegate respondsToSelector:@selector(UIViewControllerDidDisappear:andMessageObject:)]) {
        [self.delegate UIViewControllerDidDisappear:self andMessageObject:self.transferValueDict];
    }
}

#pragma mark-- 本地数据库回写插入更新操作
-(void)dataSynchronizeInsertDBWithGuid:(NSString *)guid code:(NSString *)code valueDic:(NSDictionary *)dicValue{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic addEntriesFromDictionary:dicValue];
    [dataDic removeObjectForKey:@"citycode"];
    [dataDic setObject:guid forKey:@"guid"];
    NSString *codetype = [TenantEmployManager shareTenantEmployManager].auto_code;
    if (codetype.length > 0 && ![codetype isEqualToString:@"null"]){
        [dataDic setObject:code?code:@"" forKey:@"code"];
    }
    for (NSString *cusKey in self.formInfo.customKeyAry) {
        [dataDic removeObjectForKey:cusKey];
    }
    NSString *sqlStr = [[Database shareDB] insertSqlWithDict:dataDic WithTableName:self.formInfo.tableName];
    if ([[Database shareDB] insertIntoSqliteWithSqlString:sqlStr]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_LOCAL_STORE_TABLE" object:dataDic];
    }
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- 64 - NAV_HEIGHT - BottomHeight, SCREEN_WIDTH, 64)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.layer.cornerRadius = 12.f;
        saveBtn.layer.masksToBounds = YES;
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [saveBtn setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHEXRGB:0xfecb2f]] forState:UIControlStateNormal];
        [saveBtn setTitle:@"暂存" forState:UIControlStateNormal];
        saveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        saveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [saveBtn setImage:[UIImage imageNamed:@"本地暂存"] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveOffLineDataButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:saveBtn];
        [saveBtn makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView).offset(10);
            make.left.equalTo(_bottomView).offset(20);
            make.width.mas_equalTo(116*SCREEN_WIDTH_RATIO);
            make.height.mas_equalTo(44);
        }];

        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setBackgroundImage:[UIColor imageWithColor:[UIColor tintColor]] forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 12.f;
        submitBtn.layer.masksToBounds = YES;
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [submitBtn setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHEXRGB:0x136cd5]] forState:UIControlStateHighlighted];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        submitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        submitBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [submitBtn setImage:[UIImage imageNamed:@"成功"] forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomView addSubview:submitBtn];
        [submitBtn makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView).offset(-20);
            make.width.mas_equalTo(155*SCREEN_WIDTH_RATIO);
            make.height.mas_equalTo(44);
            make.top.equalTo(_bottomView).offset(10);
        }];
        
    }
    return _bottomView;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.frame = CGRectMake(0, 0, 40, 40);
        [_submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.formInfo.delegate  = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removePickViewFromWindou" object:nil];
}
-(void)goBack{
    if (self.delegate) {
        [self.delegate UIViewControllerDidDisappear:self andMessageObject:self.formContent];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 1001)) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 1002){
        [self goBack];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
