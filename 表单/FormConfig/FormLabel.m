//
//  FormLabel.m
//  director
//
//  Created by Aaron on 16/7/22.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "FormLabel.h"

@implementation FormLabel
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self.text = [NSString stringWithFormat:@"%@",title];
        self.backgroundColor = [UIColor clearColor];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],};
        NSString *str = title;
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(0, frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        [self setFrame:CGRectMake(20/375.f*SCREEN_WIDTH,0, textSize.width, frame.size.height)];
        
        self.adjustsFontSizeToFitWidth = YES;
        self.text = [NSString stringWithFormat:@"%@",title];
    }
    return self;
}

@end
