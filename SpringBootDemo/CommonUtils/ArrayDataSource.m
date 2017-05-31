//
//  ArrayDataSource.m
//  SpringBootDemo
//
//  Created by chang on 2017/5/31.
//  Copyright © 2017年 chang. All rights reserved.
//

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
