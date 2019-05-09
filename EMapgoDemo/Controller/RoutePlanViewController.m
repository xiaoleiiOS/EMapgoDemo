//
//  RoutePlanViewController.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "RoutePlanViewController.h"
#import "EMapgoConfig.h"
#import <EMapgo/EMapgo.h>
#import <EMapgoPOI/EMapgoPOI.h>
#import "RoutePlanTableViewCell.h"
#import <MapboxDirections/MapboxDirections.h>

@interface RoutePlanViewController ()<UITextFieldDelegate,MGLMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIButton *_wayReplaceBtn;
    UIButton *_planReplaceBtn;
    NSInteger _nowroadNumber;
    
    MGLPolyline *_selectPolyline;
}
@property (nonatomic, strong) UITextField *startField;//
@property (nonatomic, strong) UITextField *endField;//
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic, copy) NSDictionary *requestDic;//
@property (nonatomic, strong) NSMutableArray *dataArray;//
@property (nonatomic, copy) NSArray *nowRouteArray;//
@property (nonatomic, strong) UITableView *tableView;//
@end

#define TableViewTop (105 + StatusBarTHeight)
#define TableViewHeight (DEF_SCREEN_HEIGHT - TableViewTop)

@implementation RoutePlanViewController
- (MGLMapView *)mapView{
    if (_mapView == nil) {
//        NSURL *url = [NSURL URLWithString:@"http://tiles.emapgo.cn/styles/outdoor/style.json"];
        NSURL *url = [NSURL URLWithString:@"http://tiles.emapgo.cn/styles/outdoor/style.json"];
        _mapView = [[MGLMapView alloc] initWithFrame:CGRectMake(0, TableViewTop, DEF_SCREEN_WIDTH, TableViewHeight) styleURL:url];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
    }
    return _mapView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DEF_SCREEN_HEIGHT - 100, DEF_SCREEN_WIDTH, TableViewHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 56;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _nowroadNumber = 0;
    
    [self makeUI];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    self.view.backgroundColor = getColor(@"ffffff");
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, StatusBarTHeight + 5, 30, 25);
    //        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _startField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(backButton.frame), DEF_SCREEN_WIDTH-40,30)];
    _startField.backgroundColor = getColor(@"f2f2f2");
    _startField.font = [UIFont systemFontOfSize:14];
    _startField.textColor = [UIColor blackColor];
    _startField.placeholder = @"输入起点";
    _startField.text = @"我的位置";
    _startField.delegate = self;
//    _startField.clearButtonMode = UITextFieldViewModeAlways;
    _startField.leftViewMode = UITextFieldViewModeAlways;
    _startField.returnKeyType = UIReturnKeyDone;
    _startField.enabled = NO;
    [self.view addSubview:_startField];
    
    UIButton *greenPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    greenPointBtn.frame = CGRectMake(0, 0, 30, 30);
    greenPointBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [greenPointBtn setImage:[UIImage imageNamed:@"greenPoint"] forState:UIControlStateNormal];
    _startField.leftView = greenPointBtn;
    
    _endField = [[UITextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_startField.frame), DEF_SCREEN_WIDTH-40,30)];
    _endField.backgroundColor = getColor(@"f2f2f2");
    _endField.font = [UIFont systemFontOfSize:14];
    _endField.textColor = [UIColor blackColor];
    _endField.placeholder = @"输入终点";
    _endField.text = _destinationDic[@"name"];
    _endField.delegate = self;
//    _endField.clearButtonMode = UITextFieldViewModeAlways;
    _endField.enabled = NO;
    _endField.leftViewMode = UITextFieldViewModeAlways;
    _endField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_endField];
    
    UIButton *redPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redPointBtn.frame = CGRectMake(0, 0, 30, 30);
    redPointBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [redPointBtn setImage:[UIImage imageNamed:@"redPoint"] forState:UIControlStateNormal];
    _endField.leftView = redPointBtn;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(_startField.frame), DEF_SCREEN_WIDTH-80, 1)];
    lineView.backgroundColor = getColor(@"e6e6e6");
    [self.view addSubview:lineView];
    
    NSArray *nameArr = @[@"驾车",@"骑行",@"步行"];
    for (int i = 0; i < 3; i ++) {
        UIButton *roadStyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        roadStyleBtn.frame = CGRectMake(60*i, CGRectGetMaxY(_endField.frame) + 5, 60, 30);
        roadStyleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [roadStyleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [roadStyleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [roadStyleBtn setTitle:nameArr[i] forState:UIControlStateNormal];
        [roadStyleBtn addTarget:self action:@selector(roadStyleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:roadStyleBtn];
        if (i == 0) {
            _wayReplaceBtn = roadStyleBtn;
            _wayReplaceBtn.selected = YES;
        }
    }
    
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.tableView];
}

- (void)getData{
    
    NSDictionary *locationDic = DEF_PERSISTENT_GET_OBJECT(@"userLocation");
    EMapgoRouteStepModel *startModel = [[EMapgoRouteStepModel alloc] init];
    startModel.lon = locationDic[@"longitude"];
    startModel.lat = locationDic[@"latitude"];
    EMapgoRouteStepModel *endModel = [[EMapgoRouteStepModel alloc] init];
    endModel.lon = self.destinationDic[@"lon"];
    endModel.lat = self.destinationDic[@"lat"];
    
    EMapRoadPlanning *roadplan = [[EMapRoadPlanning alloc] init];
    roadplan.URL = @"111.203.245.100:3000";
    roadplan.profile = @"driving";
    roadplan.geometries = @"polyline";
    roadplan.steps = @"true";
    roadplan.overview = @"full";
    roadplan.alternatives = @"true";
    roadplan.startModel = startModel;
    roadplan.endModel = endModel;
    
    __weak typeof(self) weakSelf = self;
    [roadplan roadPlanningWithsuccess:^(NSDictionary *data) {
        
        weakSelf.requestDic = data;
        EMapRoadPlanDataManager *dataM = [[EMapRoadPlanDataManager alloc] initWithRoadData:data];
        EMapgoRouteDetailModel *model = dataM.roadDetailArray[0];
        
        [weakSelf.dataArray addObjectsFromArray:dataM.roadStepArray];
        weakSelf.nowRouteArray = dataM.roadStepArray[0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf createTableHeaderWithData:dataM.roadDetailArray];
            [weakSelf.tableView reloadData];
            
            [weakSelf addRoadLineWithDic:weakSelf.requestDic];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)createTableHeaderWithData:(NSArray *)routeArr{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_HEIGHT, 100)];
    headerView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < routeArr.count; i ++) {
        EMapgoRouteDetailModel *model = routeArr[i];
        UIButton *planBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        planBtn.frame = CGRectMake(DEF_SCREEN_WIDTH/routeArr.count*i, 0, DEF_SCREEN_WIDTH/routeArr.count, 100);
        planBtn.titleLabel.numberOfLines = 0;
        planBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        planBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        planBtn.layer.borderWidth = 1;
        planBtn.layer.borderColor = getColor(@"f1f1f1").CGColor;
        [planBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [planBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [planBtn setTitle:[NSString stringWithFormat:@"方案%i\n%@\n%@", i+1, model.roadtime, model.roadDistance] forState:UIControlStateNormal];
        planBtn.tag = i+10000;
        [planBtn addTarget:self action:@selector(planAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:planBtn];
        if (i == 0) {
            _planReplaceBtn = planBtn;
            _planReplaceBtn.selected = YES;
        }
    }
    self.tableView.tableHeaderView = headerView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)roadStyleAction:(UIButton *)btn{
    _wayReplaceBtn.selected = NO;
    _wayReplaceBtn = btn;
    _wayReplaceBtn.selected = YES;
    
    if (_selectPolyline) {
        
        [self.mapView removeAnnotation:_selectPolyline];
        _selectPolyline = nil;
    }
}
- (void)planAction:(UIButton *)btn{
    if (btn == _planReplaceBtn) {
        btn.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.7 animations:^{
            if (self.tableView.frame.origin.y == TableViewTop) {
                self.tableView.frame = CGRectMake(0, DEF_SCREEN_HEIGHT-100, DEF_SCREEN_WIDTH, TableViewHeight);
            }else{
                self.tableView.frame = CGRectMake(0, TableViewTop, DEF_SCREEN_WIDTH, TableViewHeight);
            }
        } completion:^(BOOL finished) {
            btn.userInteractionEnabled = YES;
        }];
    }else{
        _planReplaceBtn.selected = NO;
        _planReplaceBtn = btn;
        _planReplaceBtn.selected = YES;
        
        _nowroadNumber = btn.tag-10000;
        [self addRoadLineWithDic:_requestDic];
        
        _nowRouteArray = _dataArray[btn.tag-10000];
        [self.tableView reloadData];
    }
    
//    _planReplaceBtn.selected = NO;
//    //把上一次选择的路线置灰
//    MGLLineStyleLayer *baseRouteLayer1 = (MGLLineStyleLayer *)[self.mapView.style layerWithIdentifier:[NSString stringWithFormat:@"layer%li", _planReplaceBtn.tag-10000]];
//    baseRouteLayer1.lineColor = [NSExpression expressionForConstantValue:[UIColor grayColor]];
//    baseRouteLayer1.lineOpacity = [NSExpression expressionForConstantValue:@0.5];
//
//    _planReplaceBtn = btn;
//    _planReplaceBtn.selected = YES;
//
//    //把本次选择的路线置蓝
//    MGLLineStyleLayer *baseRouteLayer2 = (MGLLineStyleLayer *)[self.mapView.style layerWithIdentifier:[NSString stringWithFormat:@"layer%li", _planReplaceBtn.tag-10000]];
//    baseRouteLayer2.lineColor = [NSExpression expressionForConstantValue:[UIColor blueColor]];
//    baseRouteLayer2.lineOpacity = [NSExpression expressionForConstantValue:@1];
//
//    _nowRouteArray = _dataArray[btn.tag-10000];
//    [self.tableView reloadData];
}

//- (void)addStyleRouteLine{
//    int i = 0;
//    for (NSArray *routeArr in _dataArray) {
//        CLLocationCoordinate2D coords[routeArr.count];
//        for (int i = 0; i < routeArr.count; i ++) {
//            EMapgoRouteStepModel *model = routeArr[i];
//            coords[i] = CLLocationCoordinate2DMake([model.lat floatValue], [model.lon floatValue]);
//            NSLog(@"%@", model.stepDescription);
//        }
//        [self.mapView setCenterCoordinate:coords[routeArr.count/2] zoomLevel:10 animated:YES];
//        MGLPolylineFeature *routeLine = [MGLPolylineFeature polylineWithCoordinates:coords count:routeArr.count];
//
//        MGLShapeSource *routeSource = [[MGLShapeSource alloc] initWithIdentifier:[NSString stringWithFormat:@"style%i", i] shape:routeLine options:nil];
//        [self.mapView.style addSource:routeSource];
//
//        MGLLineStyleLayer *baseRouteLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"layer%i", i] source:routeSource];
//        if (i == 0) {
//            baseRouteLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor blueColor]];
//            baseRouteLayer.lineOpacity = [NSExpression expressionForConstantValue:@1];
//        }else{
//            baseRouteLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor grayColor]];
//            baseRouteLayer.lineOpacity = [NSExpression expressionForConstantValue:@0.5];
//        }
//        baseRouteLayer.lineWidth = [NSExpression expressionForConstantValue:@4];
//        baseRouteLayer.lineCap = [NSExpression expressionForConstantValue:@"round"];
//        baseRouteLayer.lineJoin = [NSExpression expressionForConstantValue:@"round"];
//        [self.mapView.style addLayer:baseRouteLayer];
//
////        MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coords count:routeArr.count];
////        [self.mapView addAnnotation:polyline];
////        [self.mapView setVisibleCoordinates:coords count:routeArr.count edgePadding:UIEdgeInsetsZero animated:YES];
//        i++;
//    }
//}

#pragma mark - 添加路线规划道路

- (void)addRoadLineWithDic:(NSDictionary *)routeDic{
    if (self.mapView.annotations) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    NSDictionary *locationDic = DEF_PERSISTENT_GET_OBJECT(@"userLocation");
    CLLocationCoordinate2D userCoor = CLLocationCoordinate2DMake([locationDic[@"latitude"] floatValue], [locationDic[@"longitude"] floatValue]);
    CLLocationCoordinate2D destinationCoor = CLLocationCoordinate2DMake([_destinationDic[@"latitude"] floatValue], [_destinationDic[@"longitude"] floatValue]);
    NSArray<MBWaypoint *> *waypoints = @[[[MBWaypoint alloc] initWithCoordinate:userCoor coordinateAccuracy:-1 name:nil],
                                         [[MBWaypoint alloc] initWithCoordinate:destinationCoor coordinateAccuracy:-1 name:nil]];
    MBRouteOptions *options = [[MBRouteOptions alloc] initWithWaypoints:waypoints profileIdentifier:MBDirectionsProfileIdentifierAutomobileAvoidingTraffic];
    MBRoute *route = [[MBRoute alloc] initWithJSON:routeDic[@"routes"][_nowroadNumber] waypoints:waypoints routeOptions:options];
    
    CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
    [route getCoordinates:routeCoordinates];
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:routeCoordinates count:route.coordinateCount];
    
    [self.mapView addRoutePlanningArrowStyleWithIdentifier:@"polyline" shape:polyline lineWidth:10 lineColor:[UIColor colorWithRed:95 / 255.5 green:153 / 255.0 blue:255 / 255.0 alpha:1] borderColor:[UIColor colorWithRed:46 / 255.5 green:88 / 255.0 blue:167 / 255.0 alpha:1]];
    
    [self.mapView setVisibleCoordinates:routeCoordinates count:route.coordinateCount edgePadding:UIEdgeInsetsMake(80, 80, 80, 80) animated:YES];
    
    _selectPolyline = polyline;
    
    free(routeCoordinates);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MGLMapViewDelegate
- (void)mapViewDidFinishLoadingMap:(MGLMapView *)mapView {
//    [self addStyleRouteLine];
//    [self addRoadLineWithDic:_requestDic];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nowRouteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RoutePlanTableViewCell";
    
    RoutePlanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RoutePlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMapgoRouteStepModel *model = _nowRouteArray[indexPath.row];
    cell.nameLabel.text = model.stepDescription;
    cell.distanceLabel.text = model.distance;
    cell.addressImageView.image = model.dirsectionImage;
    cell.addressImageView.transform = CGAffineTransformMakeScale(model.isTransform?-1:1, 1);
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)dealloc{
    _mapView.delegate = nil;
    _mapView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
