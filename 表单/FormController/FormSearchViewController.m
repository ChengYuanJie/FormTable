
//
//  FormSearchViewController.m
//  director
//
//  Created by Aaron on 16/8/3.
//  Copyright © 2016年 Noah. All rights reserved.
//

#import "FormSearchViewController.h"
#import "Database.h"
#import "StringUtil.h"
#import "SearchTextField.h"
#import "KKHttpServices.h"
#import <Masonry.h>
#import "UILabel+LabelHeightAndWidth.h"
@interface FormSearchViewController ()<SearchTextFieldDetegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SearchTextField *filterTextField;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation FormSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.modouleInfo.label?self.modouleInfo.label:self.textTitle;
    if ([self.modouleInfo.qurayType isEqualToString:@"2"]) {
        [self searchDataFromNetWork];
    }else if ([self.modouleInfo.qurayType isEqualToString:@"3"]){
        self.returnArray = self.modouleInfo.dataSource;
        for (NSDictionary *dic in self.returnArray) {
            [self.dataArray addObject:dic[self.modouleInfo.sql?self.modouleInfo.sql:self.showProperty]];
        }
        [self.tableView reloadData];
    }else if ([self.modouleInfo.qurayType isEqualToString:@"4"]){
        [self qureyNet];
    }else{
        [self refreshData];
    }
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}
- (void)refreshData
{

    NSString *selectStr = nil;
    if (self.modouleInfo.sqlWhere.length > 0) {
        selectStr = [NSString stringWithFormat:@"select * from %@ where %@  order by %@ asc",self.modouleInfo.tableName?self.modouleInfo.tableName:self.tableName,self.modouleInfo.sqlWhere?self.modouleInfo.sqlWhere:self.sqlWhere,self.ascKey];
    }else{
        selectStr = [NSString stringWithFormat:@"select * from %@ order by %@ asc",self.modouleInfo.tableName?self.modouleInfo.tableName:self.tableName,self.ascKey];
    }
    self.returnArray = [[Database shareDB] queryDataFromDBWithSqlString:selectStr];
    for (NSDictionary *dic in self.returnArray){
        [self.dataArray addObject:dic[self.modouleInfo.sql?self.modouleInfo.sql:self.showProperty]];
    }
    [self.tableView reloadData];
}
-(NSString *)ascKey {
    if (!_ascKey) {
        return @"name";
    }
    return _ascKey;
}
/**
 queryNet
 */
- (void)qureyNet{
    [self.tableView reloadData];
    if (!self.modouleInfo.queryInfo) {
        return;
    }
    [MBProgressHUD show];
    [QueryNet queryDataWith:self.modouleInfo.queryInfo success:^(id object) {
        [MBProgressHUD hideHUD];
        self.returnArray = object;
        for (NSDictionary *dic in self.returnArray) {
            [self.dataArray addObject:dic[self.modouleInfo.sql]];
        }
        [self.tableView reloadData];
    } failure:^(id error) {
        [MBProgressHUD hideHUD];

    } unconnection:^(id error) {
        [MBProgressHUD hideHUD];
    }];
}
// **网络实时查询 */
- (void)searchDataFromNetWork
{
    [SVProgressHUD showWithStatus:@"正在查询..." maskType:SVProgressHUDMaskTypeGradient];
    THNetServiceModel *model = [[THNetServiceModel alloc] init];
    [UpdateService queryDataWithKey:model success:^(id object) {
        [SVProgressHUD dismiss];
        NSString *code = object[@"code"];
        if (code.integerValue == 0) {
            self.returnArray = object[@"message"];
            for (NSDictionary *dic in self.returnArray) {
                [self.dataArray addObject:dic[@"name"]];
            }
            [self.tableView reloadData];
        }

    } failure:^(id error) {
        [SVProgressHUD dismiss];

    } unconnection:^(id error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];

    }];
}
- (void)SearchTextFiledsetValue:(NSString *)text;
{
    [self.dataArray removeAllObjects];
    if ([StringUtil isEmpty:text]) {
        for (NSDictionary *dic in self.returnArray) {
            [self.dataArray addObject:dic[self.modouleInfo.sql]];
        }
    } else {
        for (NSDictionary *dic in self.returnArray) {
            NSString *string = dic[self.modouleInfo.sql];
            if((string &&[string rangeOfString:text].location != NSNotFound)) {
                [self.dataArray addObject:string];
            }
        }
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        UILabel *label = [[UILabel alloc] init];
        label.font = Fount14;
        label.tag = 100;
        label.numberOfLines = 0;

        [cell addSubview:label];
    }
    UILabel *label = [cell viewWithTag:100];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.bottom.right.mas_equalTo(-15);
    }];
    label.text = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UILabel getHeightByWidth:SCREEN_WIDTH - 30 title:self.dataArray[indexPath.row] font:Fount14]+30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sqlStr = self.dataArray[indexPath.row];
    NSDictionary *dic = nil;
    for (NSDictionary *dic1 in self.returnArray) {
        if ([dic1[self.modouleInfo.sql?self.modouleInfo.sql:self.showProperty] isEqualToString:sqlStr]) {
            dic = dic1;
            break;
        }
    }
   [self queryStoreAndEnter:dic];
}
//点击cell请求经销商对应的门店信息

-(void) queryStoreAndEnter:(id) object {
    if (self.returnValues) {
        self.returnValues(object);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)sqlArray
{
    if (!_sqlArray) {
        _sqlArray = [[NSMutableArray alloc] init];
    }
    return _sqlArray;
}
-(UIView *) headerView {
    self.filterTextField = [[SearchTextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 30) plachoder:self.modouleInfo.searchHint?self.modouleInfo.searchHint:@"请输入名称"];
    self.filterTextField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.filterTextField];
    return view;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight-NAV_HEIGHT - 50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 44;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}


@end
