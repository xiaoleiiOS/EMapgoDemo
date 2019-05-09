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
        //        [self.contentView addSubview:_introduceImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_nameLabel];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:10];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.contentView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:10];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:-10];
        
        [self.contentView addConstraints:@[top, left, right, bottom]];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    _introduceImageView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 265*DEF_WIDTH_RATIO);
    //    _introduceImageView.frame = CGRectMake(0, 0, 0, 0);
    
    
    [self updateConstraints];
    //    _nameLabel.frame = CGRectMake(10, _introduceImageView.frame.size.height, DEF_SCREEN_WIDTH-20, 40);
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
