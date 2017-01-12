//
//  JFSearchView.m
//
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "CitySearchView.h"

static NSString *ID = @"searchCell";

@interface CitySearchView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *rootTableView;

@end

@implementation CitySearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.rootTableView];
        self.rootTableView.hidden = YES;
    }
    return self;
}

// headerview把结果告诉searchview
- (void)setResultMutableArray:(NSMutableArray *)resultMutableArray
{
    _resultMutableArray = resultMutableArray;
    self.rootTableView.hidden = NO;
    [_rootTableView reloadData];
}

- (UITableView *)rootTableView
{
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.backgroundColor = [UIColor clearColor];
    }
    return _rootTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_resultMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    NSDictionary *dataDic = _resultMutableArray[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@，%@",[dataDic valueForKey:@"city"],[dataDic valueForKey:@"super"]];
    cell.textLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDic = _resultMutableArray[indexPath.row];
    if (![[dataDic valueForKey:@"city"] isEqualToString:@"抱歉"])
    {
        if (self.didSelectedBlock) {
            self.didSelectedBlock(dataDic);
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


/**
 点击搜索结果回调函数
 
 @param block 回调
 */
- (void)setDidSelectedBlock:(SearchViewDidSelectedBlock)block
{
    _didSelectedBlock = [block copy];
}


/**
 点击空白View回调，取消搜索
 
 @param block 回调
 */
- (void)setDismissBlock:(SearchViewDismissBlock)block
{
    _dismissBlock = [block copy];
}
@end
