//
//  FormCloneCell.m
//  SmartForm
//
//  Created by Noah on 2019/8/28.
//  Copyright © 2019 SF. All rights reserved.
//

#import "FormGroupClone.h"
#import "FormObject.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "FormBaseCell.h"
#import "UIButton+ImageTitleSpacing.h"
@interface FormGroupClone ()

@property (nonatomic, strong) NSMutableArray <UIView *>*cloneViews;

@property (nonatomic, strong) NSMutableArray <NSArray *>*cloneCells;

@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation FormGroupClone

- (void)creatUI {
    [super creatUI];
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setTitle:[NSString stringWithFormat:@"新增%@",self.label] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [addBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [addBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(didClickAdd:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    [self addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(44.0);
    }];
    [self setBottomLine:addBtn];
    [self didClickAdd:self.addBtn];
}
- (void)setReadonly:(BOOL)readonly {
    [super setReadonly:readonly];
    self.userInteractionEnabled = NO;
    for (NSArray *cells in self.cloneCells) {
        for (FormBaseCell *cell in cells) {
            cell.readonly = YES;
        }
    }
    [self hiddenDeleteBtn];
}
- (void)importValue:(NSDictionary *)value{
    NSArray *values = value[self.code];
    for (int i = 1; i < values.count; i ++) {
        NSArray *cloneCells = [FormObject creatCellsWithArray:self.subRows showBttom:NO];
        [self.cloneCells addObject:cloneCells];
        [self addCloneView];
        [self setSectionTitle];
    }
    [self.tableView reloadData];
    for (int i = 0; i < self.cloneCells.count; i ++) {
        NSArray *cells = self.cloneCells[i];
        NSDictionary *dic;
        if (i < values.count) {
            dic = values[i];
        }
        for (FormBaseCell *cell in cells) {
            [cell importValue:dic];
        }
    }
}
- (NSString *)cherkValue{
    for (NSArray *cells in self.cloneCells) {
        for (FormBaseCell *cell in cells) {
            if ([cell cherkValue]) {
                return [cell cherkValue];
            }
        }
    }
    return nil;
}
/*重写value get方法*/
- (id)exportValue {
    NSMutableArray *cellValues = [NSMutableArray arrayWithCapacity:self.cloneCells.count];
    BOOL empty = NO;
    for (NSArray *cells in self.cloneCells) {
        NSMutableDictionary *valueDic = [NSMutableDictionary dictionary];
        for (FormBaseCell *cell in cells) {
            if ([cell cherkValue]) {
                empty = YES;
                UIAlertViewQuick(@"提示", [cell cherkValue], @"确定");
                return nil;
            }
            [valueDic setObject:cell.value?:@"" forKey:cell.code];
        }
        [cellValues addObject:valueDic];
    }
    if (empty) {
        return nil;
    }
    return @{self.code:cellValues.copy};
}
- (void)addCloneView {
    
    UIView *view = [[UIView alloc] init];
    
    UIView *topBgView = [[UIView alloc] init];
    topBgView.backgroundColor = HUI_COLOR;
    [view addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.equalTo(view);
        make.height.mas_equalTo(44);
    }];

    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:14.f];
    titleLbl.numberOfLines = 0;
    titleLbl.tag = 100;
    titleLbl.lineBreakMode = NSLineBreakByCharWrapping;
    
    UIButton *delBtn = [[UIButton alloc] init];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(didClickDel:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.titleLabel.font = Fount12;
    delBtn.tag = 101;
    [self addSubview:view];
    [topBgView addSubview:titleLbl];
    [topBgView addSubview:delBtn];
    
    UIView *lastView = self.cloneViews.lastObject;
    if (lastView) {
        
        if (self.cloneViews.count == 1) {
            [lastView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.right.equalTo(self);
            }];
        } else {
            [lastView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.cloneViews[self.cloneViews.count - 2].mas_bottom);
                make.left.right.equalTo(self);
            }];
        }
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.addBtn.mas_top);
            make.top.equalTo(lastView.mas_bottom);
        }];
    } else {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self.addBtn.mas_top);
        }];
        [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(44.0);
        }];
    }
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBgView).with.offset(ContentMargin);
        make.top.equalTo(topBgView);
        make.height.mas_equalTo(44);
    }];
    
    
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBgView).with.offset(-ContentMargin);
        make.centerY.equalTo(topBgView);
    }];
    
    
    NSArray *cloneCell = self.cloneCells.lastObject;
    __block FormBaseCell *lastCell;
    [cloneCell enumerateObjectsUsingBlock:^(FormBaseCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [view addSubview:cell];
        cell.showBottom = NO;
        if (cloneCell.count == 1) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(view);
                make.top.equalTo(topBgView.mas_bottom);
            }];
        } else if (idx+1 == cloneCell.count) {
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
    
    [self.cloneViews addObject:view];
}

- (void)didClickDel:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteCurrenSection:button];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [[AppDelegate shareAppDelegate].pushNavController.visibleViewController presentViewController:alert animated:YES completion:nil];
}
- (void)deleteCurrenSection:(UIButton *)button{
    UIView *cloneView = [button.superview superview];
    NSInteger index = [self.cloneViews indexOfObject:cloneView];
    //只有一个
    if (self.cloneViews.count == 1) {
        
        [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
        }];
    } else if (self.cloneViews.firstObject == cloneView && self.cloneViews.count > index+1) {
        //数量大于1 并且 为第一个
        UIView *nextView = self.cloneViews[index+1];
        [nextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
        }];
    } else if (self.cloneViews.lastObject == cloneView && self.cloneViews.count > index-1) {
        //数量大于一,并且为最后一个
        UIView *lastView = self.cloneViews[index-1];
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.addBtn.mas_top);
        }];
    } else {
        UIView *nextView = self.cloneViews[index+1];
        UIView *lastView = self.cloneViews[index-1];
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(nextView.mas_top);
        }];
    }
    
    [cloneView removeFromSuperview];
    if (self.cloneCells.count > index && self.cloneViews.count > index) {
        [self.cloneCells removeObjectAtIndex:index];
        [self.cloneViews removeObjectAtIndex:index];
    }
    
    [self.tableView reloadData];
    [self setSectionTitle];
}
- (void)didClickAdd:(UIButton *)button {
    NSArray *cloneCells = [FormObject creatCellsWithArray:self.subRows showBttom:NO];
    [self.cloneCells addObject:cloneCells];
    [self addCloneView];
    [self.tableView reloadData];
    [self setSectionTitle];
}

- (NSMutableArray<UIView *> *)cloneViews {
    if (!_cloneViews) {
        _cloneViews = [NSMutableArray array];
    }
    return _cloneViews;
}

- (NSMutableArray<NSArray *> *)cloneCells {
    if (!_cloneCells) {
        _cloneCells = [NSMutableArray array];
    }
    return _cloneCells;
}
- (void)setSectionTitle{
    BOOL hidden = !(self.cloneViews.count > 1);
    for (int i = 0; i < self.cloneViews.count; i ++) {
        UIView *cloneView = self.cloneViews[i];
        UILabel *label = [cloneView viewWithTag:100];
        label.text = [NSString stringWithFormat:@"%@(%d)",self.label,i+1];
        UIButton *deleBtn = [cloneView viewWithTag:101];
        deleBtn.hidden = hidden;
    }
}
- (void)hiddenDeleteBtn{
    for (int i = 0; i < self.cloneViews.count; i ++) {
        UIView *cloneView = self.cloneViews[i];
        UIButton *btn = [cloneView viewWithTag:101];
        btn.hidden = YES;
    }
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.0);
    }];
    self.addBtn.hidden = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
