//
//  FunctionViewController.h
//  EMapgoTest
//
//  Created by MaRui on 2018/6/4.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionViewController : UIViewController
@property(nonatomic, copy) void(^selectBlock) (NSInteger index);//
@end
