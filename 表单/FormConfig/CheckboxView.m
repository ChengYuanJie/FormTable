//
//  CheckboxView.m
//  THStandardEdition
//
//  Created by Aaron on 2017/8/3.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "CheckboxView.h"
#import "RepeatSelectCell.h"
@interface CheckboxView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectCells;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation CheckboxView

- (void)creatUI{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 15)];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = self.moduleInfo.label;
    [self.contentView addSubview:titleLabel];
    for (id object in self.moduleInfo.dataSource){
        if ([object isKindOfClass:[NSDictionary class]]){
         [self.dataSource addObject:object[@"value"]];
        }else{
            [self.dataSource addObject:object];
        }
    }
    self.rowH = self.dataSource.count*40 + 35;
    [self.contentView addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
    if ([valueDic.allKeys containsObject:self.moduleInfo.key]) {
        NSString *value = valueDic[self.moduleInfo.key];
        NSArray *datas = [value componentsSeparatedByString:self.moduleInfo.inputType?self.moduleInfo.inputType:@","];
        [self.selectCells addObjectsFromArray:datas];
        [self.tableView reloadData];
    }
}
#pragma tableViewDelegate
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
    }
    NSString *title = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = title;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = Fount14;
    if ([self.selectCells containsObject:title]) {
        cell.selectStatus = YES;
    }else{
        cell.selectStatus = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RepeatSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectCells containsObject:cell.textLabel.text]) {
        cell.selectStatus = NO;
        [self.selectCells removeObject:cell.textLabel.text];
    } else {
        cell.selectStatus = YES;
        [self.selectCells addObject:cell.textLabel.text];
    }
    NSString *valueStr = [self.selectCells componentsJoinedByString:self.moduleInfo.inputType?self.moduleInfo.inputType:@","];
    self.moduleInfo.value = valueStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


- (NSMutableArray *)selectCells
{
    if (!_selectCells) {
        _selectCells = [[NSMutableArray alloc] init];
    }
    return _selectCells;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGFloat heg = self.dataSource.count*40;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH - 40,heg) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}

@end
