//
//  ValueChainModel.h
//  director
//
//  Created by Aaron on 16/7/25.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "BaseObject.h"

@interface ValueChainModel : BaseObject
/**
 *  @pmara 发送通知联动的key
 */
@property (nonatomic, copy) NSString *postKey;
/**
 *  @pmara 接收通知联动的key
 */
@property (nonatomic, copy) NSString *reciveKey;

@property (nonatomic, copy) NSString *value;


@property (nonatomic, strong) NSArray *valueArray;
@end
