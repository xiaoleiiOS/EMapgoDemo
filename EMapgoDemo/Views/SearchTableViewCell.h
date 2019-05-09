//
//  SearchTableViewCell.h
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EMapgoPOI/EMapgoPOI.h>

@interface SearchTableViewCell : UITableViewCell

@property(nonatomic, copy) EMGFeature *feature;//
@property(nonatomic, copy) void (^roadPlanBlock) (void);//
@end
