//
//  JFSearchView.h
//
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchViewDidSelectedBlock)(NSDictionary *cityData);
typedef void(^SearchViewDismissBlock)();

@interface CitySearchView : UIView

// 传递结果数组 来显示
@property (nonatomic, strong) NSMutableArray *resultMutableArray;

// 点击回调
@property (nonatomic, copy) SearchViewDidSelectedBlock didSelectedBlock;
// 背景view点击block
@property (nonatomic, copy) SearchViewDismissBlock dismissBlock;


/**
 点击搜索结果回调函数

 @param block 回调
 */
- (void)setDidSelectedBlock:(SearchViewDidSelectedBlock)block;


/**
 点击空白View回调，取消搜索

 @param block 回调
 */
- (void)setDismissBlock:(SearchViewDismissBlock)block;


@end
