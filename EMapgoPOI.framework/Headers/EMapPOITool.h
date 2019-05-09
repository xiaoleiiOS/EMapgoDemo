//
//  EMapPOITool.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/23.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMGUtilityConvertRequest.h"


typedef void (^EMapPOISuccessBlock)(NSDictionary *data);
typedef void (^EMapPOIFailureBlock)(NSError *error);


NS_ASSUME_NONNULL_BEGIN

@interface EMapPOITool : NSObject


/**
 坐标转换
 坐标转换接口提供将GPS坐标转换为EMG坐标的方法。

 @param request 请求request
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)EMGUtilityConvert:(EMGUtilityConvertRequest *)request success:(EMapPOISuccessBlock)successBlock failure:(EMapPOIFailureBlock)failureBlock;



@end

NS_ASSUME_NONNULL_END
