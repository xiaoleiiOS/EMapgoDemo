//
//  EMGSearchMoedl.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/16.
//  Copyright © 2019 MaRui. All rights reserved.
//


#import "EMGBaseModel.h"
#import "EMGGeocoding.h"
#import "EMGFeature.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMGSearchModel : EMGBaseModel

//搜索中的地理编码的信息。
@property (nonatomic, strong) EMGGeocoding *geocoding;

//搜索结果中的地理编码类型被定义为“FeatureCollection”。
@property (nonatomic, copy) NSString *type;

//搜索结果列表，根据得分降序排列。
@property (nonatomic, strong) NSArray<EMGFeature *> *features;

//代表了要素的几何范围，可用于显示下所有的检索结果的屏幕尺寸，替代了精准的多边形范围。
@property (nonatomic, strong) NSArray *bbox;

@end

NS_ASSUME_NONNULL_END
