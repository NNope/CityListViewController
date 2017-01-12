//
//  PDCityListViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "LocationTool.h"
#import <UIKit/UIKit.h>

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

typedef void(^ChoseCityBlock)(NSString *cityName,NSString *superName);

@interface CityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,LocationToolDelegate>
{
    
}

/**
 *  全部城市列表
 */
@property (nonatomic, strong) NSMutableArray *cityAllList;

/**
 *  索引列表
 */
@property (nonatomic, strong) NSMutableArray *indexList;

/**
 *  拼音分组后的列表
 */
@property (nonatomic, strong) NSMutableArray *cityGroupList;

/**
 *  当前区县列表
 */
@property (nonatomic, strong) NSMutableArray *areaList;
/**
 *  历史城市列表
 */
@property (nonatomic, strong) NSMutableArray *cityHistoryList;
/**
 *  热门城市列表
 */
@property (nonatomic, strong) NSArray *cityHotList;

// 选择城市后的回调
@property (nonatomic, copy) ChoseCityBlock choseCityBlock;


// 定位城市
@property (nonatomic, copy) NSString *locationCity;

-(void)setChoseCityBlock:(ChoseCityBlock)block;


@property (nonatomic, weak) UITableView *cityTableView;

@end
