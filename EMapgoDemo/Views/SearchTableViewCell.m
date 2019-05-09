//
//  SearchTableViewCell.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "EMapgoConfig.h"

@implementation SearchTableViewCell{
    UIImageView *_addressImageView;
    UILabel *_nameLabel;
    UILabel *_distanceLabel;
    UILabel *_addressLabel;
    UIButton *_roadButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address"]];
        [self.contentView addSubview:_addressImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_nameLabel];
        
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        _distanceLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_distanceLabel];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_addressLabel];
        
        _roadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_roadButton setImage:[UIImage imageNamed:@"roadImage"] forState:UIControlStateNormal];
        _roadButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_roadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_roadButton setTitle:@"路线" forState:UIControlStateNormal];
        [_roadButton addTarget:self action:@selector(roadPlanAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_roadButton];
    }
    return self;
}

- (void)roadPlanAction:(UIButton *)btn{
    if (_roadPlanBlock) {
        self.roadPlanBlock();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _addressImageView.frame = CGRectMake(10, 18, 20, 20);
    _nameLabel.frame = CGRectMake(40, 8, DEF_SCREEN_WIDTH-160, 20);
    _distanceLabel.frame = CGRectMake(DEF_SCREEN_WIDTH-120, 8, 70, 20);
    _addressLabel.frame = CGRectMake(40, 28, DEF_SCREEN_WIDTH-90, 20);
    _roadButton.frame = CGRectMake(DEF_SCREEN_WIDTH-50, 0, 50, 56);
//    [self initButton:_roadButton];
    _roadButton.imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, -20);
    _roadButton.titleEdgeInsets = UIEdgeInsetsMake(30, -37, 0, 0);
}

- (void)setFeature:(EMGFeature *)feature{
    
    _feature = feature;
    
    _nameLabel.text = _feature.properties.name;
    
    float kMeter = [_feature.properties.distance floatValue];
    if (kMeter >= 1) {
        _distanceLabel.text = [NSString stringWithFormat:@"%.2f千米", kMeter];
    }else{
        _distanceLabel.text = [NSString stringWithFormat:@"%f米", kMeter * 1000];
    }
    //    _distanceLabel.text = [NSString stringWithFormat:@"%@米", dataDic[@"distance"]];
    _addressLabel.text = _feature.properties.label;
}

//上图片下文字按钮
- (void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-25, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
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
