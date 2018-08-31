//
//  EMapgoConfig.h
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapgoConfig : NSObject

#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width//屏宽
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height//屏高
#define StatusBarTHeight (DEF_SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define SafeAreaTopHeight (DEF_SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (DEF_SCREEN_HEIGHT == 812.0 ? 34 : 0)
#define SafeAreaScrollHeight (DEF_SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight)//有导航无tabbar时滚动试图的全屏高
/**
 *  宽度比例系数-6s
 */
#define DEF_WIDTH_RATIO   [[UIScreen mainScreen] bounds].size.width/375

/**
 *  返回颜色
 *
 *  @param color 字符串的16进制的颜色
 *
 *  @return UIColor对象
 */
#define getColor(color) [UIColor colorWithRed:((float)((strtoul([color UTF8String],0,16) & 0xFF0000) >> 16))/255.0 green:((float)((strtoul([color UTF8String],0,16) & 0xFF00) >> 8))/255.0 blue:((float)(strtoul([color UTF8String],0,16) & 0xFF))/255.0 alpha:1.0]

/**
 *    生成RGBA颜色
 *
 *    @param     red     red值（0~255）
 *    @param     green     green值（0~255）
 *    @param     blue     blue值（0~255）
 *    @param     alpha     blue值（0~1）
 *
 *    @return    UIColor对象
 */
#define DEF_RGBA_COLOR(_red, _green, _blue, _alpha) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:(_alpha)]

/**
 *    永久存储对象
 *
 *  NSUserDefaults保存的文件在tmp文件夹里
 *
 *    @param    object      需存储的对象
 *    @param    key         对应的key
 */
#define DEF_PERSISTENT_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];                                                                          \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})

/**
 *    取出永久存储的对象
 *
 *    @param    key     所需对象对应的key
 *    @return    key     所对应的对象
 */
#define DEF_PERSISTENT_GET_OBJECT(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
@end
