//
//  THLocationCell.h
//  THStandardEdition
//
//  Created by Aaron on 16/9/26.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
@interface LocateView : FormBaseTableViewCell
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) NSMutableDictionary *subDic;
@property (nonatomic, strong) FormLabel *label;
@property (nonatomic, strong) AMLoction *location;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,assign) BOOL noSet;
- (void)refreshLocation;
@end
