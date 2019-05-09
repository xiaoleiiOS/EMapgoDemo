//
//  EMapPOISearch.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/30.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMapgoPOI/EMGSearchModel.h>

@interface EMapPOISearch : NSObject

typedef void (^EMapPOISearchSuccessBlock)(EMGSearchModel *searchModel);
typedef void (^EMapPOISearchFailureBlock)(NSError *error);

//获取API服务的URL。
@property (nonatomic, copy) NSString *URL;

//API服务版本号，当前值是V1。
@property (nonatomic, copy) NSString *version;

///搜索关键字
@property (nonatomic, copy) NSString *text;

///经度，单位度
@property (nonatomic, copy) NSString *focus_point_lon;

///纬度，单位度
@property (nonatomic, copy) NSString *focus_point_lat;

//要使用矩形指定边界，您需要边界框的两个对角线的纬度，经度坐标（最小和最大纬度、经度）。此参数用于指示矩形的最小经度。
@property (nonatomic, copy) NSString *boundaryRectMin_lon;

@property (nonatomic, copy) NSString *boundaryRectMax_lon;

@property (nonatomic, copy) NSString *boundaryRectMin_lat;

@property (nonatomic, copy) NSString *boundaryRectMax_lat;


//在圆形区域内搜索，此参数用于指示圆心的纬度。
@property (nonatomic, copy) NSString *boundaryCircle_lat;
//在圆形区域内搜索。此参数用于指示圆心的经度。
@property (nonatomic, copy) NSString *boundaryCircle_lon;
//在圆形区域内搜索。此参数表示圆的半径，单位是公里。
@property (nonatomic, copy) NSString *boundaryCircle_radius;

//在EMG地图数据中，位置类型称为图层，从细到粗不等。可以设置如参数：
//venue    兴趣点（POI）
//address    点地址（门牌号）
//street    街道、道路、高速公路
//localadmin    地区、城市
//county    地级市
//region    省、自治区、直辖市和特别行政区
//
//对于地理编码服务而言，layers = @[@"street", @"address"]的参数是强制指定的。
//对于POI检索服务而言，layers = @[@"venue"]的参数是强制指定的。
@property (nonatomic, strong) NSArray<NSString *> *layers;

//置返回的结果数。如果需要不同数量的结果，请将此参数设置为所需数量。大小的默认值为10，最大值为40。指定大于40的值将重写为40，并在响应元数据中返回警告。
@property (nonatomic, copy) NSString *size;

//标识，默认“”，如“加油站”。
@property(nonatomic, copy) NSArray<NSString *> *categories;


/**
 周边检索和反向地理编码的参数配置，属性是必须的。
 */
@property (nonatomic, copy) NSString *point_lat;
@property (nonatomic, copy) NSString *point_lon;


#pragma mark - 一框搜索

/**
 一框搜索

 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
- (void)searchSingleWithsuccess:(EMapPOISearchSuccessBlock)successBlock failure:(EMapPOISearchFailureBlock)failureBlock;


#pragma mark - 结构化地理编码

//地址
@property (nonatomic, copy) NSString *address;

//区，城市
@property (nonatomic, copy) NSString *locality;

//地级市
@property (nonatomic, copy) NSString *county;

//省，自治区，直辖市和特别行政区
@property (nonatomic, copy) NSString *region;

/**
 结构化地理编码
 
 借助结构化地理编码，你可以搜索一个地区的任意一个地点。结构化地理编码能够帮助改进你在一个搜索中所输入的信息。

 @param successBlock successBlock description
 @param failureBlock failureBlock description
 结构化地理编码可配置的参数如下：
 address、locality、county、region
 
 */
- (void)searchStructuredWithsuccess:(EMapPOISearchSuccessBlock)successBlock failure:(EMapPOISearchFailureBlock)failureBlock;


#pragma mark - 反向地理编码

/**
 反向地理编码
 
 反向地理编码可用于根据经纬度坐标寻找附近的地点或地址。类似于点选地图后，查看所选位置的相关信息。

 @param successBlock successBlock description
 @param failureBlock failureBlock description
 反向地理编码可配置的参数如下：
 point_lat、point_lon、boundaryCircle_radius、layers（venue、address、street）、size
 
 */
- (void)searchReverseWithsuccess:(EMapPOISearchSuccessBlock)successBlock failure:(EMapPOISearchFailureBlock)failureBlock;


#pragma mark - 搜索建议

/**
 搜索建议
 
 如果你正在构建一个面向最终用户的应用程序，你可以使用搜索建议功能来实现实时反馈的效果。这个输入提示的功能能够帮助用户发现他们的搜索意图，而且使得用户免于完整的输入他们的查询词。例如：当用户开始输入时，一个下拉列表展示出来，供用户选择。
 
 为了构建一个实现搜索建议的查询，你需要提供一个用户在你的应用里输入的文本参数，你还可以再提供用户当前聚焦位置的参数，这会使得用户能够看到当地周边的提示信息。

 搜索建议可配置的参数如下：
 text、focus_point_lat、focus_point_lon、boundary_rect_min_lon、boundary_rect_max_lon、boundary_rect_min_lat、boundary_rect_max_lat、layers（venue、address、street、localadmin、county、region）
 
 @param successBlock successBlock description
 @param failureBlock failureBlock description
 */
- (void)searchAutocompleteWithsuccess:(EMapPOISearchSuccessBlock)successBlock failure:(EMapPOISearchFailureBlock)failureBlock;


#pragma mark - 周边检索

/**
 周边检索

 @param successBlock successBlock description
 @param failureBlock failureBlock description
 
 周边检索可配置的参数如下：
 point_lat、point_lon、boundaryCircle_radius、layers（venue、address、street）、categories、size
 
 */
- (void)searchNearbyWithsuccess:(EMapPOISearchSuccessBlock)successBlock failure:(EMapPOISearchFailureBlock)failureBlock;

@end
