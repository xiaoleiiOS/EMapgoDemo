//
//  EMapRoadPlaning.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/30.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMapgoRouteStepModel.h"

@interface EMapRoadPlanning : NSObject

typedef void (^EMapRoadPlanSuccessBlock)(NSDictionary *data);
typedef void (^EMapRoadPlanFailureBlock)(NSError *error);

typedef void (^EMapLocationIsContainSuccessBlock)(NSDictionary *data);
typedef void (^EMapLocationIsContainFailureBlock)(NSError *error);


//起始点坐标点，必须包含经纬度
@property (nonatomic, strong) EMapgoRouteStepModel *startModel;

//终点坐标点，必须包含经纬度
@property (nonatomic, strong) EMapgoRouteStepModel *endModel;

//Routing profile; either  driving1 ,  walking1 , or  transit
@property (nonatomic, copy) NSString *profile;

//Semicolon-separated list of  {longitude},{latitude} coordinate pairs to visit in order. There can be between 2 and 25 coordinates.
//传入格式为 NSArray *arr = @[@{@"longitude":@"",@"latitude":@""},@{@"longitude":@"",@"latitude":@""}];
@property (nonatomic, copy) NSArray *coordinates;

//Whether to try to return alternative routes. An alternative is classified as a route that is significantly different than the fastest route, but also still reasonably fast. Such a route does not exist in all circumstances. Currently up to two alternatives can be returned. Can be  true or  false (default).
@property (nonatomic, copy) NSString *alternatives;

///Format of the returned geometry. Allowed values are: geojson (as LineString ),  polyline with precision 5, polyline6 (a polyline with precision 6). The default value is polyline .
@property (nonatomic, copy) NSString *geometries;

//Whether to return steps and turn-by-turn instructions. Can be true or  false . The default is  false .
@property (nonatomic, copy) NSString *steps;

///Type of returned overview geometry. Can be  full (the most detailed geometry available),  simplified (a simplified version of the full geometry), or  false (no overview geometry). The default is  simplified .
@property (nonatomic, copy) NSString *overview;

//Whether or not to return additional metadata along the route. Possible values are:  duration ,  distance ,  speed , and  congestion . Several annotations can be used by including them as a comma-separated list. See the RouteLeg object for more details on what is included with annotations.
@property (nonatomic, copy) NSString *annotations;

//Used to indicate how requested routes consider from which side of the road to approach a waypoint. Accepts unrestricted (default) or  curb . If set to  unrestricted , the routes can approach waypoints from either side of the road. If set to  curb , the route will be returned so that on arrival, the waypoint will be found on the side that corresponds with the  driving_side of the region in which the returned route is located. Note that the  approaches parameter influences how you arrive at a waypoint, while bearings influences how you start from a waypoint. If provided, the list of approaches must be the same length as the list of waypoints. However, you can skip a coordinate and show its position in the list with the  ; separator.
@property (nonatomic, copy) NSString *approaches;

///Whether or not to return banner objects associated with the routeSteps . Should be used in conjunction with  steps . Can be  true or  false . The default is  false
@property (nonatomic, copy) NSString *banner_instructions;

//Used to filter the road segment the waypoint will be placed on by direction and dictates the angle of approach. This option should always be used in conjunction with the radiuses parameter. The parameter takes two values per waypoint. The first value is an angle clockwise from true north between 0 and 360, and the second is the range of degrees the angle can deviate by. The recommended value for the range is 45° or 90°, as bearing measurements tend to be inaccurate. This is useful for making sure the new routes of rerouted vehicles continue traveling in their current direction. A request that does this would provide bearing and radius values for the first waypoint and leave the remaining values empty. If provided, the list of bearings must be the same length as the list of waypoints. However, you can skip a coordinate and show its position in the list with the  ; separator.
@property(nonatomic, copy) NSString *bearings;

//Sets the allowed direction of travel when departing intermediate waypoints. If  true , the route will continue in the same direction of travel. If  false , the route may continue in the opposite direction of travel. Defaults to  true for  mapbox/driving and  false for  mapbox/walking and  mapbox/cycling .
@property(nonatomic, copy) NSString *continue_straight;

//Exclude certain road types from routing. Valid values depend on the profile in use. See below for valid  exclude values. The default is to not exclude anything from the profile selected.
@property(nonatomic, copy) NSString *exclude;

//Maximum distance in meters that each coordinate is allowed to move when snapped to a nearby road segment. There must be as many radiuses as there are coordinates in the request, each separated by  ; . Values can be any number greater than 0 or the string  unlimited . A  NoSegment error is returned if no routable road is found within the radius.
@property(nonatomic, copy) NSString *radiuses;

///Emit instructions at roundabout exits. Can be  true or false . The default is  false .
@property (nonatomic, copy) NSString *roundabout_exits;

//Whether or not to return SSML marked-up text for voice guidance along the route. Should be used in conjunction with steps . Can be  true or  false . The default is  false
@property(nonatomic, copy) NSString *voice_instructions;

//Which type of units to return in the text for voice instructions. Can be  imperial or  metric . Default is  imperial .
@property(nonatomic, copy) NSString *voice_units;

//Custom names for waypoints used for the arrival instruction in banners and voice instructions, each separated by  ; . Values can be any string and total number of all characters cannot exceed 500. If provided, the list of waypoint_names must be the same length as the list of waypoints, but you can skip a coordinate and show its position with the  ; separator.
@property(nonatomic, copy) NSString *waypoint_names;

//Language of returned turn-by-turn text instructions. See supported languages . The default is  en for English.
@property(nonatomic, copy) NSString *language;

- (void)startRoadPlanningWithsuccess:(EMapRoadPlanSuccessBlock)successBlock failure:(EMapRoadPlanFailureBlock)failureBlock;



/**
 根据起始点和终点，规划出在景区的路线方案，并返回路线数据和路线类型

 注：必须包含起始点和终点的经纬度，才可以调用
 @param successBlock 成功回调---返回数据(路线数据："data", and 路线方案："profile")
 @param failureBlock 失败回调
 */
- (void)roadPlanningInWuzhenSuccess:(EMapRoadPlanSuccessBlock)successBlock failure:(EMapRoadPlanFailureBlock)failureBlock;

/**
 查询坐标点是否在范围之内

 @param lon 经度，单位度
 @param lat 纬度，单位度
 @param startend 开始或者结束，可以配置start，或者是end
 @param successBlock 成功回调---返回转换后的位置
 @param failureBlock 失败回调
 */
- (void)searchLocationIsContainWithLon:(NSString *)lon lat:(NSString *)lat startend:(NSString *)startend success:(EMapLocationIsContainSuccessBlock)successBlock failure:(EMapLocationIsContainFailureBlock)failureBlock;

@end
