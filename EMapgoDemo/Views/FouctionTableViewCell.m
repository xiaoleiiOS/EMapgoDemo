//
//  FouctionTableViewCell.m
//  EMapgoTest
//
//  Created by MaRui on 2018/7/26.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "FouctionTableViewCell.h"
#import "EMapgoConfig.h"

@implementation FouctionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _introduceImageView = [[UIImageView alloc] init];
        _introduceImageView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_introduceImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _introduceImageView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 265*DEF_WIDTH_RATIO);
    _nameLabel.frame = CGRectMake(10, _introduceImageView.frame.size.height, DEF_SCREEN_WIDTH-20, 40);
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
