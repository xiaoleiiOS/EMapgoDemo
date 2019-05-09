//
//  EMGFeature.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/17.
//  Copyright © 2019 MaRui. All rights reserved.
//


#import "EMGBaseModel.h"

@class EMGGeometry;
@class EMGProperties;

NS_ASSUME_NONNULL_BEGIN

@interface EMGFeature : EMGBaseModel


//搜索结果中的要素类型被定义为“Feature”。
@property (nonatomic, copy) NSString * type;

//返回结果中几何要素的信息。
@property (nonatomic, strong) EMGGeometry * geometry;

//检索结果列表。
@property (nonatomic, strong) EMGProperties * properties;

@end


NS_ASSUME_NONNULL_END

@interface EMGGeometry : EMGBaseModel

//几何点类型。
@property (nonatomic, copy) NSString *type;

//所有的结果都以点集的形式返回，一个或多个，以点坐标数组的格式。
//遵循GeoJSON的规格，以经度，纬度的先后顺序。
//这个坐标指的是显示位置。如果数据有可导航点，则显示在属性中。
@property (nonatomic, copy) NSArray *coordinates;

@end


@interface EMGProperties : EMGBaseModel

//检索结果中的一项的id。
@property (nonatomic, copy) NSString * id;

//在EMG地图数据中，位置类型称为图层，从细到粗不等。
@property (nonatomic, copy) NSString * layer;

//搜索的数据源。
@property (nonatomic, copy) NSString * source;

//关于当前位置的一个简单描述，根据检索的内容而定：
//可能是一个商圈名称，一个当地行政区名称，或者是一段地址。
@property (nonatomic, copy) NSString * name;

//响应结果的街道名称。
@property (nonatomic, copy) NSString * street;

//邮政编码。
@property (nonatomic, copy) NSString * postalcode;

//可信度得分用于衡量返回的结果与输入的检索内容之间的匹配程度。
@property (nonatomic, copy) NSString * confidence;

//距离，单位：千米。
@property (nonatomic, copy) NSString * distance;

//值为point或者centroid。
@property (nonatomic, copy) NSString * accuracy;

//国家或地区。
@property (nonatomic, copy) NSString * country;

//国家或地区的id。
@property (nonatomic, copy) NSString * country_id;

//省份或直辖市。
@property (nonatomic, copy) NSString * region;

//省份或直辖市的id。
@property (nonatomic, copy) NSString * region_id;

//城市，级别上通常大于当地行政区，且小于省份或直辖市。
@property (nonatomic, copy) NSString * county;

//城市的id。
@property (nonatomic, copy) NSString * county_id;

//地方行政区。
@property (nonatomic, copy) NSString * localadmin;

//地方行政区的id。
@property (nonatomic, copy) NSString * localadmin_id;

//镇，村庄，县市。
//查询结果有这一级别的信息时则显示。
@property (nonatomic, copy) NSString * locality;

//比镇，村庄，县市低一级的区域。
//查询结果有这一级别的信息时则显示。
@property (nonatomic, copy) NSString * borough;

//引导点，比如一个poi的入口处。
//查询结果有这一级别的信息时则显示。
@property (nonatomic, copy) NSString * route_point;

//有关当地的人性化的信息。包括一些细节，可用于向最终用户展示。
@property (nonatomic, copy) NSString * label;

//检索结果的类别。只有当检索结果是一个地点且在检索请求中指定了
//类别后才会显示。
@property (nonatomic, copy) NSString * category;

@end
