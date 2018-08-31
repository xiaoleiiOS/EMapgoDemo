//
//  SearchView.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "SearchView.h"
#import "EMapgoConfig.h"
#import <EMapgoPOI/EMapgoPOI.h>
#import <EMapgo/EMapgo.h>
#import "SearchTableViewCell.h"

@interface SearchView ()
@property (nonatomic, strong) UITableView *tableView;//
@property (nonatomic, assign) NSInteger inputCount;     //用户输入次数，用来控制延迟搜索请求
@property (nonatomic, strong) EMapPOISearch *poiSearch;//
@property (nonatomic, strong) NSMutableArray *dataArray;//
@end

@implementation SearchView{
    UITextField *_searchField;
    UIButton *_replaceBtn;
    NSString *_keyString;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, DEF_SCREEN_WIDTH, SafeAreaScrollHeight-98+SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 56;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (EMapPOISearch *)poiSearch{
    if (_poiSearch == nil) {
        _poiSearch = [[EMapPOISearch alloc] init];
    }
    return _poiSearch;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, -DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
        self.backgroundColor = getColor(@"f1f1f1");
        _dataArray = [[NSMutableArray alloc] init];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 25, 30, 25);
//        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(canButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(30, 25, DEF_SCREEN_WIDTH-40,25)];
        _searchField.backgroundColor = [UIColor whiteColor];;
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.textColor = [UIColor blackColor];
        _searchField.layer.borderColor = getColor(@"e3e3e3").CGColor;
        _searchField.layer.borderWidth = 1;
        _searchField.delegate = self;
        _searchField.placeholder = @"搜索";
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.returnKeyType = UIReturnKeyDone;
        //添加事件
        [_searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_searchField];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(0, 0, 25, 25);
        searchBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//        [searchBtn addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];
        _searchField.leftView = searchBtn;
        
        NSArray *nameArray = @[@"美食",@"地铁",@"加油站",@"酒店",@"银行"];
        int i = 0;
        for (NSString *keyword in nameArray) {
            UIButton *keywordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            keywordBtn.frame = CGRectMake(8+DEF_SCREEN_WIDTH/5*i, 58, DEF_SCREEN_WIDTH/5-16, 30);
            keywordBtn.layer.borderWidth = 1;
            keywordBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
            keywordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [keywordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [keywordBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
            [keywordBtn setTitle:keyword forState:UIControlStateNormal];
            [keywordBtn addTarget:self action:@selector(keywordAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:keywordBtn];
            i++;
        }
        
        self.tableView.hidden = YES;
        [self addSubview:self.tableView];
    }
    return self;
}
#pragma mark - UITextFielddelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -private method
//实现方法
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.inputCount ++;
        [self performSelector:@selector(requestKeyWorld:) withObject:@(self.inputCount) afterDelay:1.0f];
    }else{
        
    }
}
- (void)keywordAction:(UIButton *)sender{
    if (_replaceBtn == sender) {
        _replaceBtn.selected = !sender.selected;
        _keyString = _replaceBtn.selected == YES?sender.titleLabel.text:@"";
        sender.layer.borderColor = _replaceBtn.selected == YES?[UIColor greenColor].CGColor:[UIColor blackColor].CGColor;
    }else{
        _replaceBtn.selected = NO;
        _replaceBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _replaceBtn = sender;
        _replaceBtn.selected = YES;
        _keyString = sender.titleLabel.text;
        _replaceBtn.layer.borderColor = [UIColor greenColor].CGColor;
    }
    
    [self getPOIAdderss];
}

- (void)requestKeyWorld:(NSNumber *)count {
    if (self.inputCount == [count integerValue] && _searchField.text.length != 0) {
        //说明用户停止输入超过了一秒，发起请求
        [self getPOIAdderss];
    }
}

- (void)getPOIAdderss{
    NSDictionary *locationDic = DEF_PERSISTENT_GET_OBJECT(@"userLocation");
    self.poiSearch.q = _searchField.text;
    self.poiSearch.lat = locationDic[@"latitude"];
    self.poiSearch.lon = locationDic[@"longitude"];
    self.poiSearch.type = @"1";
    self.poiSearch.sort = @"1";
    self.poiSearch.size = @"30";
    self.poiSearch.keytags = _keyString;
    __weak typeof(self) weakSelf = self;
    [_poiSearch startPOISearchWithsuccess:^(NSDictionary *data) {
        NSLog(@"成功");
        [weakSelf.dataArray removeAllObjects];
        for (NSDictionary *dic in data[@"list"]) {
            [weakSelf.dataArray addObject:dic];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SearchTableViewCell";
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dataDic = _dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.roadPlanBlock = ^{
        if (weakSelf.goRoadBlock) {
            weakSelf.goRoadBlock(weakSelf.dataArray[indexPath.row]);
        }
    };
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)canButtonClick{
    [_searchField resignFirstResponder];
    [UIView animateWithDuration:0.7 animations:^{
        self.frame = CGRectMake(0, -DEF_SCREEN_HEIGHT, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [_searchField becomeFirstResponder];
    [UIView animateWithDuration:0.7 animations:^{
        self.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchField resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
