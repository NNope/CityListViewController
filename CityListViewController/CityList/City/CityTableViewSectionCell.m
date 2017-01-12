//
//  CityTableViewCell.m
//  CitySelectList
//
//  Created by 谈Xx on 17/1/9.
//  Copyright © 2017年 谈Xx. All rights reserved.
//

#import "CityTableViewSectionCell.h"
#import "GlobeConst.h"
#import "CityDataManager.h"


static NSString *ID = @"cityCollectionViewCell";


@implementation CityButtonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        //        [label sizeToFit];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

/// 设置collectionView cell的border
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 0.8;
    self.layer.borderColor = RGBAColor(155, 155, 165, 0.5).CGColor;
    self.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title
{
    self.label.text = title;
}

@end

@interface CityTableViewSectionCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CityTableViewSectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (self.bounds.size.width - 60)/ 3;
        layout.itemSize = CGSizeMake(itemW, KCollectionCellHeight);
        
        //设置最小行距距
        layout.minimumLineSpacing = KCollectionCellMargin;
        // 最小列距
        layout.minimumInteritemSpacing = KCollectionCellMargin;
        layout.sectionInset = UIEdgeInsetsMake(2, 10, 0, 20);

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        // 每个城市按钮是一个cell
        [_collectionView registerClass:[CityButtonCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = RGBAColor(244, 244, 244,1);
    }
    return _collectionView;
}

// 每次设置数据源后刷新
-(void)setCitysArr:(NSArray *)citysArr
{
    _citysArr = citysArr;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _citysArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CityButtonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.title = _citysArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = _citysArr[indexPath.row];
    // 点击cell后发送城市选择的通知 包装数据
    // 增加一个城区所属的城市
    NSDictionary *cityNameDic = @{@"cityName":cityName,@"superCityNum":self.superCityNum};
    [[NSNotificationCenter defaultCenter] postNotificationName:CityCollectionViewCellDidChangeCityNotification object:self userInfo:cityNameDic];
}

-(NSString *)superCityNum
{
    if (_superCityNum == nil) {
        self.superCityNum = [CityDataManager readCurrentChooseCityNum];
    }
    return _superCityNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
