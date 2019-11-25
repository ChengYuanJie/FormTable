//
//  NewTreeSelectController.m
//  THStandardEdition
//
//  Created by Aaron on 2017/3/16.
//  Copyright © 2017年 程元杰. All rights reserved.
//

#import "NewTreeSelectController.h"
#import "Database.h"
#import "CustomViewController.h"
@interface NewTreeSelectController ()
@property (nonatomic, strong) NSArray *allArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *pArray;
@end
@implementation NewTreeSelectController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    NSString *sql = [NSString stringWithFormat:@"select *from %@ order by name",self.model.tableName];
    NSArray *Sss = [[Database shareDB] queryDataWithTableName:self.model.tableName];
    self.allArray = [[Database shareDB] queryDataFromDBWithSqlString:[NSString stringWithFormat:@"select *from %@ order by name",self.model.tableName]];
    NSString *pguid = nil;
    if (!self.parent_guid){
        pguid = @"";
    }else{
        pguid = self.parent_guid;
    }
    if (pguid.length == 0) {
        for (NSDictionary *dic in self.allArray) {
            if ([dic[@"parent_guid"] isEqualToString:pguid] || [dic[@"parent_guid"] isEqualToString:@"0"]) {
                [self.dataArray addObject:dic];
            }
        }
    }else{
        for (NSDictionary *dic in self.allArray) {
            if ([dic[@"parent_guid"] isEqualToString:pguid]) {
                [self.dataArray addObject:dic];
            }
        }
    }
    self.title = self.model.label;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    UIButton *pushBt = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    pushBt.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 44);
    pushBt.tag = indexPath.row + 1000;
    [cell addSubview:pushBt];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *guid = dic[@"guid"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    UIButton *but = [cell viewWithTag:indexPath.row + 1000];
    but.enabled = NO;
    [but addTarget:self action:@selector(butonAction:) forControlEvents:UIControlEventTouchUpInside];
    for (NSDictionary *dict in self.allArray) {
        if ([dict[@"parent_guid"] isEqualToString:guid]) {
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        but.enabled = YES;
    }
    cell.textLabel.text = dic[@"name"];
    cell.textLabel.font = Fount14;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *guid = dic[@"guid"];
    NSDictionary * dict = @{@"name":dic[@"name"],@"guid":guid};
    self.block(dict);
    [self.navigationController popToViewController:self.model.controller animated:YES];

}
- (void)butonAction:(UIButton *)sender{
    NSInteger index = sender.tag - 1000;
    NSDictionary *dic = self.dataArray[index];
    NSString *guid = dic[@"guid"];
    NewTreeSelectController *newVC = [[NewTreeSelectController alloc] init];
    newVC.parent_guid = guid;
    newVC.block = [self.block copy];
    newVC.model = self.model;
    [self.navigationController pushViewController:newVC animated:YES];
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)pArray{
    if (!_pArray) {
        _pArray = [[NSMutableArray alloc] init];
    }
    return _pArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
