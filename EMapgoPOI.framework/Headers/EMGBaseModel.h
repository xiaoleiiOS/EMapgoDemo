//
//  BaseModel.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/16.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMGBaseModel : NSObject

//转model
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

//属性为字典类时，配置
- (id)dictWithClassName:(NSString *)className key:(NSString *)key;

//属性为数组时，配置
- (NSArray *)arrayWithClassName:(NSString *)className key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
