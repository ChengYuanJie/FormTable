//
//  FormSelectView.h
//  THStandardEdition
//
//  Created by Noah on 2018/12/4.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormBaseCell.h"
typedef enum{
    FormSelectTypePresent = 0, //showPop
    FormSelectTypePush,   //pushController
} FormSelectType;
NS_ASSUME_NONNULL_BEGIN

@interface FormSelectView : FormBaseCell

@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) NSString *showKey;
@property (nonatomic, strong) NSString *submitKey;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) FormSelectType selectType;

@end

NS_ASSUME_NONNULL_END
