//
//  NormalCell.m
//  Test
//
//  Created by K.O on 2018/7/20.
//  Copyright © 2018年 rela. All rights reserved.
//

#import "NormalCell.h"

@implementation NormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCategory:(NSString *)category{
    _category = category;
    
    self.lab1.text = category;
    
}

- (void)setInfo:(InfoModel *)info{
    
    _info = info;
    
    if ([self.category isEqualToString:@"仪表/编号设置"]) {
        
        self.lab2.text = info.city;
    }
//   self.categoryAry = @[@"仪表/编号设置",@"报警设置",@"输入选择",@"输入设置",@"显示设置",@"区间",@"省市"];
    
    if ([self.category isEqualToString:@"报警设置"]) {
        self.lab2.text = info.heigh;
    }
    
    if ([self.category isEqualToString:@"输入选择"]) {
        self.lab2.text = info.weight;
    }
    
    if ([self.category isEqualToString:@"输入设置"]) {
        self.lab2.text = info.birthday;
    }
    
    
    if ([self.category isEqualToString:@"显示设置"]) {
        self.lab2.text = info.time;
    }
    
    if ([self.category isEqualToString:@"固件升级"]) {
        self.lab2.text = info.rang;
    }
    
    if ([self.category isEqualToString:@"省市"]) {
        self.lab2.text = info.sex;
    }
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
