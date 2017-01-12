//
//  CityDataManager.m
//  CitySelectList
//
//  Created by 谈Xx on 17/1/9.
//  Copyright © 2017年 谈Xx. All rights reserved.
//

#import "CityDataManager.h"
#import "FMDatabase.h"
#import "GlobeConst.h"

static CityDataManager *_sharedInstance;
@interface CityDataManager()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation CityDataManager
- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            [self initSqliteDBData];
        });
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedInstance
{
    return [[self alloc] init];
}


// 拷贝数据库文件到沙盒
- (void)initSqliteDBData
{
    // copy"area.sqlite"到Documents中
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *txtPath =[documentsDirectory stringByAppendingPathComponent:@"shop_area.sqlite"];
    if([fileManager fileExistsAtPath:txtPath] == NO){
        NSString *resourcePath =[[NSBundle mainBundle] pathForResource:@"city_area" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    // 新建数据库并打开
    NSString *path  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"shop_area.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    self.db = db;
    BOOL success = [db open];
    if (success) {
        // 数据库创建成功!
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS shop_area (area_number INTEGER ,area_name TEXT ,city_number INTEGER ,city_name TEXT ,province_number INTEGER ,province_name TEXT);";
        BOOL successT = [self.db executeUpdate:sqlStr];
        if (successT) {
            // 创建表成功!
            
            NSLog(@"创建表成功!");
        }else{
            // 创建表失败!
            NSLog(@"创建表失败!");
            [self.db close];
        }
    }else{
        // 数据库创建失败!
        NSLog(@"数据库创建失败!");
        [self.db close];
    }
}

/**
 查询所有的城市
 
 @return 所有城市名称
 */
- (NSMutableArray *)getAllCityList
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    // 只返回不同的值
    FMResultSet *result = [self.db executeQuery:@"SELECT DISTINCT city_name FROM shop_area;"];
    while ([result next])
    {
        // 只要每条数据中的cityname
        NSString *cityName = [result stringForColumn:@"city_name"];
        [resultArray addObject:cityName];
    }
    return resultArray;
}


/**
 获取城市的num 用于查询下一级地区
 
 @param cityName 城市名称
 @return cityNum
 */
- (NSString *)getCityNumWithCityName:(NSString *)cityName
{
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_number FROM shop_area WHERE city_name = '%@';",cityName]];
    NSString *number = @"";
    while ([result next]) {
        number = [result stringForColumn:@"city_number"];
        break;
    }
    return number;
}

/**
 查询选择区县的城市名称
 根据cityNum查询所属的城市。在选择了区县后需要查询到对应的所属城市。
 @param cityNum citynum
 @return 城市名称
 */
- (NSString *)getCityNameWithCityNum:(NSString *)cityNum
{
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name FROM shop_area WHERE city_number = '%@';",cityNum]];
    NSString *name = @"";
    while ([result next]) {
        name = [result stringForColumn:@"city_name"];
        break;
    }
    return name;
}

/**
 查询城市下一级地区名称 区县
 
 @param cityNum citynun
 @return 下一级所有地区
 */
- (NSMutableArray *)getAreaListWithCityNum:(NSString *)cityNum
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT area_name FROM shop_area WHERE city_number ='%@';",cityNum];
    FMResultSet *result = [self.db executeQuery:sqlString];
    while ([result next]) {
        NSString *areaName = [result stringForColumn:@"area_name"];
        [resultArray addObject:areaName];
    }
    return resultArray;
}


/**
 查询符合条件的城市列表
 
 @param searchStr 查询关键字
 @return 城市列表
 */
- (NSMutableArray *)searchCityListWithSearchString:(NSString *)searchStr
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    // 根据关键词查询 优先查询地区
    FMResultSet *areaResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT area_name,city_name,city_number FROM shop_area WHERE area_name LIKE '%@%%';",searchStr]];
    while ([areaResult next]) {
        NSString *area = [areaResult stringForColumn:@"area_name"];
        NSString *city = [areaResult stringForColumn:@"city_name"];
        NSString *cityNumber = [areaResult stringForColumn:@"city_number"];
        NSDictionary *dataDic = @{@"super":city,@"city":area,@"city_number":cityNumber};
        // 拼接结果
        [resultArray addObject:dataDic];
    }
    
    // 如果第一次没有找到任何结果 就查询城市
    if (resultArray.count == 0)
    {
        FMResultSet *cityResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name,city_number,province_name FROM shop_area WHERE city_name LIKE '%@%%';",searchStr]];
        while ([cityResult next]) {
            NSString *city = [cityResult stringForColumn:@"city_name"];
            NSString *cityNumber = [cityResult stringForColumn:@"city_number"];
            NSString *province = [cityResult stringForColumn:@"province_name"];
            NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
            [resultArray addObject:dataDic];
        }
        
        // 城市也没有查到 就查询省份
        if (resultArray.count == 0)
        {
            FMResultSet *provinceResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT province_name,city_name,city_number FROM shop_area WHERE province_name LIKE '%@%%';",searchStr]];
            
            while ([provinceResult next]) {
                NSString *province = [provinceResult stringForColumn:@"province_name"];
                NSString *city = [provinceResult stringForColumn:@"city_name"];
                NSString *cityNumber = [provinceResult stringForColumn:@"city_number"];
                NSDictionary *dataDic = @{@"super":province,@"city":city,@"city_number":cityNumber};
                [resultArray addObject:dataDic];
            }
            
            // 实在没有 就构造个错误info，其实是防止解析错误
            if (resultArray.count == 0) {
                [resultArray addObject:@{@"city":@"抱歉",@"super":@"未找到相关位置，可尝试修改后重试!"}];
            }
        }
    }
    //返回结果
    return resultArray;

}

#pragma mark - 城市名持久化相关
// 读取本地存储的上次选择的城市名
+ (NSString *)readCurrentChooseCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentCityNameKey];
    if (!city || city.length == 0)
    {
        city = [self readLocationCity];
    }
    return city;
}

// 读取区县父级城市名
+ (NSString *)readCurrentSuperCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:SuperCityNameKey];
    if (!city || city.length == 0)
    {
        city = [self readCurrentChooseCity];
    }
    return city;
}
// 保存本地存储的选择的城市名
+ (void)saveCurrentChooseCity:(NSString *)cityname SuperCity:(NSString *)superCity
{
    // 更新 当前选择的城市名
    [[NSUserDefaults standardUserDefaults] setObject:cityname forKey:CurrentCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 保存城市num
    [self saveCurrentChooseCityNum:[[CityDataManager sharedInstance] getCityNumWithCityName:cityname]];
    // 添加到历史中
    [self updateHistoryCity:cityname];
    if (!superCity || superCity.length == 0)
    {
        superCity = cityname;
    }
    [[NSUserDefaults standardUserDefaults] setObject:superCity forKey:SuperCityNameKey];
}


// 读取本地存储的定位的城市名
+ (NSString *)readLocationCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:LocationCityNameKey];
    if (!city || city.length == 0)
    {
        city = @"定位中";
    }
    return city;
}
// 保存本地存储的定位的城市名
+ (void)saveLocationCity:(NSString *)cityname
{
    [[NSUserDefaults standardUserDefaults] setObject:cityname forKey:LocationCityNameKey];
    // 如果第一次定位 此时没保存任何城市
    if (![self readCurrentChooseCityNum] || [self readCurrentChooseCityNum] == 0)
    {
        [self saveCurrentChooseCity:cityname SuperCity:cityname];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 读取本地存储的选择的城市num
+ (NSString *)readCurrentChooseCityNum
{
    NSString *num = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentCityNumKey];

    return num;
}
// 保存本地存储的选择的城市num
+ (void)saveCurrentChooseCityNum:(NSString *)citynum
{
    [[NSUserDefaults standardUserDefaults] setObject:citynum forKey:CurrentCityNumKey];
}

// 读取历史城市
+ (NSMutableArray *)readHistoryCityList
{
    
    NSMutableArray *arrHis = [[NSUserDefaults standardUserDefaults] objectForKey:HistoryCityNameKey];
    if (!arrHis)
    {
        arrHis = [NSMutableArray array];
    }
    return arrHis;
}

// 读取热门城市
+(NSArray *)readHotCityList
{
    NSArray *arrHot = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HotCityList" ofType:@"plist"]];
    if (!arrHot)
    {
        arrHot = @[@"北京市", @"上海市", @"广州市", @"深圳市", @"武汉市", @"天津市", @"西安市", @"南京市", @"杭州市", @"成都市", @"重庆市"];
    }
    return arrHot;
}

// 读取本地的拼音排序后城市列表
+ (NSMutableArray *)readGroupCityList
{
     NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CityGroupListKey]];
    return arr;
}
// 保存本地的拼音排序后城市列表
+ (void)saveGroupCityList:(NSMutableArray *)list
{
    NSData *da = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:da forKey:CityGroupListKey];
}

// 读取本地的拼音索引列表
+ (NSMutableArray *)readIndexList
{
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:IndexListKey]];
    return arr;
}
// 保存本地的拼音索引列表
+ (void)saveIndexList:(NSMutableArray *)list
{
    NSData *da = [NSKeyedArchiver archivedDataWithRootObject:list];
    [[NSUserDefaults standardUserDefaults] setObject:da forKey:IndexListKey];
    
}



// 更新历史城市
+ (void)updateHistoryCity:(NSString *)newChooseCity
{
    // 存cache
    NSMutableArray *arrHis = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:HistoryCityNameKey]];
    
    if (!arrHis || arrHis.count == 0) // 第一次
    {
        [arrHis addObject:newChooseCity];
    }
    else
    {
        // 如果相同
        for (NSString *temp in arrHis)
        {
            if ([newChooseCity isEqualToString:temp])
            {
                return;
            }
        }
        
        if (arrHis.count == 3) // 已经有3个了
        {
            [arrHis removeLastObject];
        }
        [arrHis insertObject:newChooseCity atIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrHis forKey:HistoryCityNameKey];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
