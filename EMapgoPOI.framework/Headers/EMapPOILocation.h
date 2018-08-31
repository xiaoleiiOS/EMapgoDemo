//
//  EMapPOILocation.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/8/3.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapPOILocation : NSObject

typedef void (^EMapPOISuccessBlock)(NSDictionary *data);
typedef void (^EMapPOIFailureBlock)(NSError *error);

///经度，单位度
@property (nonatomic, copy) NSString *lon;

///纬度，单位度
@property (nonatomic, copy) NSString *lat;

- (void)startPOILocationWithsuccess:(EMapPOISuccessBlock)successBlock failure:(EMapPOIFailureBlock)failureBlock;

@end
