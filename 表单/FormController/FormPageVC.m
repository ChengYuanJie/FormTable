//
//  FormPageVC.m
//  THStandardEdition
//
//  Created by Aaron on 2018/9/10.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "FormPageVC.h"
#import "MJRefresh.h"
#import "SearchTextField.h"
#import "StringUtil.h"
@interface FormPageVC ()<SearchTextFieldDetegate>
@property (nonatomic,assign) NSInteger pager;
@property (nonatomic,assign) BOOL NoMoreData; //是否有更多数据
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic,strong) SearchTextField *textView;
@property (nonatomic, strong) NSMutableArray *allAry;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation FormPageVC
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = @[].mutableCopy;
    }
    return _dataAry;
}
- (NSMutableArray *)allAry{
    if (!_allAry) {
        _allAry = @[].mutableCopy;
    }
    return _allAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.module.label;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    [self setMJRefresh];
    self.pager = 1;
    [self getData];
}
- (void)getData{
    if (!self.module.queryInfo) {
        return;
    }
    if (self.pager == 1) {
        [self.allAry removeAllObjects];
    }
    [self.dataAry removeAllObjects];
    [MBProgressHUD show];
    [QueryNet queryDataWith:self.module.queryInfo success:^(id object) {
        [MBProgressHUD hideHUD];
        NSArray *ary = object;
        [self.allAry addObjectsFromArray:ary];
        [self.dataAry addObjectsFromArray:ary];
        if (self.allAry.count == 0) {
            [self showEmpty];
        }else{
            [self cancelEmpty];
        }
        if (ary.count  < 20) {
            self.NoMoreData = YES;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(id error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    } unconnection:^(id error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
    }];

}
- (void)checkBtnClick{
    [self.view endEditing:YES];
    [self.allAry removeAllObjects];
    [self.dataAry removeAllObjects];
    [MBProgressHUD show];
    QueryInfo *info = [[QueryInfo alloc] init];
    info.key = self.module.queryInfo.key;
    if (self.textView.textField.text.length != 0) {
          info.conditions = @[QueryCnd.n.code(self.module.sql).op(@"like").value(self.textView.textField.text)];
    }
    [QueryNet queryDataWith:info success:^(id object) {
        [MBProgressHUD hideHUD];
        NSArray *ary = object;
        [self.allAry addObjectsFromArray:ary];
        [self.dataAry addObjectsFromArray:ary];
        if (self.allAry.count == 0) {
            [self showEmpty];
        }else{
            [self cancelEmpty];
        }
        if (ary.count  < 20) {
            self.NoMoreData = YES;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(id error) {
        [MBProgressHUD hideHUD];
    } unconnection:^(id error) {
        [MBProgressHUD hideHUD];
    }];

}
- (void)setMJRefresh{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.textView.textField.text = @"";
        weakSelf.NoMoreData = NO;
        weakSelf.pager = 1;
        [weakSelf getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.NoMoreData) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        weakSelf.pager += 1;
        [weakSelf getData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifer = @"indentifer";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer];
    }
    cell.textLabel.font = Fount14;
    cell.textLabel.text = self.dataAry[indexPath.row][self.module.sql];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataAry[indexPath.row];
    if (self.block) {
        self.block(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --searchDelegate
- (void)SearchTextFiledsetValue:(NSString *)string{
    [self.dataAry removeAllObjects];
    if ([StringUtil isEmpty:string]) {
        [self.dataAry addObjectsFromArray:self.allAry];
    }else{
        for (NSDictionary *dic in self.allAry){
            NSRange range = [dic[self.module.sql] rangeOfString:string];
            if (range.location != NSNotFound) {
                [self.dataAry addObject:dic];
            }
        }
    }
    [self.tableView reloadData];
}
- (SearchTextField *)textView{
    if (!_textView) {
        _textView = [[SearchTextField alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 80, 30) plachoder:@"请输入门店名称或编码"];
        _textView.delegate = self;
    }
    return _textView;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 50)];
        [_headerView addSubview:self.textView];
        UIButton * checkbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkbtn setTitle:@"查询" forState:UIControlStateNormal];
        [checkbtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
        checkbtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [checkbtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        checkbtn.frame = CGRectMake(SCREEN_WIDTH - 70, 0, 60, 50);
        [_headerView addSubview:checkbtn];

    }
    return _headerView;
}
@end
