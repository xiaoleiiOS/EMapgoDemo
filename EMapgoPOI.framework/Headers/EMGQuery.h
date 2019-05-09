//
//  EMGQuery.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/17.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import "EMGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMGQuery : EMGBaseModel

//您要搜索的地名。
@property (nonatomic, copy) NSString * text;

//设置返回的结果数。如果需要不同数量的结果，请将此参数设置为所需数量。默认值为10，最大值为40。若设定值大于40，查询结果会按照最大值40进行返回，并在响应元数据中返回警告信息。
@property (nonatomic, copy) NSString * size;

//在EMG地图数据中，位置类型称为图层，从细到粗不等。仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * layers;

//基于位置优先搜索时的纬度数值。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * focus_point_lat;

//基于位置优先搜索时的经度数值。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * focus_point_lon;

//要使用矩形指定边界，您需要边界框的两个对角线的纬度、经度坐标（最小和最大纬度、经度）。此参数用于指示矩形的最小经度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_rect_min_lon;

//要使用矩形指定边界，需要边界框的两条对角线的纬度、经度坐标（最小和最大纬度、经度）。此参数用于指示矩形的最大经度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_rect_max_lon;

//要使用矩形指定边界，需要边界框的两条对角线的纬度、经度坐标（最小和最大纬度、经度）。此参数用于指示矩形的最小纬度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_rect_min_lat;

//要使用矩形指定边界，需要边界框的两条对角线的纬度、经度坐标（最小和最大纬度、经度）。此参数用于指示矩形的最大纬度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_rect_max_lat;

//在圆形区域内搜索，此参数用于指示圆心的纬度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_circle_lat;

//在圆形区域内搜索，此参数用于指示圆心的经度。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_circle_lon;

//在圆形区域内搜索。此参数表示圆的半径，单位是公里。
//仅当用户在请求中指定时有效。
@property (nonatomic, copy) NSString * boundary_circle_radius;

//语言类型。目前仅支持中文。
@property (nonatomic, strong) NSDictionary * lang;

//querySize=2*size
//默认值为20。（最小值为20，最大值为80）
@property (nonatomic, copy) NSString * querySize;

//用于处理搜索文本的工具，可选libpostal或者 addressit。
@property (nonatomic, copy) NSString * parser;

//地址信息
@property (nonatomic, copy) NSDictionary *parsed_text;

@property (nonatomic, copy) NSString *isPrivate;
@end

NS_ASSUME_NONNULL_END
