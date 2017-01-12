//
//  JFCityHeaderView.h
//
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaButton : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *areaImageView;

@end


typedef void(^HeaderViewAreaBtnBlock)(BOOL selected);
typedef void(^HeaderViewSearchBlock)();
typedef void(^HeaderViewSearchResultBlock)(NSString *result);

@interface CityHeaderView : UIView
// 当前选择的城市名
@property (nonatomic, copy) NSString *currentCityName;
@property (nonatomic, strong) NSString *buttonTitle;
// 展开区县的block
@property (nonatomic, copy) HeaderViewAreaBtnBlock areaBtnBlock;

// 开始搜索
@property (nonatomic, copy) HeaderViewSearchBlock beginSearchBlock;
// 取消搜索
@property (nonatomic, copy) HeaderViewSearchBlock didSearchBlock;
// 搜索结果回调
@property (nonatomic, copy) HeaderViewSearchResultBlock searchResultBlock;

// 取消搜索
- (void)cancelSearch;

// 区县按钮的回调
- (void)setAreaBtnBlock:(HeaderViewAreaBtnBlock)block;

/**
 点击搜索框的回调函数
 */
- (void)setBeginSearchBlock:(HeaderViewSearchBlock)block;

/**
 结束搜索的回调函数
 */
- (void)setDidSearchBlock:(HeaderViewSearchBlock)block;

/**
 搜索结果回调函数
 */
- (void)setSearchResultBlock:(HeaderViewSearchResultBlock)block;

@end
