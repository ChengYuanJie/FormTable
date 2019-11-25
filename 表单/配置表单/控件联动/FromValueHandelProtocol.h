//
//  FromValueHandelProtocol.h
//  director
//
//  Created by Aaron on 16/7/26.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @pmara // 这个代理方法实在cell的基类里面调用的，
 *  在对应的控制器里面实现该方法，
 *  实现时需要确定要进行关联的控件以及关联方式，
 *  若分出子类，则需要重写此方法
 *  -- >   model为 实现代理方法的key value
 *  -- >   moduleRowInfo 为根据model 改变的控件值
 */
@class ModuleRowInfo;
@class ValueChainModel;
@protocol FromValueHandelProtocol <NSObject>
@required
- (ModuleRowInfo *)handlePostValue:(id)model;
@end
