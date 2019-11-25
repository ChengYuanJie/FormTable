//
//  CustomTableView.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "CustomTableView.h"
#import "FormBaseTableViewCell.h"
#import <objc/runtime.h>
@interface CustomTableView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

//cell控件数组
@property (nonatomic, strong) NSMutableArray * cellArray;
@property (nonatomic, strong) NSMutableDictionary * cellDict;
// 存放所有控件的字典
@property (nonatomic, strong) NSMutableDictionary * allViewDic;
// 展示控件的frame数组
@property (nonatomic, strong) NSMutableArray *frameArray;

@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, weak) FormInfo *formInfo;

@property (nonatomic, weak) UIViewController *controller;

//section控件数组
@property (nonatomic, strong) NSMutableArray * sectionData;

@property (nonatomic, strong) UIControl *bgControl;

@end

@implementation CustomTableView

- (instancetype)initWithFrame:(CGRect)frame  Controller:(UIViewController *)controller  formInfo:(FormInfo *) formInfo
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.controller = controller;
        self.formInfo = formInfo;
        self.cellArray = [[NSMutableArray alloc]init];
        self.allViewDic = [[NSMutableDictionary alloc] init];
        self.sectionData = [NSMutableArray array];
        self.estimatedRowHeight = 37.0;
        self.rowHeight = UITableViewAutomaticDimension;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.delegate = self;
        self.dataSource = self;
        [self initTableViewCell];
        [self addSubview:self.bgControl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControl:) name:@"changeControl" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:ValueChange object:nil];
    }
    return self;
}
- (void)initTableViewCell
{
    [self.sectionData removeAllObjects];
    for (int i = 0; i < self.formInfo.sectionArray.count; i ++) {
        FormSectionDescriptor *formRow = self.formInfo.sectionArray[i];
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < formRow.cellArray.count; j ++) {
            FormBaseTableViewCell *cell = formRow.cellArray[j];
            cell.customTableView = self;
            [array addObject:cell];
        }
        [self.sectionData addObject:array];
    }
}
#pragma mark - table view dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormSectionDescriptor *formRow = self.formInfo.sectionArray[indexPath.section];
    FormBaseTableViewCell *cell;
    if (formRow.cellArray.count < 1) {
        ModuleRowInfo *model = formRow.moduleArray[indexPath.row];
        cell = self.cellDict[model.key];
        if (!cell) {
            cell = [formRow creatCustomCell:formRow.moduleArray[indexPath.row]];
            [self.cellDict setObject:cell forKey:model.key];
        }
    } else {
        cell = self.sectionData[indexPath.section][indexPath.row];
    }
    return cell.moduleInfo.isHiddenCell?0.0f:cell.rowH;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    FormSectionDescriptor *group = self.formInfo.sectionArray[section];
    if ([group.groupInfo.viewType isEqualToString:@"CloneView"] && self.formInfo.sectionArray.count == section +1) {
        return 50;
    }else{
        if (self.formInfo.sectionArray.count > 1) {
            return 30;
        }
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FormSectionDescriptor *group = self.formInfo.sectionArray[section];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    CGFloat space = 10;
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor colorWithHEXRGB:0xff6f4d];
    [addButton addTarget:self action:@selector(addNewGroup:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = section;
    addButton.frame = CGRectMake(space, 7, (SCREEN_WIDTH - 30)/2, 36);
    addButton.layer.cornerRadius = 7;
    
    UIButton *deleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleBut setTitle:@"删除" forState:UIControlStateNormal];
    deleBut.backgroundColor = [UIColor colorWithHEXRGB:0x11b7f3];
    deleBut.layer.cornerRadius = 7;
    deleBut.tag = section;
    [deleBut addTarget:self action:@selector(deleteGroup:) forControlEvents:UIControlEventTouchUpInside];
    deleBut.frame = CGRectMake(CGRectGetMaxX(addButton.frame) + space, 7, (SCREEN_WIDTH - 30)/2, 36);
    [bgView addSubview:addButton];
    [bgView addSubview:deleBut];
    
    if ([group.groupInfo.viewType isEqualToString:@"CloneView"] && self.formInfo.sectionArray.count == section +1) {
        return bgView;
    }else{
        if (self.formInfo.sectionArray.count > 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            view.backgroundColor = HUI_COLOR;
        }
        return nil;
    }

}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FormSectionDescriptor *formRow = self.formInfo.sectionArray[section];
    if (formRow.cellArray.count > 0) {
        return formRow.cellArray.count;
    } else {
        return formRow.moduleArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.style == 0) {
        return 1;
    }else{
        return self.formInfo.sectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormSectionDescriptor *formRow = self.formInfo.sectionArray[indexPath.section];
    FormBaseTableViewCell *cell;
    if (formRow.cellArray.count < 1) {
        ModuleRowInfo *model = formRow.moduleArray[indexPath.row];
        cell = self.cellDict[model.key];
        if (!cell) {
            cell = [formRow creatCustomCell:formRow.moduleArray[indexPath.row]];
            [self.cellDict setObject:cell forKey:model.key];
        }
    } else {
        cell = self.sectionData[indexPath.section][indexPath.row];
    }
    if (cell.moduleInfo.isHiddenCell) {
        cell.hidden = YES;
    }
    return cell;
}

-(UIControl *)bgControl
{
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] initWithFrame:self.bounds];
        _bgControl.backgroundColor = [UIColor clearColor];
        _bgControl.enabled = NO;
        _bgControl.alpha = 1;
    }
    return _bgControl;
}

- (NSMutableDictionary *)cellDict {
    if (!_cellDict) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
}
- (void)refreshTableView:(NSNotification *)info
{
    [self reloadData];
}
- (void)changeControl:(NSNotification *)info
{
    
    [self endEditing:YES];
    self.bgControl.enabled = !_bgControl.enabled;
}
//添加新组
- (void)addNewGroup:(UIButton *)sender{
    FormSectionDescriptor *newGroup = [[FormSectionDescriptor alloc] init];
    FormSectionDescriptor *group = self.formInfo.sectionArray[sender.tag];
    for (ModuleRowInfo *row in group.moduleArray) {
        ModuleRowInfo *row1 = [[ModuleRowInfo alloc] init];
        NSDictionary *dic = group.rowDic[row.key];
        if (!dic) {
         continue;
        }
        row1 = [ModuleRowInfo objectWithKeyValues:dic];
        [newGroup addFormRow:row1];
    }
    newGroup.groupInfo = group.groupInfo;
    newGroup.rowDic = group.rowDic;
    [self.formInfo.sectionArray insertObject:newGroup atIndex:sender.tag+1];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initTableViewCell];
        [self reloadData];
    });
//    [self beginUpdates];
//    [self insertSections:[NSIndexSet indexSetWithIndex:self.tag+1] withRowAnimation:UITableViewRowAnimationBottom];
//    [self endUpdates];
    NSLog(@"%zd",sender.tag);
}
- (void)deleteGroup:(UIButton *)sender{
    
    if (self.formInfo.sectionArray.count == 1) {
        UIAlertViewQuick(@"提示", @"最后一条不可删除", @"确定");
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定是否删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    __weak typeof(self) wself = self;
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wself.formInfo.sectionArray removeObjectAtIndex:sender.tag];
        [wself initTableViewCell];
        [wself beginUpdates];
        [wself deleteSections:[NSIndexSet indexSetWithIndex:self.tag] withRowAnimation:UITableViewRowAnimationBottom];
        [wself endUpdates];
        [wself reloadData];
    }];
    [alertVC addAction:cancleAction];
    [alertVC addAction:certainAction];
    [self.controller presentViewController:alertVC animated:YES completion:nil];
}
- (CGFloat)getTableHeight{
    CGFloat allRowH = 0.0;
    for (FormBaseTableViewCell *cell in self.cellDict.allValues) {
        allRowH = cell.rowH + allRowH;
    }
    return allRowH;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.formInfo = nil;
    self.cellArray = nil;
    self.sectionData = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
