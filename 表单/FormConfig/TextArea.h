//
//  THTextViewCell.h
//  THStandardEdition
//
//  Created by Aaron on 16/9/26.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
#import "BaseTextView.h"
@interface TextArea : FormBaseTableViewCell<TextViewDidChangeDelegate>
@property (nonatomic, strong) BaseTextView *textView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic,copy) NSString *plahoder;
@end
