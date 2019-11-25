//
//  FormObject.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormObject.h"
#import "FormBaseCell.h"
@implementation FormObject
+ (NSArray *)creatCellsWithArray:(NSArray *)configs showBttom:(BOOL)showBottom{
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:configs.count];
    for (NSDictionary *cellDict in configs) {
        Class CellClass = NSClassFromString([NSString stringWithFormat:@"Form%@",cellDict[@"type"]]);
        FormBaseCell *cell = [[CellClass alloc] initWithConfig:cellDict showBottom:showBottom];
        if (cell) {
            [arrayM addObject:cell];
        }
    }
    return arrayM.copy;

}
+ (NSArray *)creatCellsWithArray:(NSArray *)configs{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:configs.count];
    for (int i =0; i < configs.count;i++) {
        NSDictionary *cellDict = configs[i];
        Class CellClass = NSClassFromString([NSString stringWithFormat:@"Form%@",cellDict[@"type"]]);
        BOOL showBottom = YES;
        if (i+1 < configs.count) {
            NSDictionary *next = configs[i+1];
            if ([next[@"type"] containsString:@"Group"]) {
                showBottom = NO;
            }
        }
        FormBaseCell *cell = [[CellClass alloc] initWithConfig:cellDict showBottom:showBottom];
        if (cell) {
            [arrayM addObject:cell];
        }
        
    }
    return arrayM.copy;
}
- (BOOL)cherkEveryone {
    for (FormBaseCell *cell in self.cellArray) {
        if ([cell cherkValue]) {
            [MBProgressHUD showWaitMessage:[cell cherkValue]];
            return NO;
        }
    }
    return YES;
}
- (FormValueModel *)getSubmitValueModel{
    if (![self cherkEveryone])return nil;
    FormValueModel *valueModel = [[FormValueModel alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (FormBaseCell *cell in self.cellArray) {
        if (cell.unSubmit){
            continue;
        }
        id value = [cell exportValue];
        if (value) {
            if ([value isKindOfClass:[NSString class]] && cell.code) {
                [dict setObject:value forKey:cell.code];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                [dict addEntriesFromDictionary:value];
            }
            else if ([value isKindOfClass:[NSArray class]] && cell.code){
                if ([NSStringFromClass(cell.class) isEqualToString:@"FormPhotoTaker"]) {
                    [dict setObject:[value componentsJoinedByString:@","] forKey:cell.code];
                    if (valueModel.fileName.length > 0) {
                        valueModel.fileName = [NSString stringWithFormat:@"%@,%@",valueModel.fileName,dict[cell.code]];
                    }else{
                        valueModel.fileName = dict[cell.code];
                    }
                }else{
                    
                }
            }
        }
    }
    valueModel.value = dict.copy;
    return valueModel;
}
- (NSDictionary *)getSubmitData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (FormBaseCell *cell in self.cellArray) {
        if (cell.unSubmit){
            continue;
        }
        id value = [cell exportValue];
        if (value) {
            if ([value isKindOfClass:[NSString class]] && cell.code) {
                [dict setObject:value forKey:cell.code];
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                [dict addEntriesFromDictionary:value];
            }
            else if ([value isKindOfClass:[NSArray class]] && cell.code){
                if ([NSStringFromClass(cell.class) isEqualToString:@"FormPhotoTaker"]) {
                    [dict setObject:[value componentsJoinedByString:@","] forKey:cell.code];
                }else{
                    
                }
            }
        }
    }
    return dict.copy;
}
- (void)setReadonly:(BOOL)readonly{
    _readonly = readonly;
    for (FormBaseCell *cell in self.cellArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.readonly = readonly;
            [cell importValue:self.netValues];
        });
    }
}
- (void)setNetValues:(NSDictionary *)netValues{
    _netValues = netValues;
}
@end
@implementation FormValueModel

@end
#define formUrl(formId) [NSString stringWithFormat:@"%@/data-service/comm-form/get-config?id=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,(formId)]
static const NSString *wf_submit_base_url = @"/data-service/comm-form/insert-with-wf";
static const NSString *form_fetch_base_url = @"/data-service/comm-form/fetch";
@implementation FormManager
+ (void)creatByFormJson:(NSString *)formJson complete:(void(^)(FormObject *object))complete {
    [MBProgressHUD show];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FormObject *object = [[FormObject alloc] init];
        NSDictionary *configDic =  [JsonUtil objectFromJson:formJson];
        object.title = configDic[@"title"];
        NSArray *cellArray = configDic[@"rows"];
        dispatch_async(dispatch_get_main_queue(), ^{
            object.cellArray = [FormObject creatCellsWithArray:cellArray];
            [MBProgressHUD hideHUD];
            if (complete) {
                complete(object);
            }
        });
    });
}
+ (void)creatByFormId:(NSString *)formId complete:(void(^)(FormObject *object))complete{
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.customBaseUrl = [NSString stringWithFormat:@"%@/data-service/comm-form/get-config?form_guid=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,(formId)];
    [MBProgressHUD show];
    [UpdateService requestWith:model httpType:HttpTypeGet success:^(id object) {
        FormObject *fromObj = [[FormObject alloc] init];
        NSDictionary *configDic =  object[@"message"];
        fromObj.title = configDic[@"caption"];
        fromObj.formId = configDic[@"guid"];
        NSString *str = configDic[@"content"];
        NSMutableString *mutStr = [NSMutableString stringWithString:str];
        NSRange range = {0,mutStr.length};
        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
        NSArray *cellArray = [JsonUtil objectFromJson:mutStr];
        dispatch_async(dispatch_get_main_queue(), ^{
            fromObj.cellArray = [FormObject creatCellsWithArray:cellArray];
            [MBProgressHUD hideHUD];
            if (complete) {
                complete(fromObj);
            }
        });
    } failure:^(id error) {
        [MBProgressHUD showError:@"获取表单配置失败"];
    } unconnection:^(id error) {
        [MBProgressHUD showError:@"无网络,请稍候再试"];
    }];
}
+ (void)submitNormolData:(FormObject *)formObj
          complete:(void(^)(BOOL))complete{
    complete(YES);
}
+ (void)submitWfData:(FormObject *)formObj
            complete:(void(^)(BOOL))complete{
    FormValueModel *valueModel = [formObj getSubmitValueModel];
    if (!valueModel)return;
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.customBaseUrl = [NSString stringWithFormat:@"%@%@?tenant_id=%@&form_guid=%@&data_json=%@&wf_json=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,wf_submit_base_url,[STANDARD_USER_DEFAULT objectForKey:KEY_TENANT_ID],formObj.formId,[JsonUtil stringFromObject:valueModel.value],formObj.wf];
    [MBProgressHUD show];
    [UpdateService requestWith:model httpType:HttpTypePost success:^(id object) {
        [MBProgressHUD hideHUD];
        !valueModel.fileName?:[self uploadImg:valueModel.fileName];
        complete(YES);
    } failure:^(id error) {
        complete(NO);
        [MBProgressHUD showError:@"获取表单配置失败"];
    } unconnection:^(id error) {
        complete(NO);
        [MBProgressHUD showError:@"无网络,请稍候再试"];
    }];
}
+ (void)getFormFetchByFormId:(NSString *)formId
                    formGuid:(NSString *)guid
                    formJson:(NSString *)formJson
                    complete:(void(^)(FormObject *object))complete{
    [MBProgressHUD show];
    FormObject *object = [[FormObject alloc] init];
    if (formJson) {
        NSDictionary *configDic =  [JsonUtil objectFromJson:formJson];
        object.title = configDic[@"title"];
        NSArray *cellArray = configDic[@"rows"];
        dispatch_async(dispatch_get_main_queue(), ^{
            object.cellArray = [FormObject creatCellsWithArray:cellArray];
            [self getFormValueByFormId:formId formGuid:guid complete:^(NSDictionary *data) {
                object.netValues = data;
                complete(object);
                [MBProgressHUD hideHUD];
            }];
        });
        return;
    }
    /*获取表单以及表单数据*/
    __block NSDictionary *fetchData;
    __block NSDictionary *configDic;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"ddddddddddddd");
        [self getFormValueByFormId:formId formGuid:guid complete:^(NSDictionary *data) {
            fetchData = data;
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"ddfffffffffffffff");
        THNetServiceModel *model = [[THNetServiceModel alloc] init];
        model.customBaseUrl = [NSString stringWithFormat:@"%@/data-service/comm-form/get-config?form_guid=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,(formId)];
        [UpdateService requestWith:model httpType:HttpTypeGet success:^(id object) {
            configDic = object[@"message"];
            dispatch_semaphore_signal(semaphore);
        } failure:^(id error) {
            [MBProgressHUD showError:@"获取表单配置失败"];
            dispatch_semaphore_signal(semaphore);
        } unconnection:^(id error) {
            [MBProgressHUD showError:@"无网络,请稍候再试"];
            dispatch_semaphore_signal(semaphore);
        }];
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (configDic){
                object.title = configDic[@"caption"];
                object.formId = configDic[@"guid"];
                NSString *str = configDic[@"content"];
                NSMutableString *mutStr = [NSMutableString stringWithString:str];
                NSRange range = {0,mutStr.length};
                //去掉字符串中的换行符
                [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
                NSArray *cellArray = [JsonUtil objectFromJson:mutStr];
                object.cellArray = [FormObject creatCellsWithArray:cellArray];
                object.netValues = fetchData;
                [MBProgressHUD hideHUD];
                complete(object);
            }
        });
    });
}
+ (void)getFormValueByFormId:(NSString *)formId
                    formGuid:(NSString *)guid
                    complete:(void(^)(NSDictionary*object))complete{
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    model.customBaseUrl = [NSString stringWithFormat:@"%@%@?tenant_id=%@&form_guid=%@&guid=%@",[NetLinkConfigManager shareNetLinkManager].littleServiceNetLink,form_fetch_base_url,[STANDARD_USER_DEFAULT objectForKey:KEY_TENANT_ID],formId,guid];
    [UpdateService requestWith:model httpType:HttpTypePost success:^(id object) {
        complete(object[@"message"]);
    } failure:^(id error) {
        [MBProgressHUD showError:@"获取表单显示数据失败"];
        complete(nil);
    } unconnection:^(id error) {
        complete(nil);
        [MBProgressHUD showError:@"无网络,请稍候再试"];
    }];
}
/**
 提交图片
 */
+ (void)uploadImg:(NSString *)fileName{
    NSArray *imgArray = [fileName componentsSeparatedByString:@","];
    for (int i = 0; i < imgArray.count ;i ++) {
        NSString *imgKey = imgArray[i];
        NZNet *net = [[NZNet alloc] init];
        NSData *data = [ImageCacheTools getImageDataWithKey:imgKey];
        [net dataServiceUploadImg:imgKey data:data save:YES success:^(id object) {

        } failure:^(id error) {
        
        }];
    }
}
@end
