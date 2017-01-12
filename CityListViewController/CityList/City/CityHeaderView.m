//
//  JFCityHeaderView.m
//
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "CityHeaderView.h"
#import "GlobeConst.h"
#import "Masonry.h"


@implementation AreaButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addTitleLabel:frame];
        [self addImageView:frame];
    }
    return self;
}

// 设置按钮文字
- (void)setTitle:(NSString *)title
{
    self.areaLabel.text = title;
    CGRect tempFrame = self.areaLabel.frame;
    tempFrame.size.width = self.frame.size.width - 10;
    self.areaLabel.frame = tempFrame;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    self.areaLabel.textColor = titleColor;
}

- (void)setImageName:(NSString *)imageName
{
    self.areaImageView.image = [UIImage imageNamed:imageName];
}

// 创建文字lbl
- (void)addTitleLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    self.areaLabel = label;
}

// 创建图片
- (void)addImageView:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(7);
        make.height.offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.areaImageView = imageView;
}

@end

@interface CityHeaderView ()<UISearchBarDelegate>

@property (nonatomic, weak) UILabel *currentCityLabel;
@property (nonatomic, weak) AreaButton *areaButton;
@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation CityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSearchBar];
        [self addLabels];
        [self addAreaButton];
    }
    return self;
}
#pragma mark - interface
// 设置当前选择城市
-(void)setCurrentCityName:(NSString *)currentCityName
{
    _currentCityName = [currentCityName copy];
    
    self.currentCityLabel.text = currentCityName;
}
// 设置区县按钮显示文字
- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = [buttonTitle copy];
    self.areaButton.title = buttonTitle;
}


#pragma mark - UI
// 添加search
- (void)addSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"输入城市名称";
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.bounds.size.width - 10);
        make.height.offset(40);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    // 分隔线
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = RGBAColor(155, 155, 155, 0.5);
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.bounds.size.width);
        make.height.offset(0.5);
        make.top.equalTo(searchBar.mas_bottom).offset(0);
    }];
}
// 当前选择城市
- (void)addLabels
{
    // 当前
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = @"当前:";
    currentLabel.textAlignment = NSTextAlignmentLeft;
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:currentLabel];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(21);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    // 城市名
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textColor  = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.font = [UIFont systemFontOfSize:14];
    [self addSubview:lbl];
    self.currentCityLabel = lbl;
    [_currentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(21);
        make.left.equalTo(currentLabel.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

// 添加区县选择按钮
- (void)addAreaButton
{
    // 左边文字 右边图片
    AreaButton *btn =[[AreaButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 95, self.frame.size.height - 31, 75, 21)];
    [btn addTarget:self action:@selector(touchUpAreaButtonEnevt:) forControlEvents:UIControlEventTouchUpInside];
    btn.imageName = @"drop_down_arraw";
    btn.title = @"选择区县";
    btn.titleColor = RGBAColor(155, 155, 155, 1.0);
    [self addSubview:btn];
    self.areaButton = btn;
}
#pragma mark - action
- (void)touchUpAreaButtonEnevt:(AreaButton *)sender
{
    sender.selected = !sender.selected;
    [UIView animateWithDuration:0.3 animations:^{
        sender.areaImageView.transform = CGAffineTransformRotate(sender.areaImageView.transform,M_PI);
    } completion:^(BOOL finished) {
    }];
    if (self.areaBtnBlock)
    {
        self.areaBtnBlock(sender.selected);
    }
}

//- (void)cityNameBlock:(JFCityHeaderViewBlock)block
//{
//    self.cityNameBlock = block;
//}

#pragma mark --- UISearchBarDelegate

//// searchBar开始编辑时调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 开始搜索时 显示取消按钮
    searchBar.showsCancelButton = YES;
    if (self.beginSearchBlock)
    {
        self.beginSearchBlock();
    }
}

// searchBar文本改变时即调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length > 0)
    {
        // 每次都回调结果block
        if (self.searchResultBlock)
        {
            self.searchResultBlock(searchBar.text);
        }
    }
}

// 点击键盘搜索按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"点击搜索按钮编辑的结果是%@",searchBar.text);
}

//  点击searchBar取消按钮时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearch];
}

//  取消搜索 比如在选择了结果后
- (void)cancelSearch
{
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
    _searchBar.text = nil;
    if (self.didSearchBlock)
    {
        self.didSearchBlock();
    }
}

#pragma mark --- setBlock
- (void)setAreaBtnBlock:(HeaderViewAreaBtnBlock)block
{
    _areaBtnBlock = [block copy];
}



/**
 点击搜索框的回调函数
 */
- (void)setBeginSearchBlock:(HeaderViewSearchBlock)block
{
    _beginSearchBlock = [block copy];
}

/**
 结束搜索的回调函数
 */
- (void)setDidSearchBlock:(HeaderViewSearchBlock)block
{
    _didSearchBlock = [block copy];
}

/**
 搜索结果回调函数
 */
- (void)setSearchResultBlock:(HeaderViewSearchResultBlock)block
{
    _searchResultBlock = [block copy];
}


@end
