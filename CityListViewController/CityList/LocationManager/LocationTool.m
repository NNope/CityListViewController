//
//  LocationTool.m
//
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "LocationTool.h"
#import "CityDataManager.h"

#import <CoreLocation/CoreLocation.h>

static LocationTool *locationTool;

@interface LocationTool()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationTool

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            
            [self startPositioningSystem];
        });
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationTool = [super allocWithZone:zone];
    });
    return locationTool;
}

#pragma mark - interface
+ (instancetype)shareTocationTool
{
   return [[self alloc] init];
}

- (void)startPosition
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

- (void)startPositioningSystem
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // 请求使用中位置权限
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    // 精确度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
}


#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(locating)])
        {
            // 记录正在定位中
            [self.delegate locating];
        }
    });
    // 反地理编码
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *location = [placemark addressDictionary];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocation:)])
                {
                    NSString *city = [location valueForKey:@"City"];
                    [CityDataManager saveLocationCity:city];
                    [CityDataManager updateHistoryCity:city];
                    // 通知代理城市信息
                    [self.delegate currentLocation:location];
                }
            });
        }
    }];
    [manager stopUpdatingLocation];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refuseToUsePositioningSystem:)])
        {
            [self.delegate refuseToUsePositioningSystem:@"已拒绝使用定位系统"];
        }
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(locateFailure:)])
            {
                [self.delegate locateFailure:@"无法获取位置信息"];
            }
        });
    }
}


@end
