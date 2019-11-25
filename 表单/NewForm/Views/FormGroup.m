//
//  FormGroupCell.m
//  SmartForm
//
//  Created by Noah on 2019/8/29.
//  Copyright © 2019 SF. All rights reserved.
//

#import "FormGroup.h"
#import "FormObject.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "FormBaseCell.h"
@interface FormGroup ()

@property (nonatomic, strong) NSMutableArray <FormBaseCell *>*groupCells;

@end

@implementation FormGroup
- (void)creatUI {
    [super creatUI];
    [self.groupCells addObjectsFromArray:[FormObject creatCellsWithArray:self.subRows]];
    [self addCloneView];
}
- (void)importValue:(NSDictionary *)value{
    NSDictionary *dic = value[self.code];
    for (FormBaseCell *cell in self.groupCells) {
        cell.readonly = self.readonly;
        [cell importValue:dic];
    }
}
- (NSString *)cherkValue{
    for (FormBaseCell *cell in self.groupCells) {
        if ([cell cherkValue]) {
            return [cell cherkValue];
        }
    }
    return nil;
}
/*重写value get方法*/
- (id)exportValue {
    BOOL empty = NO;
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
    for (FormBaseCell *cell in self.groupCells) {
        if ([cell cherkValue]) {
            empty = YES;
            UIAlertViewQuick(@"提示", [cell cherkValue], @"确定");
            return nil;
        }
        [valueDic setObject:cell.value?:@"" forKey:cell.code];
    }
    if (empty) {
        return nil;
    }
    return  @{self.code:valueDic};
}
- (void)addCloneView {
    UIView *view = [[UIView alloc] init];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:14.f];
    titleLbl.numberOfLines = 0;
    titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
    titleLbl.text = self.label;

    [self addSubview:view];

    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = HUI_COLOR;
    [view addSubview:topBgView];
    [topBgView addSubview:titleLbl];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
    }];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(view);
        make.height.mas_equalTo(44);
    }];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBgView).with.offset(ContentMargin);
        make.top.equalTo(topBgView);
        make.height.mas_equalTo(44);
    }];
    [self setBottomLine:view];
    __block FormBaseCell *lastCell;
    [self.groupCells enumerateObjectsUsingBlock:^(FormBaseCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [view addSubview:cell];
        cell.showBottom = NO;
        
        if (self.groupCells.count == 1) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(view);
                make.top.equalTo(topBgView.mas_bottom);
            }];
        } else if (idx+1 == self.groupCells.count) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(view);
                make.top.equalTo(lastCell.mas_bottom);
            }];
        } else if (idx == 0) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(topBgView.mas_bottom);
            }];
        } else {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(view);
                make.top.equalTo(lastCell.mas_bottom);
            }];
        }
        lastCell = cell;
    }];
}

- (NSMutableArray<FormBaseCell *> *)groupCells {
    if (!_groupCells) {
        _groupCells = [NSMutableArray array];
    }
    return _groupCells;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
