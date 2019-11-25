//
//  RepeatSelectViewController.m
//  THStandardEdition
//
//  Created by Aaron on 16/10/12.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "RepeatSelectViewController.h"
#import "RepeatSelectCell.h"
@interface RepeatSelectViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectCells;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITableView *tableView;

@end
@implementation RepeatSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
}
- (void)creatSubViews
{
    [self.view addSubview:self.tableView];
}
-(void) updateItemButton
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.submitButton];
    self.navigationItem.rightBarButtonItem = right;
    
}
#pragma buttonAction
- (void)submitButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(UIViewControllerDidDisappear:andMessageObject:)]) {
        [self.delegate UIViewControllerDidDisappear:self andMessageObject:self.selectCells];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"identifer";
    RepeatSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[RepeatSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
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
    if (self.selectCells.count == self.dataSource.count) {
        
    } else {
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60 / 667.f * SCREEN_HEIGHT;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.frame = CGRectMake(0, 0, 40, 40);
        [_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
@end
