//
//  ArrayDataSource.h
//  SpringBootDemo
//
//  Created by chang on 2017/5/31.
//  Copyright © 2017年 chang. All rights reserved.
//

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
