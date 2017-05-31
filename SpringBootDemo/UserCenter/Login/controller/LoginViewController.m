//
//  LoginViewController.m
//  SpringBootDemo
//
//  Created by chang on 2017/5/31.
//  Copyright © 2017年 chang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"
#import "ArrayDataSource.h"
#import "LoginCellModel.h"

@interface LoginViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) ArrayDataSource * arrayDataSource;

@end

@implementation LoginViewController
@synthesize arrayDataSource;

#pragma mark - UIView LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (^configureCell)(LoginCell *cell,LoginCellModel *cellModel) = ^(LoginCell* cell,LoginCellModel *cellModel) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setContent:cellModel];
    };
    NSString *cellIndentifier = @"Cell";
    NSArray *items = [self createCellModels];
    
    // 需要注册，否则会crash
    [self.myTableView registerNib:[UINib nibWithNibName:@"LoginCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    
    arrayDataSource = [[ArrayDataSource alloc] initWithItems:items
                                              cellIdentifier:cellIndentifier
                                          configureCellBlock:configureCell];
    [self customTableViewShowStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - custom methods 
-(NSArray *)createCellModels {

    LoginCellModel * nameModel = [[LoginCellModel alloc] init];
    nameModel.imageName = @"uid";
    nameModel.placeHolderStr = @"请输入用户名";
    
    LoginCellModel * pwdModel = [[LoginCellModel alloc] init];
    pwdModel.imageName = @"pwd";
    pwdModel.placeHolderStr = @"请输入登录密码";
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    [items addObject:nameModel];
    [items addObject:pwdModel];
    return items;
    
}

#pragma mark - 设置TableView显示样式
-(void)customTableViewShowStyle {
    self.myTableView.dataSource = arrayDataSource;
    
    self.myTableView.tableHeaderView = [[UIView alloc] init];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    self.myTableView.scrollEnabled = NO;
    
    //1.调整(iOS7以上)表格分隔线边距
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.myTableView.separatorInset = UIEdgeInsetsZero;
    }
    //2.调整(iOS8以上)view边距(或者在cell中设置preservesSuperviewLayoutMargins,二者等效)
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.myTableView.layoutMargins = UIEdgeInsetsZero;
    }
}

@end
