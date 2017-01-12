//
//  GlobeConst.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGBAColor(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define NAVIBARHEIGHT 64
#define TABBARHEIGHT 49

/**
 *  通知
 */
// 城市按钮cell点击的通知
extern NSString *const CityCollectionViewCellDidChangeCityNotification;

/**
 *  城市选择持久化
 */
// 选择的城市名
extern NSString *const CurrentCityNameKey;
// 选择的城市Num 用于筛选区县
extern NSString *const CurrentCityNumKey;
// 历史选择城市
extern NSString *const HistoryCityNameKey;
// 定位城市
extern NSString *const LocationCityNameKey;
// 父级城市名 选择区县时使用
extern NSString *const SuperCityNameKey;

/**
 *  列表持久化
 */
// 保存索引列表
extern NSString *const IndexListKey;
// 保存已分组的城市列表
extern NSString *const CityGroupListKey;


// 城市按钮cell的高度
extern CGFloat const KCollectionCellHeight;
// 城市按钮cell的间距
extern CGFloat const KCollectionCellMargin;

@interface GlobeConst : NSObject

@end
