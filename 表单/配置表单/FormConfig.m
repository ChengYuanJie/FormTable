


//
//  FormConfig.m
//  THStandardEdition
//
//  Created by Aaron on 2017/9/19.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "FormConfig.h"
#import "FormLocationValidator.h"
#import "TenantEmployManager.h"
#import "Database.h"
#import "CustomViewController.h"
@interface FormConfig()
@property (nonatomic, weak) UIViewController *controller;
@end
@implementation FormConfig

+(FormInfo *)creatFormInfoWithFeatureCode:(NSString *)featureCode controller:(UIViewController *)controller{
    return [FormConfig creatForm:featureCode controller:controller];
}
+ (FormInfo *)creatForm:(NSString *)featureCode controller:(UIViewController *)controller{
    if ([featureCode isEqualToString:@"sale/mdcj"]){
        NSString *codetype = [TenantEmployManager shareTenantEmployManager].auto_code;
        if (codetype.length > 0 && ![codetype isEqualToString:@"null"]){
            return [FormConfig formInfoModelNoCodeWithController:controller];
        }else{
            return [FormConfig formInfoModelHaveCodeWithController:controller];
        }
    }else if ([featureCode isEqualToString:@"sale/ybyn_mdcj"]){
        return [self creatYBYNForm:controller];
    }else if ([featureCode isEqualToString:@"pepsi_add_rcd"]) {
        return [self creatPepsiForm:controller];
    }else if ([featureCode isEqualToString:@"sale/ygf_mdcj"]) {
        return [self ygfFormInfoModelWithcontroller:controller];
    }else {
        return [FormConfig formInfoModelWithcontroller:controller];
    }
}
/**
 * @普通新增门店模型
 */
+(FormInfo *)formInfoModelWithcontroller:(UIViewController *)controller{
    
    FormInfo *form = [[FormInfo alloc] init];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"门店名称";
    model.hint = @"请填写门店名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"门店店主";
    modela.hint = @"请填写店主名称";
    modela.controller = controller;
    modela.key = @"master";
    modela.viewType = @"TextEdit";
    modela.required = YES;
    modela.width = @"20";
    [section addFormRow:modela];
    
    
    ModuleRowInfo *model1 = [[ModuleRowInfo alloc] init];
    model1.label = @"门店编码"; // label
    model1.hint = @"请填写门店编码";
    model1.viewType = @"TextEdit";
    model1.controller = controller; //
    model1.key = @"code";
    model1.required = YES;
    model1.width = @"12";
    [section addFormRow:model1];
    
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"所属渠道"; // label
    model2.hint = @"请选择";
    model2.searchHint = @"请填写渠道名称";
    model2.viewType = @"TreeSelectView";
    model2.controller = controller; //
    model2.key = @"channel_guid";
    model2.sql = @"name";
    model2.required = YES;
    model2.qurayType = @"1";
    model2.tableName = @"store_channel_inc";
    [section addFormRow:model2];
    
    ModuleRowInfo *modelDept = [[ModuleRowInfo alloc] init];
    modelDept.label = @"所属部门"; // label
    modelDept.hint = @"请选择";
    modelDept.searchHint = @"请填写部门名称";
    modelDept.viewType = @"TreeSelectView";
    modelDept.controller = controller; //
    modelDept.key = @"dept_guid";
    modelDept.sql = @"name";
    modelDept.required = YES;
    modelDept.qurayType = @"1";
    modelDept.tableName = @"dept_info_inc";
    [section addFormRow:modelDept];
    
    ModuleRowInfo *model41 = [[ModuleRowInfo alloc] init];
    model41.label = @"税率%";
    model41.hint = @"请填写税率";
    model41.controller = controller;
    model41.required = YES;
    model41.key = @"tax_rate";
    model41.viewType = @"TextEdit";
    model41.inputType = @"NUMBER";
    model41.width = @"5";
    [section addFormRow:model41];
    
    
    ModuleRowInfo *cuModel = [[ModuleRowInfo alloc] init];
    cuModel.label = @"所属客户"; // label
    cuModel.hint = @"请选择";
    cuModel.viewType = @"THSelectView";
    cuModel.controller = controller; //
    cuModel.searchHint = @"请填写客户名称";
    cuModel.key = @"customer_guid";
    cuModel.sql = @"name";
    cuModel.required = NO;
    cuModel.qurayType = @"1";
    cuModel.tableName = @"store_customer_inc";
    [section addFormRow:cuModel];
    
    ModuleRowInfo *model3 = [[ModuleRowInfo alloc] init];
    model3.label = @"所属部门"; // label
    model3.hint = @"选择部门";
    model3.viewType = @"TreeSelectView";
    model3.controller = controller; //
    model3.key = @"dept_guid";
    model3.required = YES;
    model3.sql = @"name";
    model3.qurayType = @"1";
    model3.tableName = @"dept_info_inc";
    [section addFormRow:model3];
    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"联系方式";
    model4.hint = @"请填写手机号或座机号码";
    model4.controller = controller;
    model4.required = YES;
    model4.key = @"contact";
    [model4 addValidator:[FormPhoneValidator validator]];
    model4.viewType = @"TextEdit";
    [section addFormRow:model4];
    
    ModuleRowInfo *model6 = [[ModuleRowInfo alloc] init];
    model6.label = @"门店类型"; // label
    model6.hint = @"类型";
    model6.viewType = @"THSelectView";
    model6.controller = controller; //
    model6.key = @"property_guid";
    model6.sql = @"name";
    model6.required = YES;
    model6.searchHint = @"请输入门店类型名称";
    model6.qurayType = @"1";
    model6.tableName = @"get_store_property_inc";
    [section addFormRow:model6];
    
    
    ModuleRowInfo *model7 = [[ModuleRowInfo alloc] init];
    model7.label = @"位置";
    model7.required = YES;
    model7.changeAware = YES;
    model7.key = @"dingwei";
    model7.viewType = @"LocateView";
    [model7 addValidator:[FormLocationValidator validator]];
    model7.hint = @"";
    model7.isLocation = @"1";
    model7.controller = controller;
    [section addFormRow:model7];
    
    
    //
    ModuleRowInfo *model8 = [[ModuleRowInfo alloc] init];
    model8.controller = controller;
    model8.key = @"image";
    model8.label = @"拍摄门店照";
    model8.viewType = @"PhotoTaker";
    [section addFormRow:model8];
    
    ModuleRowInfo *modelC = [[ModuleRowInfo alloc] init];
    modelC.controller = controller;
    modelC.key = @"remark";
    modelC.viewType  = @"TextArea";
    modelC.hint = @"请填写备注信息";
    [section addFormRow:modelC];
    [form addSection:section];
    return form;
}
/**
 * @无门店code新增门店模型
 */
+(FormInfo *)formInfoModelNoCodeWithController:(UIViewController *)controller{
    
    FormInfo *form = [[FormInfo alloc] init];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    ModuleRowInfo *model7 = [[ModuleRowInfo alloc] init];
    model7.label = @"位置";
    model7.changeAware = YES;
    model7.isCanChoose = YES;
    model7.isShowMap = YES;
    model7.key = @"dingwei";
    model7.viewType = @"LocateMapCell";
    [model7 addValidator:[FormLocationValidator validator]];
    model7.hint = @"";
    model7.isLocation = @"1";
    model7.controller = controller;
    [section addFormRow:model7];
    
    
    //
    ModuleRowInfo *model8 = [[ModuleRowInfo alloc] init];
    model8.controller = controller;
    model8.key = @"image";
    model8.maxPicCount = 1;
    model8.label = @"门店照片";
    model8.viewType = @"PhotoTaker";
    [section addFormRow:model8];
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"门店名称";
    model.hint = @"请填写门店名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    
    ModuleRowInfo *model6 = [[ModuleRowInfo alloc] init];
    model6.label = @"门店类型"; // label
    model6.hint = @"类型";
    model6.viewType = @"THSelectView";
    model6.controller = controller; //
    model6.key = @"property_guid";
    model6.sql = @"name";
    model6.sqlValue = @"guid";
    model6.formName = @"add_store";
    model6.useDefault = YES;
    model6.required = YES;
    model6.searchHint = @"请输入门店类型名称";
    model6.qurayType = @"1";
    model6.tableName = @"get_store_property_inc";
    [section addFormRow:model6];
    
    
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"所属渠道"; // label
    model2.hint = @"请选择";
    model2.formName = @"add_store";
    model2.searchHint = @"请填写渠道名称";
    model2.viewType = @"TreeSelectView";
    model2.controller = controller; //
    model2.key = @"channel_guid";
    model2.sql = @"name";
    model2.required = YES;
    model2.useDefault = YES;
    model2.qurayType = @"1";
    model2.tableName = @"store_channel_inc";
    [section addFormRow:model2];
    
    ModuleRowInfo *model3 = [[ModuleRowInfo alloc] init];
    model3.label = @"所属区域"; // label
    model3.hint = @"请选择";
    model3.formName = @"add_store";
    model3.searchHint = @"请填写区域名称";
    model3.viewType = @"TreeSelectView";
    model3.controller = controller; //
    model3.key = @"region_guid";
    model3.sql = @"name";
    model3.useDefault = YES;
    model3.required = YES;
    model3.qurayType = @"1";
    model3.tableName = @"get_region_inc";
    [section addFormRow:model3];

    
    ModuleRowInfo *modelDept = [[ModuleRowInfo alloc] init];
    modelDept.label = @"所属部门"; // label
    modelDept.hint = @"请选择";
    modelDept.searchHint = @"请填写部门名称";
    modelDept.viewType = @"TreeSelectView";
    modelDept.controller = controller; //
    modelDept.key = @"dept_guid";
    modelDept.sql = @"name";
    modelDept.qurayType = @"1";
    modelDept.tableName = @"dept_info_inc";
    [section addFormRow:modelDept];

    

    

    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"店主姓名";
    modela.hint = @"请填写店主姓名";
    modela.controller = controller;
    modela.key = @"master";
    modela.viewType = @"TextEdit";
    modela.width = @"20";
    [section addFormRow:modela];

    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"联系方式";
    model4.hint = @"请填写手机号或座机号码";
    model4.controller = controller;
    model4.key = @"contact";
//    [model4 addValidator:[FormPhoneValidator validator]];
    model4.viewType = @"TextEdit";
    [section addFormRow:model4];
    
    
    
 
    [self checkCustomRow:section controller:controller form:form];
    [form addSection:section];
    return form;
}
/**
 * @有code新增门店模型(得益)
 */
+(FormInfo *)formInfoModelHaveCodeWithController:(UIViewController *)controller{
    FormInfo *form = [[FormInfo alloc] init];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    ModuleRowInfo *model7 = [[ModuleRowInfo alloc] init];
    model7.label = @"位置";
    model7.changeAware = YES;
    model7.key = @"dingwei";
    model7.viewType = @"LocateMapCell";
    [model7 addValidator:[FormLocationValidator validator]];
    model7.hint = @"";
    model7.isLocation = @"1";
    model7.isCanChoose = YES;
    model7.isShowMap = YES;
    model7.controller = controller;
    [section addFormRow:model7];
    
    ModuleRowInfo *model8 = [[ModuleRowInfo alloc] init];
    model8.controller = controller;
    model8.key = @"image";
    model8.maxPicCount = 1;
    model8.label = @"门店照片";
    model8.viewType = @"PhotoTaker";
    [section addFormRow:model8];
    
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"门店名称";
    model.hint = @"请填写门店名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    
    ModuleRowInfo *model1 = [[ModuleRowInfo alloc] init];
    model1.label = @"门店编码"; // label
    model1.hint = @"请填写门店编码";
    model1.viewType = @"TextEdit";
    model1.controller = controller; //
    model1.key = @"code";
    model1.required = YES;
    model1.width = @"12";
    [section addFormRow:model1];

    
    ModuleRowInfo *model6 = [[ModuleRowInfo alloc] init];
    model6.label = @"门店类型"; // label
    model6.hint = @"类型";
    model6.viewType = @"THSelectView";
    model6.controller = controller; //
    model6.key = @"property_guid";
    model6.sql = @"name";
    model6.sqlValue = @"guid";
    model6.formName = @"add_store";
    model6.required = YES;
    model6.useDefault = YES;
    model6.searchHint = @"请输入门店类型名称";
    model6.qurayType = @"1";
    model6.tableName = @"get_store_property_inc";
    [section addFormRow:model6];
    
    
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"所属渠道"; // label
    model2.hint = @"请选择";
    model2.formName = @"add_store";
    model2.searchHint = @"请填写渠道名称";
    model2.viewType = @"TreeSelectView";
    model2.controller = controller; //
    model2.key = @"channel_guid";
    model2.sql = @"name";
    model2.required = YES;
    model2.qurayType = @"1";
    model2.useDefault = YES;
    model2.tableName = @"store_channel_inc";
    [section addFormRow:model2];
    
    
    ModuleRowInfo *model3 = [[ModuleRowInfo alloc] init];
    model3.label = @"所属区域"; // label
    model3.hint = @"请选择";
    model3.searchHint = @"请填写区域名称";
    model3.viewType = @"TreeSelectView";
    model3.controller = controller; //
    model3.key = @"region_guid";
    model3.sql = @"name";
    model3.formName = @"add_store";
    model3.required = YES;
    model3.qurayType = @"1";
    model3.useDefault = YES;
    model3.tableName = @"get_region_inc";
    [section addFormRow:model3];

    
    ModuleRowInfo *modelDept = [[ModuleRowInfo alloc] init];
    modelDept.label = @"所属部门"; // label
    modelDept.hint = @"请选择";
    modelDept.searchHint = @"请填写部门名称";
    modelDept.viewType = @"TreeSelectView";
    modelDept.controller = controller; //
    modelDept.key = @"dept_guid";
    modelDept.sql = @"name";
    modelDept.qurayType = @"1";
    modelDept.tableName = @"dept_info_inc";
    [section addFormRow:modelDept];
    

    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"门店店主";
    modela.hint = @"请填写店主姓名";
    modela.controller = controller;
    modela.key = @"master";
    modela.viewType = @"TextEdit";
    modela.width = @"20";
    [section addFormRow:modela];

    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"联系方式";
    model4.hint = @"请填写手机号或座机号码";
    model4.controller = controller;
    model4.key = @"contact";
//    [model4 addValidator:[FormPhoneValidator validator]];
    model4.viewType = @"TextEdit";
    [section addFormRow:model4];
    

    [self checkCustomRow:section controller:controller form:form];
    [form addSection:section];
    return form;
}
/**
 * @ 御宝羊奶新增门店
 */
+(FormInfo *)creatYBYNForm:(UIViewController *)controller{
    FormInfo *form = [[FormInfo alloc] init];
    form.before = @[@"ybyn_store_emp"];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    ModuleRowInfo *model7 = [[ModuleRowInfo alloc] init];
    model7.label = @"位置";
    model7.changeAware = YES;
    model7.key = @"dingwei";
    model7.viewType = @"LocateMapCell";
    [model7 addValidator:[FormLocationValidator validator]];
    model7.hint = @"";
    model7.isLocation = @"1";
    model7.required = YES;
    model7.isCanChoose = YES;
    model7.isShowMap = YES;
    model7.haveCityCode = YES;
    model7.controller = controller;
    [section addFormRow:model7];
    
    ModuleRowInfo *model8 = [[ModuleRowInfo alloc] init];
    model8.controller = controller;
    model8.key = @"image";
    model8.maxPicCount = 1;
    model8.label = @"门店照片";
    model8.viewType = @"PhotoTaker";
    [section addFormRow:model8];
    
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"门店名称";
    model.hint = @"请填写门店名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    
    ModuleRowInfo *model1 = [[ModuleRowInfo alloc] init];
    model1.label = @"门店编码"; // label
    model1.hint = @"请填写门店编码";
    model1.viewType = @"TextEdit";
    model1.controller = controller; //
    model1.key = @"code";
    model1.required = YES;
    model1.width = @"12";
//    [section addFormRow:model1];
    
    ModuleRowInfo *model6 = [[ModuleRowInfo alloc] init];
    model6.label = @"门店类型"; // label
    model6.hint = @"类型";
    model6.viewType = @"THSelectView";
    model6.controller = controller; //
    model6.key = @"property_guid";
    model6.sql = @"name";
    model6.sqlValue = @"guid";
    model6.formName = @"add_store";
    model6.required = YES;
    model6.useDefault = YES;
    model6.searchHint = @"请输入门店类型名称";
    model6.qurayType = @"1";
    model6.tableName = @"get_store_property_inc";
    [section addFormRow:model6];
    
    
    NSArray *channelAry = [[Database shareDB] queryDataFromDBWithSqlString:@"select *from get_channel_inc order by name"];
    NSMutableArray *mutAry = @[].mutableCopy;
    for (NSDictionary *dic in channelAry) {
        [mutAry addObject:dic[@"name"]];
    }
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"所属渠道"; // label
    model2.hint = @"请选择";
    model2.formName = @"add_store";
    model2.searchHint = @"请选择所属渠道";
    model2.viewType = @"CheckboxView";
    model2.controller = controller; //
    model2.key = @"prop_str_2";
    model2.dataSource = mutAry;
    model2.required = YES;
    model2.inputType = @";";
    model2.tableName = @"get_channel_inc";
    [section addFormRow:model2];
    
    
    ModuleRowInfo *model3 = [[ModuleRowInfo alloc] init];
    model3.label = @"所属区域"; // label
    model3.hint = @"请选择";
    model3.searchHint = @"请填写区域名称";
    model3.viewType = @"TreeSelectView";
    model3.controller = controller; //
    model3.key = @"region_guid";
    model3.sql = @"name";
    model3.formName = @"add_store";
    model3.required = YES;
    model3.qurayType = @"1";
    model3.useDefault = YES;
    model3.tableName = @"get_region_inc";
    [section addFormRow:model3];
    
    ModuleRowInfo *modelDept = [[ModuleRowInfo alloc] init];
    modelDept.label = @"所属部门"; // label
    modelDept.hint = @"请选择";
    modelDept.searchHint = @"请填写部门名称";
    modelDept.viewType = @"TreeSelectView";
    modelDept.controller = controller; //
    modelDept.key = @"dept_guid";
    modelDept.sql = @"name";
    modelDept.qurayType = @"1";
    modelDept.tableName = @"dept_info_inc";
    [section addFormRow:modelDept];

    ModuleRowInfo *hzzt = [[ModuleRowInfo alloc] init];
    hzzt.label = @"合作状态";
    hzzt.hint = @"请选择";
    hzzt.controller = controller;
    hzzt.key = @"prop_str_1";
    hzzt.useDefault = YES;
    hzzt.viewType = @"SelectView";
    hzzt.dataSource = @[@"已合作",@"意向"];
    [section addFormRow:hzzt];
    
    ModuleRowInfo *modelF = [[ModuleRowInfo alloc] init];
    modelF.label = @"客户标签";
    modelF.controller = controller;
    modelF.key = @"store_label";
    modelF.viewType = @"THSelectView";
    modelF.qurayType = @"1";
    modelF.sql = @"name";
    modelF.required = YES;
    modelF.sqlValue = @"code";
    modelF.sqlWhere = @"catalog = 'store_label'";
    modelF.tableName = @"get_ls_dms_dict";
    [section addFormRow:modelF];
    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"店主姓名";
    modela.hint = @"请填写店主姓名";
    modela.controller = controller;
    modela.key = @"master";
    modela.viewType = @"TextEdit";
    modela.width = @"20";
    modela.required = YES;
    [section addFormRow:modela];
    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"负责人联系方式";
    model4.hint = @"请填写手机号或座机号码";
    model4.controller = controller;
    model4.key = @"contact";
    model4.required = YES;
    model4.viewType = @"TextEdit";
    model4.inputType = @"PHONE";
    [section addFormRow:model4];
    
    ModuleRowInfo *model5 = [[ModuleRowInfo alloc] init];
    model5.label = @"经销商联系方式";
    model5.hint = @"请填写手机号或座机号码";
    model5.controller = controller;
    model5.key = @"prop_str_3";
    model5.viewType = @"TextEdit";
    [section addFormRow:model5];
    
    ModuleRowInfo *remark = [[ModuleRowInfo alloc] init];
    remark.label = @"门店信息记录";
    remark.hint = @"请填写门店信息记录";
    remark.controller = controller;
    remark.key = @"prop_str_4";
    remark.width = @"200";
    remark.viewType = @"TextArea";
    [section addFormRow:remark];
    
    [self checkCustomRow:section controller:controller form:form];
    [form addSection:section];
    return form;
}
/**
 * @ 百事新增RCD
 */
+(FormInfo *)creatPepsiForm:(UIViewController *)controller{
    FormInfo *form = [[FormInfo alloc] init];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"经销商名称";
    model.hint = @"请填写经销商名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    ModuleRowInfo *modelA = [[ModuleRowInfo alloc] init];
    modelA.label = @"MU";
    modelA.hint = @"请填MU";
    modelA.controller = controller;
    modelA.key = @"mu";
    modelA.required = YES;
    modelA.width = @"16";
    modelA.viewType = @"TextEdit";
    modelA.value = [STANDARD_USER_DEFAULT objectForKey:KEY_USER_MU];
    modelA.unInteractionEnabled = YES;
    [section addFormRow:modelA];
    
    ModuleRowInfo *modelB = [[ModuleRowInfo alloc] init];
    modelB.label = @"RU";
    modelB.hint = @"请填RU";
    modelB.controller = controller;
    modelB.key = @"ru";
    modelB.required = YES;
    modelB.width = @"16";
    modelB.viewType = @"TextEdit";
    modelB.value = [STANDARD_USER_DEFAULT objectForKey:KEY_USER_RU];
    modelB.unInteractionEnabled = YES;
    [section addFormRow:modelB];

    ModuleRowInfo *modelC = [[ModuleRowInfo alloc] init];
    modelC.label = @"AU";
    modelC.hint = @"请填AU";
    modelC.controller = controller;
    modelC.key = @"au";
    modelC.required = YES;
    modelC.width = @"16";
    modelC.viewType = @"TextEdit";
    modelC.value = [STANDARD_USER_DEFAULT objectForKey:KEY_USER_AU];
    modelC.unInteractionEnabled = YES;
    [section addFormRow:modelC];
    
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"经销商类型"; // label
    model2.hint = @"请选择";
    model2.formName = @"add_store";
    model2.searchHint = @"请填写经销商类型";
    model2.viewType = @"TreeSelectView";
    model2.controller = controller; //
    model2.key = @"channel_guid";
    model2.sql = @"name";
    model2.required = YES;
    model2.qurayType = @"1";
    model2.useDefault = YES;
    model2.tableName = @"store_channel_inc";
    [section addFormRow:model2];
    
    ModuleRowInfo *ssq = [[ModuleRowInfo alloc] init];
    ssq.label = @"省市区";
    ssq.controller = controller;
    ssq.key = @"ssq";
    ssq.required = NO;
    ssq.viewType = @"DistrictSelectView";
    ssq.provinceKey = @"province";
    ssq.cityKey = @"city";
    ssq.districtKey = @"county";
    ssq.required = YES;
    [section addFormRow:ssq];
    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"详细地址";
    modela.hint = @"请填写详细地址";
    modela.controller = controller;
    modela.key = @"full_addr";
    modela.viewType = @"TextEdit";
    modela.width = @"40";
    modela.required = YES;
    [section addFormRow:modela];
    
    ModuleRowInfo *modelb = [[ModuleRowInfo alloc] init];
    modelb.label = @"目标覆盖区域";
    modelb.hint = @"请填写目标覆盖区域";
    modelb.controller = controller;
    modelb.key = @"prop_str_1";
    modelb.viewType = @"TextEdit";
    modelb.width = @"40";
    modelb.required = YES;
    [section addFormRow:modelb];
    
    ModuleRowInfo *modelc = [[ModuleRowInfo alloc] init];
    modelc.label = @"目标覆盖渠道";
    modelc.hint = @"请填写目标覆盖渠道";
    modelc.controller = controller;
    modelc.key = @"prop_str_2";
    modelc.viewType = @"TextEdit";
    modelc.width = @"40";
    modelc.required = YES;
    [section addFormRow:modelc];
    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"百事销量预估(万/年)";
    model4.hint = @"请填写百事销量预估";
    model4.controller = controller;
    model4.key = @"receipt_total_amount";
    model4.viewType = @"TextEdit";
    model4.inputType = @"NUMBER";
    model4.required = YES;
    [section addFormRow:model4];
    
    
    [self checkCustomRow:section controller:controller form:form];
    [form addSection:section];
    return form;
}
#pragma mark --弈宫坊

+(FormInfo *)ygfFormInfoModelWithcontroller:(UIViewController *)controller{
    
    FormInfo *form = [[FormInfo alloc] init];
    form.tableName = SFA_STORE_TABLE_NAME;
    form.versionCode = @"get_sfa_store";
    FormSectionDescriptor *section = [[FormSectionDescriptor alloc] initWithContorller:controller];
    ModuleRowInfo *model7 = [[ModuleRowInfo alloc] init];
    model7.label = @"位置";
    model7.changeAware = YES;
    model7.key = @"dingwei";
    model7.viewType = @"LocateMapCell";
    [model7 addValidator:[FormLocationValidator validator]];
    model7.hint = @"";
    model7.isLocation = @"1";
    model7.isCanChoose = YES;
    model7.isShowMap = YES;
    model7.controller = controller;
    [section addFormRow:model7];
    
    ModuleRowInfo *model8 = [[ModuleRowInfo alloc] init];
    model8.controller = controller;
    model8.key = @"image";
    model8.maxPicCount = 1;
    model8.label = @"门店照片";
    model8.viewType = @"PhotoTaker";
    [section addFormRow:model8];
    
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.label = @"门店名称";
    model.hint = @"请填写门店名称";
    model.controller = controller;
    model.key = @"name";
    model.required = YES;
    model.width = @"16";
    model.viewType = @"TextEdit";
    [section addFormRow:model];
    
    
    ModuleRowInfo *model1 = [[ModuleRowInfo alloc] init];
    model1.label = @"门店编码"; // label
    model1.hint = @"请填写门店编码";
    model1.viewType = @"TextEdit";
    model1.controller = controller; //
    model1.key = @"code";
    model1.required = YES;
    model1.width = @"12";
    [section addFormRow:model1];
    
    
    ModuleRowInfo *model6 = [[ModuleRowInfo alloc] init];
    model6.label = @"门店类型"; // label
    model6.hint = @"类型";
    model6.viewType = @"THSelectView";
    model6.controller = controller; //
    model6.key = @"property_guid";
    model6.sql = @"name";
    model6.sqlValue = @"guid";
    model6.formName = @"add_store";
    model6.required = YES;
    model6.useDefault = YES;
    model6.searchHint = @"请输入门店类型名称";
    model6.qurayType = @"1";
    model6.tableName = @"get_store_property_inc";
    [section addFormRow:model6];
    
    
    ModuleRowInfo *model2 = [[ModuleRowInfo alloc] init];
    model2.label = @"所属渠道"; // label
    model2.hint = @"请选择";
    model2.formName = @"add_store";
    model2.searchHint = @"请填写渠道名称";
    model2.viewType = @"TreeSelectView";
    model2.controller = controller; //
    model2.key = @"channel_guid";
    model2.sql = @"name";
    model2.required = YES;
    model2.qurayType = @"1";
    model2.useDefault = YES;
    model2.tableName = @"store_channel_inc";
    [section addFormRow:model2];
    
    
    ModuleRowInfo *ssq = [[ModuleRowInfo alloc] init];
    ssq.label = @"省市区";
    ssq.controller = controller;
    ssq.key = @"ssq";
    ssq.required = NO;
    ssq.viewType = @"DistrictSelectView";
    ssq.provinceKey = @"province";
    ssq.cityKey = @"city";
    ssq.province = @"广东省";
    ssq.districtKey = @"county";
    ssq.required = YES;
    [section addFormRow:ssq];

    
    ModuleRowInfo *modelDept = [[ModuleRowInfo alloc] init];
    modelDept.label = @"所属部门"; // label
    modelDept.hint = @"请选择";
    modelDept.searchHint = @"请填写部门名称";
    modelDept.viewType = @"TreeSelectView";
    modelDept.controller = controller; //
    modelDept.key = @"dept_guid";
    modelDept.sql = @"name";
    modelDept.qurayType = @"1";
    modelDept.tableName = @"dept_info_inc";
    [section addFormRow:modelDept];
    
    ModuleRowInfo *preDept = [[ModuleRowInfo alloc] init];
    preDept.label = @"所属上级"; // label
    preDept.hint = @"请填写所属上级";
    preDept.viewType = @"TextEdit";
    preDept.controller = controller; //
    preDept.key = @"prop_str_1";
    preDept.required = YES;
    preDept.width = @"12";
    [section addFormRow:preDept];

    
    ModuleRowInfo *modela = [[ModuleRowInfo alloc] init];
    modela.label = @"门店店主";
    modela.hint = @"请填写店主姓名";
    modela.controller = controller;
    modela.key = @"master";
    modela.viewType = @"TextEdit";
    modela.width = @"20";
    [section addFormRow:modela];
    
    
    ModuleRowInfo *model4 = [[ModuleRowInfo alloc] init];
    model4.label = @"联系方式";
    model4.hint = @"请填写手机号或座机号码";
    model4.controller = controller;
    model4.key = @"contact";
    //    [model4 addValidator:[FormPhoneValidator validator]];
    model4.viewType = @"TextEdit";
    [section addFormRow:model4];
    
    
    [self checkCustomRow:section controller:controller form:form];
    [form addSection:section];
    return form;
}

/**
 自定义字段内容
 */
+(void)checkCustomRow:(FormSectionDescriptor*)section controller:(UIViewController *)vc form:(FormInfo *)form{
    NSString *sql = [NSString stringWithFormat:@"select *from conf_fields_extend where attach_form = 'sfa_store' order by data_time asc"];
    NSArray *customModel = [[Database shareDB] queryDataFromDBWithSqlString:sql];
    for (NSDictionary *dic in customModel) {
        ModuleRowInfo *model = [self customRowWithDic:dic];
        model.controller = vc;
        if ([vc isKindOfClass:[CustomViewController class]]) {
            CustomViewController *customVC = (CustomViewController *)vc;
            if (![customVC.modelCode isEqualToString:Code_update_table] && [dic[@"guid"] isEqualToString:@"FA58C221450F4C8BA6A56C5F3BFAEA69"]) {
                model.isHiddenCell = YES;
                model.value = @"否";
            } else if ([customVC.modelCode isEqualToString:Code_update_table] && [dic[@"guid"] isEqualToString:@"FA58C221450F4C8BA6A56C5F3BFAEA69"]) {
                continue;
            } else if ([customVC.modelCode isEqualToString:Code_update_table] && [dic[@"guid"] isEqualToString:@"6D29A127B0474E009F7CF9AD609282A2"]) {
                if ([STANDARD_USER_DEFAULT boolForKey:SFA_StoreIsPartner]){
                    model.value = @"已合作";
                    model.isHiddenCell = YES;
                }
            } else if (![customVC.modelCode isEqualToString:Code_update_table] && [dic[@"guid"] isEqualToString:@"6D29A127B0474E009F7CF9AD609282A2"]) {
                model.value = @"已合作";
            }
        }
        [form.customKeyAry addObject:model.key];
        [section addFormRow:model];
    }
}
+ (ModuleRowInfo *)customRowWithDic:(NSDictionary *)dic{
    ModuleRowInfo *model = [[ModuleRowInfo alloc] init];
    model.key = dic[@"guid"];
    model.label = dic[@"display"];
    model.dataSource = [self toArrayOrNSDictionary:dic[@"source"]];
    if ([dic[@"required"] integerValue] == 1) {
        model.required = YES;
    }
    model.required = !model.required;
    if ([dic[@"type"] isEqualToString:@"select"]) {
        model.viewType = @"SelectView";
    }else if ([dic[@"type"] isEqualToString:@"text"]){
        model.viewType = @"TextEdit";
    }else if ([dic[@"type"] isEqualToString:@"number"]){
        model.viewType = @"TextEdit";
        model.inputType = @"NUMBER";
    }else if ([dic[@"type"] isEqualToString:@"date"]){
        model.viewType = @"DatePicker";
    }
    return model;
}
// 将JSON串转化为字典或者数组
+ (id)toArrayOrNSDictionary:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}
@end
