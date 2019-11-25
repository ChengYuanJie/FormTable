//
//  FormBaseTableViewCell.m
//  itfsm-Manager
//
//  Created by Aaron on 16/7/14.
//  Copyright © 2016年 程元杰. All rights reserved.
//

#import "FormBaseTableViewCell.h"
@interface FormBaseTableViewCell()
@property (nonatomic, strong) UIView *bottomView;
@end
@implementation FormBaseTableViewCell

- (instancetype)initWithRowDescriptor:(ModuleRowInfo *)moduleInfo
{
    self.moduleInfo = nil;
    static int count = 0;
    NSString * str = [NSString stringWithFormat:@"NewCustomCell%d",count];
    count ++;
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.moduleInfo = [[ModuleRowInfo alloc] init];
        self.chainModel = [[ValueChainModel alloc] init];
        self.moduleInfo = moduleInfo;
        if (moduleInfo.unInteractionEnabled) {
            self.userInteractionEnabled = NO;
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickViewFromWindou:) name:RemovePickView object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vlueChangeWithKey:) name:PostValue object:nil];
        self.value = moduleInfo.value;
        self.xLabel = [[UILabel alloc] initWithFrame:CGRectMake(8*SCREEN_WIDTH_RATIO, 18*SCREEN_HEIGHT_RATIO, 10, 10)];
        self.xLabel.text = @"*";
        self.xLabel.textColor  = [UIColor redColor];
        [self.contentView addSubview:self.xLabel];
        if (!self.moduleInfo.required){
            self.xLabel.hidden = YES;
        }
        [self creatUI];
        if (self.moduleInfo.useDefault) {
         [self setDefaultValue];
        }
        self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView.backgroundColor = HUI_COLOR;
        if (self.moduleInfo.showBottom) {
            self.bottomH = 10;
            [self hiddenCellSeperate];
        }
        [self addSubview:self.bottomView];
        if (self.moduleInfo.hiddenSeperate) {
            [self hiddenCellSeperate];
        }
    }
    return self;
}
- (void)hiddenCellSeperate{
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(self.bottomH);
    }];
}
- (void)creatUI
{
}
//设置下拉框默认值,默认为上次选中的值
- (void)setDefaultValue{
}
- (void)readFormSetValueWithDic:(NSDictionary *)valueDic{
  
    
}

- (void)setValue:(NSString *)value{
    _value = value;
    self.chainModel.value = value;
    self.chainModel.postKey = self.moduleInfo.key;
    if (!self.moduleInfo.changeAware) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PostValue object:self.chainModel];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)vlueChangeWithKey:(NSNotification *)info
{
//    接受的postValue
    ValueChainModel *model = [[ValueChainModel alloc] init];
    model = info.object;
    ModuleRowInfo *moduleInfo = nil;
    if ([self.delegate respondsToSelector:@selector(handlePostValue:)]) {
       moduleInfo = [self.delegate handlePostValue:model];
    }
    if (moduleInfo == nil) {
        return;
    }
    if ([self.moduleInfo.key isEqualToString:moduleInfo.key]) {
        self.moduleInfo.value = moduleInfo.value;
        [self setNeedsLayout];
    }
}
- (void)sendNotificationWithObject:(id)object userInfo:(NSDictionary *)userInfo
{
    NSNotification *notification = [[NSNotification alloc] initWithName:PostValue object:object userInfo:userInfo];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnSender forModes:nil];
}
- (void)removePickViewFromWindou:(NSNotification *)info
{
    
}
- (void)reloadCell{

    self.customTableView = self.tableView;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self];
    [self.customTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [self.customTableView beginUpdates];
    [self.customTableView endUpdates];
    [self.customTableView reloadData];
}
- (UITableView *)tableView

{
    
    UIView *tableView = self.superview;
    
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        
        tableView = tableView.superview;
        
    }
    
    return (UITableView *)tableView;
    
}
-(CGFloat)rowH{
    if (self.moduleInfo.showBottom) {
        return _rowH + 15;
    }
    return _rowH;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
