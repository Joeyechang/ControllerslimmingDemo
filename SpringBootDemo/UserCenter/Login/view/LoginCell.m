//
//  LoginCell.m
//  SpringBootDemo
//
//  Created by chang on 2017/5/31.
//  Copyright © 2017年 chang. All rights reserved.
//

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
