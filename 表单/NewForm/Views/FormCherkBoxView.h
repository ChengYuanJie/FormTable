//
//  FormCherkBoxView.h
//  THStandardEdition
//
//  Created by Noah on 2018/12/4.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormCherkBoxView : FormBaseCell

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) BOOL canMulti;

@end

NS_ASSUME_NONNULL_END
