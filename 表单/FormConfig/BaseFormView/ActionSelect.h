//
//  ActionSelect.h
//  THStandardEdition
//
//  Created by Aaron on 16/10/17.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSelect : NSObject
{
    void(^_complete)(NSString *);
}
+ (instancetype)shareAction;
- (void)dateActionShowInController:(UIViewController *)controller
                     selectArray:(NSArray *)selectArray
                 CanSelectLast:(BOOL)canSelect
                          complete:(void (^)(NSString *))complete;

@end
