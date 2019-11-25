





//
//  AbstractValueModel.m
//  THStandardEdition
//
//  Created by Aaron on 2017/8/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "AbstractValueModel.h"

@implementation AbstractValueModel
- (instancetype)initWithDic:(NSDictionary *)dicValue
{
    self = [super init];
    if (self) {
        __block NSString *imageKey = nil;
        NSMutableArray *imageKeyAry = [NSMutableArray array];
        [dicValue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSRange range = [key rangeOfString:@"image_data_key"];
            if (range.location!=NSNotFound) {
                [imageKeyAry addObject:key];
                if (imageKey.length > 0) {
                    imageKey = [NSString stringWithFormat:@"%@,%@",imageKey,obj];
                }else{
                    imageKey = obj;
                }
            }
        }];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic addEntriesFromDictionary:dicValue];
        if (imageKey) {
            for (NSString *key in imageKeyAry) {
                [dic removeObjectForKey:key];
            }
        }

        if (imageKey) {
            NSArray *array = [imageKey componentsSeparatedByString:@","];
            for (NSString *key in array) {
             NSString *value = dicValue[key];
                if (value.length == 0) {
                    continue;
                }
                if (self.fileName.length > 0) {
                    self.fileName = [NSString stringWithFormat:@"%@,%@",self.fileName,dicValue[key]];
                }else{
                    self.fileName = dicValue[key];
                }
            }
        }
        self.valueDic = dic;
    }
    return self;
}
@end
