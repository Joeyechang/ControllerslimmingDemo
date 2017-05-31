//
//  LoginCell.h
//  SpringBootDemo
//
//  Created by chang on 2017/5/31.
//  Copyright © 2017年 chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginCellModel.h"

@interface LoginCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImgView;
@property (weak, nonatomic) IBOutlet UITextField *myTxtField;

-(void)setContent:(LoginCellModel *)model;

@end
