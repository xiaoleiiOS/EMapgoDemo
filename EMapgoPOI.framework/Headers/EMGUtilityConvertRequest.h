//
//  EMGUtilityConvertRequest.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/23.
//  Copyright © 2019 MaRui. All rights reserved.
//

//#import <EMapgoPOI/EMapgoPOI.h>
#import "EMGBaseRequest.h"
#import "EMGPoint.h"


NS_ASSUME_NONNULL_BEGIN

@interface EMGUtilityConvertRequest : EMGBaseRequest

//坐标对的最大数量为50。
@property (nonatomic, copy) NSArray<EMGPoint *> * coordinates;

//目前只支持json。
@property (nonatomic, copy) NSString * format;

//需要转换的坐标系。目前仅支持：GPS。
@property (nonatomic, copy) NSString * sys;

@end

NS_ASSUME_NONNULL_END
