//
//  PDCityListViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "CityListViewController.h"
#import "ChineseString.h"
#import "CityTableViewSectionCell.h"
#import "CityDataManager.h"
#import "GlobeConst.h"
#import "CityHeaderView.h"
#import "CitySearchView.h"



static CGFloat const KHeaderViewHeight = 80;
static CGFloat const KSectionHeaderHeight = 24;
static NSString *KCitySectionCellID = @"CitySectionCellID";
static NSString *KTableViewCellID = @"tableViewCell";

@interface CityListViewController()
// 区县cell的高度
@property (nonatomic, assign) CGFloat areaCellHeight;
// 热门城市cell的高度
@property (nonatomic, assign) CGFloat hotCellHeight;
// 头部有3组还是4组
@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) CityHeaderView *headerView;
@property (nonatomic, strong) CitySearchView *searchView;
@end

@implementation CityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectedCityCell:) name:CityCollectionViewCellDidChangeCityNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _sectionCount = 3;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hf_cityBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(disMiss)];
    
    
    [self setupSearchAndTable];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"选择城市";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)setupSearchAndTable
{

    // table
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];;
    self.cityTableView = table;
    self.cityTableView.backgroundColor = [UIColor whiteColor];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.cityTableView.tableHeaderView = self.headerView;
//    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    vv.backgroundColor = [UIColor redColor];
//    self.cityTableView.tableHeaderView = vv;
    [self.view addSubview:self.cityTableView];
    
    
    // 头部几个section的cell
    [self.cityTableView registerClass:[CityTableViewSectionCell class]
               forCellReuseIdentifier:KCitySectionCellID];
    // 城市文字cell
    [self.cityTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:KTableViewCellID];
    

}

// 点击几个cell选择城市
- (void)didSelectedCityCell:(NSNotification *)info
{
    NSDictionary *cityDic = info.userInfo;
    NSString *name = [cityDic objectForKey:@"cityName"];
    NSString *superNum = [cityDic objectForKey:@"superCityNum"];
    NSString *superCityName = [[CityDataManager sharedInstance] getCityNameWithCityNum:superNum];
    [self didChooseCity:name superName:superCityName];
}

/**
 *  选择了城市
 */
- (void)didChooseCity:(NSString *)name superName:(NSString *)superName
{
    if ([name isEqualToString:@"全城"])
    {
        name = [[CityDataManager sharedInstance] getCityNameWithCityNum:[CityDataManager readCurrentChooseCityNum]];
    }
    [CityDataManager saveCurrentChooseCity:name SuperCity:superName];
    // 传递出去城市选择结果
    if (self.choseCityBlock)
    {
        self.choseCityBlock(name,superName);
    }
    
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section < _sectionCount ? 1 : [[self.cityGroupList objectAtIndex:section-_sectionCount] count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 属于头部几个section
    if (indexPath.section < _sectionCount)
    {
        CityTableViewSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:KCitySectionCellID forIndexPath:indexPath];
        if (_sectionCount == 4 && indexPath.section == 0)
        {
            // 判断为区县的cell
            cell.citysArr = self.areaList;
        }
        // 头部中的倒数第三个 定位城市
        if (indexPath.section == _sectionCount - 3)
        {
            cell.citysArr = self.locationCity ? @[self.locationCity] : @[@"正在定位..."];
        }
        // 头部中的倒数第二个 历史
        if (indexPath.section == _sectionCount - 2)
        {
            cell.citysArr = self.cityHistoryList;
        }
        // 头部中的倒数第一个 热门
        if (indexPath.section == _sectionCount - 1) {
            cell.citysArr = self.cityHotList;
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTableViewCellID forIndexPath:indexPath];
        cell.textLabel.text = self.cityGroupList[indexPath.section - _sectionCount][indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}
// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexList.count;
}

#pragma mark - UITableViewDelegate

// 索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexList;
}
// sectionHeader高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_sectionCount == 4 && section == 0)
    {
        // 区县这一栏没有sectionhead
        return 0;
    }
    else
    {
        return KSectionHeaderHeight;
    }
}
// sectionHeader
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, KSectionHeaderHeight)];
    sectionHeaderView.backgroundColor = RGBAColor(244, 244, 244, 1);
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH, KSectionHeaderHeight)];
    sectionLabel.textColor = [UIColor grayColor];
    sectionLabel.font = [UIFont boldSystemFontOfSize:14];
    [sectionHeaderView addSubview:sectionLabel];
    
    // section标题
    NSString *title = @"";
    
    if (_sectionCount == 3)
    {
        // 没有区县显示
        switch (section)
        {
            case 0:
                title = @"定位城市";
                break;
            case 1:
                title = @"最近访问的城市";
                break;
            case 2:
                title = @"热门城市";
                break;
            default:
                title = self.indexList[section];;
                break;
        }
    }
    else
    {
        // 区县显示
        switch (section)
        {
            case 1:
                title = @"定位城市";
                break;
            case 2:
                title = @"最近访问的城市";
                break;
            case 3:
                title = @"热门城市";
                break;
            default:
                title = self.indexList[section];;
                break;
        }
    }
    sectionLabel.text = title;
    
    return sectionHeaderView;
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_sectionCount == 4 && indexPath.section == 0)
    {
        // 区县那一栏的高度
        return _areaCellHeight;
    }
    else
    {
        return indexPath.section == (_sectionCount - 1) ? self.hotCellHeight : 44;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didChooseCity:self.cityGroupList[indexPath.section-_sectionCount][indexPath.row] superName:nil];
}

#pragma mark - LocationToolDelegate
/// 定位中
- (void)locating
{
    NSLog(@"定位中。。。");
}

/**
 当前位置
 */
- (void)currentLocation:(NSDictionary *)locationDictionary
{
    NSString *city = [locationDictionary valueForKey:@"City"];
    self.locationCity = city;
    _headerView.currentCityName = city;
    [_cityTableView reloadData];
}

/**
 拒绝定位后回调的代理
 */
- (void)refuseToUsePositioningSystem:(NSString *)message
{
    NSLog(@"%@",message);
}

/**
 定位失败回调的代理
 */
- (void)locateFailure:(NSString *)message
{
        NSLog(@"%@",message);
}

- (void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter Setter

-(CityHeaderView *)headerView
{
    // 创建headerView
    if (_headerView == nil)
    {
        _headerView =[[CityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, KHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.buttonTitle = @"选择区县";
        // 设置当前选择城市
        _headerView.currentCityName = [CityDataManager readCurrentChooseCity];
        
        __weak typeof(self) weakSelf = self;
        // 设置点击区县按钮的block 要设置区县数组 要设置新的高度 获取当前城市的所有辖区
        [_headerView setAreaBtnBlock:^(BOOL selected) {
            if (selected)
            {
                // 获取当前的区县列表
                
                [weakSelf.areaList addObjectsFromArray:[[CityDataManager sharedInstance] getAreaListWithCityNum:[CityDataManager readCurrentChooseCityNum]]];
                // 根据区县 算出高度
                NSInteger row = (self.areaList.count + 3 - 1)/3;
                weakSelf.areaCellHeight = row*KCollectionCellHeight + (row - 1)*KCollectionCellMargin + 4;
                if (_areaCellHeight > 300)
                {
                    weakSelf.areaCellHeight = 300;
                }
                //添加一行cell
                [weakSelf.cityTableView endUpdates];
                [weakSelf.indexList insertObject:@"*" atIndex:0];
                _sectionCount = 4;
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [weakSelf.cityTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.cityTableView endUpdates];
            }
            else
            {
                //删除一行cell
                [weakSelf.cityTableView beginUpdates];
                [weakSelf.indexList removeObjectAtIndex:0];
                _sectionCount = 3;
                weakSelf.areaList = nil;
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [weakSelf.cityTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.cityTableView endUpdates];
            }
           
        }];

        // 设置搜索相关block
        [_headerView setBeginSearchBlock:^{
            // 开始搜索 添加searchview
            [weakSelf.view addSubview:weakSelf.searchView];
        }];
        // 结束搜索回调
        [_headerView setDidSearchBlock:^{
            
            // 自己移除
            [weakSelf.searchView removeFromSuperview];
            _searchView = nil;
        }];
        // 设置搜索关键词回调
        [_headerView setSearchResultBlock:^(NSString *result) {
              NSMutableArray *arr = [[CityDataManager sharedInstance] searchCityListWithSearchString:result];
            if (arr.count > 0)
            {
                weakSelf.searchView.backgroundColor = [UIColor whiteColor];
                // super city city_number
                weakSelf.searchView.resultMutableArray = arr;
            }
        }];

    }
    return _headerView;
}

- (CitySearchView *)searchView
{
    if (!_searchView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _searchView = [[CitySearchView alloc] initWithFrame:CGRectMake(0, 104, frame.size.width, frame.size.height  - 104)];
        _searchView.backgroundColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:0.5];
        
        __weak typeof(self) weakSelf = self;
        // 设置搜索结果点击回调
        [_searchView setDidSelectedBlock:^(NSDictionary *cityData) {
            
            [weakSelf didChooseCity:[cityData objectForKey:@"city"] superName:[cityData objectForKey:@"super"]];
        }];
        // 设置空白区域点击回到
        [_searchView setDismissBlock:^{
            // 直接调用headerview 的取消搜索即可 headeview会去回调didsearch
            // headerview取消状态
            [weakSelf.headerView cancelSearch];
        }];
    }
    return _searchView;
}

-(NSMutableArray *)cityAllList
{
    if (_cityAllList == nil)
    {
        // 数据库城市列表，备用 优先使用持久化的排序后数据
        self.cityAllList =  [[CityDataManager sharedInstance] getAllCityList];
    }
    return _cityAllList;
}

-(NSMutableArray *)indexList
{
    if (_indexList == nil)
    {
        // 看下有没有存
        self.indexList = [CityDataManager readIndexList];
        if (!_indexList || _indexList.count <= 0)
        {
            // A-Z 增加
            self.indexList = [ChineseString IndexArray:self.cityAllList];
            // 增加 #$
            NSRange range = NSMakeRange(0, 3);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_indexList insertObjects:@[@"!",@"#",@"$"] atIndexes:indexSet];
            
            [CityDataManager saveIndexList:_indexList];

        }
    }
    return _indexList;
}
// 从名称列表里得到分组列表
-(NSMutableArray *)cityGroupList
{
    if (_cityGroupList == nil)
    {
        self.cityGroupList = [CityDataManager readGroupCityList];
        if (!_cityGroupList || _cityGroupList.count <= 0)
        {
            self.cityGroupList = [ChineseString LetterSortArray:self.cityAllList];
            [CityDataManager saveGroupCityList:_cityGroupList];
        }
    }
    return _cityGroupList;
}

-(NSMutableArray *)cityHistoryList
{
    if (_cityHistoryList == nil)
    {
        self.cityHistoryList = [CityDataManager readHistoryCityList];
    }
    return _cityHistoryList;
}

-(NSMutableArray *)areaList
{
    if (_areaList == nil)
    {
        self.areaList = [NSMutableArray arrayWithObject:@"全城"];
    }
    return _areaList;
}

-(NSArray *)cityHotList
{
    if (_cityHotList == nil)
    {
        self.cityHotList = [CityDataManager readHotCityList];
    }
    return _cityHotList;
}

-(CGFloat)hotCellHeight
{
    if (_hotCellHeight == 0 && self.cityHotList.count > 0)
    {
        NSInteger row = (self.cityHotList.count + 3 - 1)/3;
        _hotCellHeight = KCollectionCellMargin + KCollectionCellHeight * row + KCollectionCellMargin * (row - 1);
    }
    return _hotCellHeight;
}

-(void)setChoseCityBlock:(ChoseCityBlock)block
{
    _choseCityBlock = [block copy];
}

-(NSString *)locationCity
{
    if (_locationCity == nil)
    {
        self.locationCity = [CityDataManager readLocationCity];
    }
    return _locationCity;
}

@end
