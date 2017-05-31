###ViewController 瘦身实践

当ViewController要实现UITableView DataSource时，很多时候cell的展示样式都是一样的，如果把很多业务逻辑都写进ViewController，ViewController 会臃肿，且很多代码都是重复的。出于使用最少的代码实现最多的功能之目的，可以将ITableView DataSource抽取出来，这样很多ViewController可以共用一个自定义的DataSource，不单可以节省很多代码，ViewController也显得清洁好看。

#### 将 DataSource 从 ViewController 中进行抽离示例：

##### 1、抽取的dataSource形如这样：
ArrayDataSource.h

```
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlockWithItem)(id cell, id item);//因为要复用，所以要写成id类型


@interface ArrayDataSource : NSObject<UITableViewDataSource>

@property(nonatomic,strong) NSArray  *items;
@property(nonatomic,strong) NSString *cellIdentifier;
@property(nonatomic,copy) TableViewCellConfigureBlockWithItem configureCellBlock;

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlockWithItem)aConfigureCellBlock;

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end
```

ArrayDataSource.m:

```
#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@end

@implementation ArrayDataSource
@synthesize items,cellIdentifier;

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlockWithItem)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}


- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
 
    self.configureCellBlock(cell,item);

    return cell;
}


- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger) indexPath.row];
}

@end

```

##### 2、ViewController 形如这样：

LoginViewController.m:

```
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
```
##### 3、抽取的 LoginCell 形如这样：

LoginCell.h:

```
#import <UIKit/UIKit.h>
#import "LoginCellModel.h"

@interface LoginCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImgView;
@property (weak, nonatomic) IBOutlet UITextField *myTxtField;

-(void)setContent:(LoginCellModel *)model;

@end
```

LoginCell.m:

```
#import "LoginCell.h"

@implementation LoginCell

- (void)awakeFromNib {
    [super awakeFromNib];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Custom Methods
-(void)setContent:(LoginCellModel *)model{   
    self.myImgView.image = [UIImage imageNamed:model.imageName];
    self.myTxtField.placeholder = model.placeHolderStr;
}
@end
```

##### 4、使用到的model形如：

```
#import <Foundation/Foundation.h>
@interface LoginCellModel : NSObject
@property(nonatomic,strong) NSString * imageName;
@property(nonatomic,strong) NSString * placeHolderStr;
@end

```

[demo下载地址：]()

