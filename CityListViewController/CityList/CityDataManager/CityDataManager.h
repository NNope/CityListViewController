//
//  CityDataManager.h
//  CitySelectList
//
//  Created by 谈Xx on 17/1/9.
//  Copyright © 2017年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDataManager : NSObject

+ (instancetype)sharedInstance;


/**
 查询所有的城市

 @return 所有城市名称
 */
- (NSMutableArray *)getAllCityList;

/**
 查询城市的num 用于查询下一级地区

 @param cityName 城市名称
 @return cityNum
 */
- (NSString *)getCityNumWithCityName:(NSString *)cityName;

/**
 查询选择区县的城市名称
 根据cityNum查询所属的城市。在选择了区县后需要查询到对应的所属城市。
 @param cityNum citynum
 @return 城市名称
 */
- (NSString *)getCityNameWithCityNum:(NSString *)cityNum;

/**
 查询城市下一级地区名称 区县

 @param cityNum citynun
 @return 下一级所有地区
 */
- (NSMutableArray *)getAreaListWithCityNum:(NSString *)cityNum;

/**
 查询符合条件的城市列表

 @param searchStr 查询关键字
 @return 城市列表
 */
- (NSMutableArray *)searchCityListWithSearchString:(NSString *)searchStr;


/**
 本地城市持久化相关
 */

// 读取本地存储的选择的城市名
+ (NSString *)readCurrentChooseCity;
/**
 保存本地存储的选择的城市名

 @param cityname 选择的城市名
 @param superCity 区县父级城市名 没有则传城市名
 */
+ (void)saveCurrentChooseCity:(NSString *)cityname SuperCity:(NSString *)superCity;

// 读取区县父级城市名 可用于对比城市与定位是否一致
+ (NSString *)readCurrentSuperCity;

// 读取本地存储的定位的城市名
+ (NSString *)readLocationCity;
// 保存本地存储的定位的城市名
+ (void)saveLocationCity:(NSString *)cityname;


// 读取本地存储的选择的城市num
+ (NSString *)readCurrentChooseCityNum;
// 保存本地存储的选择的城市num
+ (void)saveCurrentChooseCityNum:(NSString *)citynum;

// 更新历史城市
+ (void)updateHistoryCity:(NSString *)newChooseCity;
// 读取历史城市
+ (NSMutableArray *)readHistoryCityList;
// 读取热门城市
+ (NSArray *)readHotCityList;

// 读取本地的拼音排序后城市列表
+ (NSMutableArray *)readGroupCityList;
// 保存本地的拼音排序后城市列表
+ (void)saveGroupCityList:(NSMutableArray *)list;

// 读取本地的拼音索引列表
+ (NSMutableArray *)readIndexList;
// 保存本地的拼音索引列表
+ (void)saveIndexList:(NSMutableArray *)list;


@end
