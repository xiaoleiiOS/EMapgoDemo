//
//  EMapPOISearch.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/30.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapPOISearch : NSObject

typedef void (^EMapPOISuccessBlock)(NSDictionary *data);
typedef void (^EMapPOIFailureBlock)(NSError *error);

//城市、区县,默认“0”，若id<=0且uid<=0且lon<=0且lat<=0则此参数必须有值，如310000，可通过getareaid方法获得
@property (nonatomic, copy) NSString *area;

///搜索关键字
@property (nonatomic, copy) NSString *q;

/*
 查询的类型
 默认“0”
 0：仅返回查询结果总记录数
 1：返回查询结果
 2：仅返回查询结果的id列表
 */
@property (nonatomic, copy) NSString *type;

///经度，单位度
@property (nonatomic, copy) NSString *lon;

///纬度，单位度
@property (nonatomic, copy) NSString *lat;

///已输入坐标为中心的距离范围,默认“0“,0:表示全部,单位米，最大5000米，距离为非负数
@property (nonatomic, copy) NSString *range;

/*
 默认”0“，0：不排序，
 1：距离所在位置从近到远排序，
 6：记录生成时间从旧到新排序
 7：记录生成时间从新到旧排序
 8：星级从低到高排序，
 9：星级从高到低排序，
 10：价格从低到高排序，
 11：价格从高到低排序，
 12：综合性评分从低到高排序，
 13：综合性评分从高到低排序
 */
@property (nonatomic, copy) NSString *sort;

///分页索引，可选，默认”1“，最大100000
@property (nonatomic, copy) NSString *page;

///分页数量，可选，默认”10“，最大1000
@property (nonatomic, copy) NSString *size;

//通过poi id获取poi基础信息,默认“0”，若id>0则只通过id查询。
@property(nonatomic, copy) NSString *id;

//POI类别的编码，可通过 getpoicatory 方法获得
@property(nonatomic, copy) NSString *category;

//标识，默认“”，如“加油站”。
@property(nonatomic, copy) NSString *keytags;

//检索地址信息，默认“”，如 长安街。
@property(nonatomic, copy) NSString *address;

///有无电话信息   默认“-1”，-1：不筛选，0：无电话，1：有电话
@property (nonatomic, copy) NSString *tel;

//记录更新的时间     默认““，形式为“最小值_最大值”， 最小值和最大值都为整数，如“20150126151601_20150126191600 “
@property(nonatomic, copy) NSString *update;

//酒店星级   默认“”，形式为最小值_最大值“， 最小值和最大值都为整数，如"3_5"
@property(nonatomic, copy) NSString *star;

//酒店价格     默认“”，形式为”最小值_最大值“， 最小值和最大值都为单位为元的整数，如"300_500"
@property(nonatomic, copy) NSString *price;

//商圈代码   默认“-1“，-1：全部数据，其他值：商圈代码。 课根据getregion方法获取
@property(nonatomic, copy) NSString *region;

- (void)startPOISearchWithsuccess:(EMapPOISuccessBlock)successBlock failure:(EMapPOIFailureBlock)failureBlock;

@end
