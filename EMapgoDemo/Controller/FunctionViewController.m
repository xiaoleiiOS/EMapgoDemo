//
//  FunctionViewController.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/4.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "FunctionViewController.h"
#import "EMapgoConfig.h"
#import "FouctionTableViewCell.h"

@interface FunctionViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_nameArray;
    NSArray *_imageNameArray;
}
@property (nonatomic, strong) UITableView *tableView;//
@end

@implementation FunctionViewController
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, DEF_SCREEN_WIDTH, SafeAreaScrollHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        //        _tableView.rowHeight = 44;
        //给tablView添加着两句配合好约束就再也不用计算高度了
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameArray = @[@"加载大头针和默认气泡",@"绘制多边形",@"绘制线段",@"绘制路线",@"绘制圆点标记",@"添加经纬度网格",@"RasterTileSource添加WMS资源",@"styleRasterTileSource",@"styleImageSource",@"Style Building Fill Color",@"Remove Parks",@"Overdraw Visualization",@"3D Map",@"添加3D建筑layer", @"注释视图动画", @"添加交通事件和交通路况光栅瓦片"];
    _imageNameArray = @[@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",@"eleven",@"twelve",@"thirteen",@"fourteen"];
    
    [self makeUI];
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    self.title = @"功能演示";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    FouctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FouctionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    cell.introduceImageView.image = [UIImage imageNamed:_imageNameArray[indexPath.row]];
    cell.nameLabel.text = _nameArray[indexPath.row];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 265*DEF_WIDTH_RATIO+40;
//}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
    }
}

#pragma mark - 点击事件


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
