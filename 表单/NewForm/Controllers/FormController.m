//
//  FormController.m
//  THStandardEdition
//
//  Created by Noah on 2018/11/12.
//  Copyright © 2018 程元杰. All rights reserved.
//

#import "FormController.h"
#import "FormObject.h"
#import "FormBaseCell.h"
#import "WorkflowPanel.h"
#import "ProcessInfoPanel.h"
@interface FormController ()
@property (nonatomic, strong) FormTableView *formTableView;
@property (nonatomic, strong) WorkflowPanel *workflowPanel;
@property (nonatomic, strong) ProcessInfoPanel *processInfoPanel;
@property (nonatomic, strong) NSDictionary *netValues;
@property (nonatomic, strong) AuditorCell *auditorCell;

@end

@implementation FormController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpConfig];
}
- (void)setUpConfig{
    switch (_formModel) {
        case FORM_TABLE_SUBMIT_LOCAL:
            [self creatRightBtnItem];
        {
            [FormManager creatByFormJson:[self formJson] complete:^(FormObject *object) {
                self.formTableView.formInfo = object;
            }];
        }
            break;
        case FORM_TABLE_SUBMIT_NET:
            [self creatRightBtnItem];
        {
            [FormManager creatByFormId:self.formId complete:^(FormObject *object) {
                self.formTableView.formInfo = object;
            }];
        }
            break;
        case FORM_TABLE_DETAIL_LOCAL:
        {
            [FormManager getFormFetchByFormId:self.formId formGuid:self.formGuid formJson:[self formJson] complete:^(FormObject *object) {
                object.readonly = YES;
            }];
        }
            break;
        case FORM_TABLE_DETAIL_NET:
        {
            [FormManager getFormFetchByFormId:self.formId formGuid:self.formGuid formJson:nil complete:^(FormObject *object) {
                object.readonly = YES;
            }];
        }
            break;
        default:
            break;
    }
}
- (void)creatRightBtnItem{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 20);
    rightButton.titleLabel.font = Fount14;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(didClickSubmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)didClickSetValue{
    NSDictionary *dic = [STANDARD_USER_DEFAULT objectForKey:@"defalt_Value"];
    self.formTableView.formInfo.netValues = dic;
}
- (void)didClickSubmit {
    [FormManager submitNormolData:self.formTableView.formInfo complete:^(BOOL succ) {
        if (succ) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (NSString *)formJson {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:self.formId?:@"iOS_Form" ofType:nil];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}
- (FormTableView *)formTableView{
    if (!_formTableView) {
        _formTableView = [[FormTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        [self.view addSubview:_formTableView];
    }
    return _formTableView;
}
@end
