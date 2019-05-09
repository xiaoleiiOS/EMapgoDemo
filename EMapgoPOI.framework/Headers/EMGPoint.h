//
//  EMGPoint.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/23.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface EMGPoint : NSObject


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//经度
@property (nonatomic, assign) double longitude;

//纬度
@property (nonatomic, assign) double latitude;

//
+ (instancetype)pointWithLocation:(CLLocationCoordinate2D)coordinate;

+ (instancetype)locationWithLatitude:(double)latitude longitude:(double)longitude;

@end

NS_ASSUME_NONNULL_END
