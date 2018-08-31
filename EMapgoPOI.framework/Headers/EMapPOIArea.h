//
//  EMapPOIArea.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/8/3.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapPOIArea : NSObject

typedef void (^EMapPOISuccessBlock)(NSDictionary *data);
typedef void (^EMapPOIFailureBlock)(NSError *error);

- (void)startPOIAreaWithsuccess:(EMapPOISuccessBlock)successBlock failure:(EMapPOIFailureBlock)failureBlock;

@end
