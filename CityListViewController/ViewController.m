//
//  ViewController.m
//  CitySelectList
//
//  Created by 谈Xx on 17/1/6.
//  Copyright © 2017年 谈Xx. All rights reserved.
//

#import "ViewController.h"
#import "CityListViewController.h"
#import "LocationTool.h"
#import "CityDataManager.h"


@interface ViewController ()<LocationToolDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(111, 111, 333, 111);
    [btn setTitle:[CityDataManager readCurrentChooseCity] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.tag = 111;
    
    [LocationTool shareTocationTool].delegate = self;
    [[LocationTool shareTocationTool] startPosition];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)Test
{
    CityListViewController *cityVc = [[CityListViewController alloc] init];
    
#pragma mark - 设置城市选择后的回调显示，城市的保存逻辑已处理
    
    __weak typeof(self) weakSelf = self;
    [cityVc setChoseCityBlock:^(NSString *cityName,NSString *superName) {
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:111];
        [btn setTitle:cityName forState:UIControlStateNormal];
        
        NSLog(@"选择了%@",cityName);
    }];
    UINavigationController *na =  [[UINavigationController alloc] initWithRootViewController:cityVc];
  
    [self presentViewController:na animated:YES completion:nil];
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
    
#pragma mark - 定位到的城市 可自定义操作
    // 按钮默认显示定位中 需要更新title
    UIButton *btn = (UIButton *)[self.view viewWithTag:111];
    [btn setTitle:[CityDataManager readCurrentChooseCity] forState:UIControlStateNormal];
    
    // 提示不一致 取父级对比
    if (![city isEqualToString:[CityDataManager readCurrentSuperCity]])
    {
        [self showDiff:city];
    }
    NSLog(@"定位到%@",city);
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

- (void)showDiff:(NSString *)new
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前选择的城市和定位不一致，是否切换？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action2  = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [CityDataManager saveCurrentChooseCity:new SuperCity:new];
        UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:111];
        [btn setTitle:new forState:UIControlStateNormal];
    }];
    [alert addAction:action2];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
