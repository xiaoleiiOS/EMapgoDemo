//
//  SearchView.h
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
- (void)showInView:(UIView *)view;
@property(nonatomic, copy) void (^goRoadBlock) (NSDictionary *addressInfo);//
@end
