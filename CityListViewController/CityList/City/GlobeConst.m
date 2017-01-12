//
//  GlobeConst.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "GlobeConst.h"

/**
 *  通知
 */
// 城市按钮cell点击的通知
NSString *const CityCollectionViewCellDidChangeCityNotification = @"CityCollectionViewCellDidChangeCityNotification";

/**
 *  城市选择持久化
 */
// 上次选择的城市名
NSString *const CurrentCityNameKey = @"CurrentCityNameKey";
// 选择的城市Num 用于筛选区县
NSString *const CurrentCityNumKey = @"CurrentCityNumKey";

// 历史选择城市
NSString *const HistoryCityNameKey = @"HistoryCityNameKey";
// 定位城市
NSString *const LocationCityNameKey = @"LocationCityNameKey";
// 父级城市名 选择区县时使用
NSString *const SuperCityNameKey = @"SuperCityNameKey";

/**
 *  列表持久化
 */
// 保存索引列表
NSString *const IndexListKey = @"IndexListKey";
// 保存已分组的城市列表
NSString *const CityGroupListKey = @"CityGroupListKey";



// 城市按钮cell的高度
CGFloat const KCollectionCellHeight = 40;
// 城市按钮cell的间距
CGFloat const KCollectionCellMargin = 10;


@implementation GlobeConst

@end
