//
//  头部城市多个按钮的cell 内部是collectionview
//  
//
//  Created by 谈Xx on 17/1/9.
//  Copyright © 2017年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityButtonCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) UILabel *label;
@end

@interface CityTableViewSectionCell : UITableViewCell
// 区县数组
@property (nonatomic, copy) NSArray *citysArr;
// 区县所属城市num
@property (nonatomic, copy) NSString *superCityNum;
@end
