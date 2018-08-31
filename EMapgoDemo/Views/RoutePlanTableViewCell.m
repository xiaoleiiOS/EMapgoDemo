//
//  RoutePlanTableViewCell.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/4.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "RoutePlanTableViewCell.h"
#import "EMapgoConfig.h"

@implementation RoutePlanTableViewCell{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _addressImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_addressImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_nameLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_distanceLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _addressImageView.frame = CGRectMake(10, 18, 20, 20);
    _nameLabel.frame = CGRectMake(40, 8, DEF_SCREEN_WIDTH-50, 20);
    _distanceLabel.frame = CGRectMake(40, 28, DEF_SCREEN_WIDTH-50, 20);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
