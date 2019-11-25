//
//  FormCherkBoxView.m
//  THStandardEdition
//
//  Created by Noah on 2018/12/4.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormCherkBoxView.h"
#import "Masonry.h"
#import "RepeatSelectCell.h"
@interface FormCherkBoxView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation FormCherkBoxView

- (void)creatUI {
    [super creatUI];
    WS(wself);
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.xLabel.right).with.offset(3.0);
        make.right.equalTo(wself.right).with.offset(ContentMargin);
        make.top.equalTo(wself.top);
        make.height.mas_equalTo(40.0*SCREEN_WIDTH_6);
    }];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHEXRGB:0xe0e0e0];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.bottom.equalTo(wself.titleLbl);
        make.height.mas_equalTo(1.0f);
    }];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wself);
        make.top.equalTo(wself.titleLbl.bottom);
        make.bottom.equalTo(wself.bottomView.top);
    }];
}

- (CGFloat)defaultHeight {
    return (CGFloat)(self.dataSource.count+1) * 40.0f;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (void)afterCreated {
    if (self.useDefault) {
        id submitValue = [self lastSubmitValue];
        if (submitValue) {
            self.value = submitValue;
        }
    }
}
- (void)importValue:(NSDictionary *)value {
    if (value[self.code]) {
        self.value = [value[self.code] componentsSeparatedByString:@","];
        [self.tableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    RepeatSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[RepeatSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = Fount14;
    }
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;

    if ([self.value containsObject:title]) {
        cell.selectStatus = YES;
    }else{
        cell.selectStatus = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selectValue = self.dataSource[indexPath.row];
    
    if (self.canMulti) {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.value];
        if ([self.value containsObject:selectValue]) {
            [newArr removeObject:selectValue];
        } else {
            [newArr addObject:selectValue];
        }
        self.value = newArr.copy;
    } else {
        self.value = @[selectValue];
    }
    [self.tableView reloadData];
    [self saveValueWithShowValue:@""];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

@end
