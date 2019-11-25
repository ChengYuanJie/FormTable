//
//  TreeSelectViewController.m
//  itfsmlib
//
//  树形结构选择页面
//
//  Created by jcca on 14-4-24.
//  Copyright (c) 2014年 Keyloft.com. All rights reserved.
//

#import "TreeSelectViewController.h"
#import "TreeManager.h"
#import "Database.h"
@interface TreeSelectViewController ()
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) TreeElement *rootElement;
@end

@implementation TreeSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadArray = [[Database shareDB] queryDataWithTableName:self.tableName];
//    self.loadArray = [self dictArrayToElementArrayWithArray:self.loadArray];
//    TreeManager * manager = [TreeManager shareTreeManager];
//    [manager getChildWithElementArray:self.loadArray ParentElement:self.rootElement];
    
    [self buildTreeWithInfo:self.loadArray TreeElement:self.rootElement UseSelectStatus:YES];
    [self.dataArray addObjectsFromArray:self.rootElement.childArray];
    
    
}
- (void)buildTreeWithInfo:(NSArray *)deptInfo TreeElement:(TreeElement *)parentElement UseSelectStatus:(BOOL)useSelectStatus
{
    if (deptInfo && deptInfo.count > 0) {
        for (NSDictionary *dict in deptInfo) {
            NSString *uid = dict[@"guid"];
            NSString *name = dict[@"name"];
            NSString *parent_guid = dict[@"parent_guid"];
            TreeElement *childElement = [[TreeElement alloc]initWithId:uid Name:name Parent:parent_guid];
            childElement.useSelectStatus = useSelectStatus;
            if([dict[@"parent_guid"] isEqualToString:parentElement.uid]){
                [parentElement addChild:childElement];
                [self buildTreeWithInfo:deptInfo TreeElement:childElement UseSelectStatus:useSelectStatus];
            }
        }
    }
}

- (NSArray *)dictArrayToElementArrayWithArray:(NSArray *)array
{
    NSMutableArray * elementArray = [[NSMutableArray alloc]init];
    for (NSDictionary * dict in array) {
        TreeElement * element = [[TreeElement alloc]init];
        element.uid = dict[@"guid"];
        element.name = dict[@"name"];
        element.parentId = dict[@"parentid"];
        [elementArray addObject:element];
    }
    return elementArray;
}

- (TreeElement *)rootElement
{
    if (!_rootElement) {
        _rootElement = [[TreeElement alloc]initWithId:@"" Name:@"root" Parent:nil];
        _rootElement.expanded = YES;
        _rootElement.useSelectStatus = NO;
    }
    return _rootElement;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)objectToChoosed:(UIButton *)btn
{
    TreeElement *element = self.dataArray[btn.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(UIViewControllerDidDisappear:andMessageObject:)]) {
        NSDictionary * dict = @{@"name":element.name,@"id":element.uid};
        [self.delegate UIViewControllerDidDisappear:self andMessageObject:dict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TreeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"table_right_icon"];
        [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(objectToChoosed:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = (CGRect){0,0,40,40};
        cell.accessoryView = btn;
    }
    btn.tag = indexPath.row;
    
    TreeElement * element = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = element.name;
    [cell setIndentationLevel:element.viewLevel];
    if (element.viewLevel == element.maxLevel) {
        cell.imageView.hidden = YES;
    }
    else {
        cell.imageView.hidden = NO;
        
        BOOL isAlreadyInserted = NO;
        for (TreeElement * childElement in element.childList) {
            NSInteger index = [self.dataArray indexOfObjectIdenticalTo:childElement];
            isAlreadyInserted = (index>0 && index != NSIntegerMax);
            if (isAlreadyInserted) {
                cell.imageView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            }
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TreeElement * element = [self.dataArray objectAtIndex:indexPath.row];
    element.childList = element.childArray;
    BOOL isAlreadyInserted = NO;
    if (element.childList.count > 0) {
        for (TreeElement * childElement in element.childList) {
            NSInteger index = [self.dataArray indexOfObjectIdenticalTo:childElement];
            isAlreadyInserted = (index>0 && index != NSIntegerMax);
            if (isAlreadyInserted) {
                break;
            }
        }
        
        if (isAlreadyInserted) {
            [self miniMizeThisRows:element.childList];
            [UIView beginAnimations:@"Transform" context:Nil];
            [UIView setAnimationDuration:.25f];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.transform = CGAffineTransformMakeRotation(0);
            [UIView commitAnimations];
        }
        else {
            NSUInteger count = indexPath.row + 1;
            NSMutableArray * array = [[NSMutableArray alloc]init];
            for (TreeElement * childElement in element.childList) {
                [array addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.dataArray insertObject:childElement atIndex:count];
                count ++;
            }
            [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
            
            [UIView beginAnimations:@"Transform" context:Nil];
            [UIView setAnimationDuration:.25f];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            [UIView commitAnimations];
            
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(UIViewControllerDidDisappear:andMessageObject:)]) {
            NSDictionary * dict = @{@"name":element.name,@"guid":element.uid};
            [self.delegate UIViewControllerDidDisappear:self andMessageObject:dict];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)miniMizeThisRows:(NSArray *)array
{
    for (TreeElement * element in array) {
        NSUInteger indexToRemove = [self.dataArray indexOfObjectIdenticalTo:element];
        if (element.childList && element.childList.count > 0) {
            [self miniMizeThisRows:element.childList];
        }
        
        if ([self.dataArray indexOfObjectIdenticalTo:element] != NSNotFound) {
            [self.dataArray removeObject:element];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
