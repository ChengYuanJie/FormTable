//
//  FormTableView.m
//  THStandardEdition
//
//  Created by Aaron on 2018/12/20.
//  Copyright © 2018年 程元杰. All rights reserved.
//

#import "FormTableView.h"
#import "FormBaseCell.h"
@interface FormTableView()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation FormTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 50;
        self.tableFooterView = [UIView new];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
- (void)setFormInfo:(FormObject *)formInfo{
    _formInfo = formInfo;
    FormBaseCell *lastCell;
    for (FormBaseCell *cell in formInfo.cellArray) {
        if ([cell.type containsString:@"Group"]) {
            lastCell.showBottom = NO;
        }
        lastCell = cell;
    }
    [self reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formInfo.cellArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FormBaseCell *cell = self.formInfo.cellArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FormBaseCell *cell = self.formInfo.cellArray[indexPath.row];
    if (cell.isHiddenCell) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
