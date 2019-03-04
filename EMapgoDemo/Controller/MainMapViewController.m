//
//  MainMapViewController.m
//  EMapgoTest
//
//  Created by MaRui on 2018/6/1.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import "MainMapViewController.h"
#import <EMapgo/EMapgo.h>
#import <EMapgoPOI/EMapgoPOI.h>
#import "EMapgoConfig.h"
#import "SearchView.h"
#import "RoutePlanViewController.h"
//#import "GPSLocationTool.h"
#import "FunctionViewController.h"
#import "PersonalViewController.h"

@interface MainMapViewController ()<UITextFieldDelegate,MGLMapViewDelegate,MGLComputedShapeSourceDataSource>{
    NSDictionary *_routeEndDic;
}
@property (nonatomic) MGLMapView *mapView;
@property (nonatomic, strong) UITextField *searchField;//
@property (nonatomic, strong) SearchView *searchView;//
@property (nonatomic, copy) NSArray *annotationsArray;
@property (nonatomic) MGLCoordinateBounds colorado;
@end

@implementation MainMapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (MGLMapView *)mapView{
    if (_mapView == nil) {
        
        NSURL *url = [NSURL URLWithString:@"http://tiles.emapgo.cn/styles/outdoor/style.json"];
        _mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds styleURL:url];
        _mapView.centerCoordinate = CLLocationCoordinate2DMake(39.914935, 116.405419);
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES];
        _mapView.showsScale = YES;
        _mapView.commpassTop = 60;
        _mapView.scaleTop = 60;
        _mapView.showsUserLocation = YES;
        _mapView.showsHeading = YES;
        _mapView.delegate = self;

    }
    return _mapView;
}

- (NSArray *)annotationsArray {
    if (_annotationsArray == nil) {
        CLLocationCoordinate2D coords[2];
        coords[0] = CLLocationCoordinate2DMake(39.980528, 116.306745);
        coords[1] = CLLocationCoordinate2DMake(40.000, 116.306745);
        NSMutableArray *pointsArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 2; ++i) {
            MGLPointAnnotation *pointAnnotation = [[MGLPointAnnotation alloc] init];
            pointAnnotation.coordinate  = coords[i];
            pointAnnotation.title       = [NSString stringWithFormat:@"title：%ld", (long)i];
            pointAnnotation.subtitle    = [NSString stringWithFormat:@"subtitle: %ld%ld%ld", (long)i,(long)i,(long)i];
            [pointsArray addObject:pointAnnotation];
        }
        _annotationsArray = [pointsArray copy];
    }
    return _annotationsArray;
}

- (SearchView *)searchView{
    if (_searchView == nil) {
        _searchView = [[SearchView alloc] init];
    }
    return _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Colorado’s bounds
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(41.914935, 121.405419);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(37.914935, 113.405419);
    self.colorado = MGLCoordinateBoundsMake(sw, ne);
    
    [self makeUI];
    // Do any additional setup after loading the view.
}

- (void)makeUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    UIView *topSearchView = [[UIView alloc] initWithFrame:CGRectMake(15, StatusBarTHeight+2, DEF_SCREEN_WIDTH-30, 40)];
    topSearchView.backgroundColor = [UIColor whiteColor];
    topSearchView.layer.cornerRadius = 5;
    topSearchView.layer.masksToBounds = YES;
    [self.view addSubview:topSearchView];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, DEF_SCREEN_WIDTH-30,30)];
    _searchField.backgroundColor = [UIColor whiteColor];;
    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.textColor = [UIColor blackColor];
    _searchField.delegate = self;
    _searchField.placeholder = @"查找地点、公交、地铁";
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    [topSearchView addSubview:_searchField];
    
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(0, 0, 40, 25);
    personBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [personBtn setImage:[UIImage imageNamed:@"personImage"] forState:UIControlStateNormal];
    [personBtn addTarget:self action:@selector(personAction:) forControlEvents:UIControlEventTouchUpInside];
    _searchField.leftView = personBtn;
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-35, DEF_SCREEN_HEIGHT - SafeAreaBottomHeight -35 - 35, 30, 30);
    locationBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    functionBtn.frame = CGRectMake(DEF_SCREEN_WIDTH-35, DEF_SCREEN_HEIGHT- SafeAreaBottomHeight -70 - 35, 30, 30);
    functionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [functionBtn setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    [functionBtn addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:functionBtn];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPress];
}
#pragma mark - LongPress Actions
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:longPress.view];
        CLLocationCoordinate2D pointCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        EMapPOISearch *poiSearch = [[EMapPOISearch alloc] init];
        poiSearch.lat = [NSString stringWithFormat:@"%f", pointCoordinate.latitude];
        poiSearch.lon = [NSString stringWithFormat:@"%f", pointCoordinate.longitude];
        poiSearch.size = @"1";
        poiSearch.type = @"1";
        poiSearch.sort = @"1";
        __weak typeof(self) weakSelf = self;
        [poiSearch startPOISearchWithsuccess:^(NSDictionary *data) {
            NSLog(@"成功");
            if ([data[@"list"] count] == 1) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf addLongPressAnnotationWithCoordinate:pointCoordinate title:[data[@"list"][0] objectForKey:@"name"]];
                });
            }
            
        } failure:^(NSError *error) {
            NSLog(@"失败");
        }];
    }
}
- (void)addLongPressAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title{
    MGLPointAnnotation *pointAnnotation = [[MGLPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = title;
    
    [self.mapView addAnnotation:pointAnnotation];
    [self.mapView selectAnnotation:pointAnnotation animated:YES];
}

#pragma mark - Private Method
- (void)personAction:(UIButton *)btn{
    PersonalViewController *personVC = [[PersonalViewController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)locationAction:(UIButton *)btn{
    [_mapView setStyleURL:[NSURL URLWithString:@"http://tiles.emapgo.cn/styles/outdoor/style.json"]];
    self.mapView.userTrackingMode = MGLUserTrackingModeFollow;
}

- (void)functionAction:(UIButton *)btn{
    __weak typeof(self) weakSelf = self;
    FunctionViewController *functionVC = [[FunctionViewController alloc] init];
    functionVC.selectBlock = ^(NSInteger index) {
        [weakSelf dosomeWithIndex:index];
    };
    [self.navigationController pushViewController:functionVC animated:YES];
}
- (void)dosomeWithIndex:(NSInteger)index{
    switch (index) {
        case 0:{
            [self.mapView addAnnotations:self.annotationsArray];
        }
            break;
        case 1:{
            [self drawShape];
        }
            break;
        case 2:{
            [self drawPolyline];
        }
            break;
        case 3:{
            [self addRouteline];
        }
            break;
        case 4:{
            [self addCircleLayer];
        }
            break;
        case 5:{
            [self addLatLonGrid];
        }
            break;
        case 6:{
            [self addSource];
        }
            break;
        case 7:{
            [self styleRasterTileSource];
        }
            break;
        case 8:{
            [self styleImageSource];
        }
            break;
        case 9:{
            [self styleBuildingLayer];
        }
            break;
        case 10:{
            [self removeParkLayer];
        }
            break;
        case 11:{
            self.mapView.debugMask ^= MGLMapDebugOverdrawVisualizationMask;
        }
            break;
        case 12:{
            [self Mapthree_d];
        }
            break;
        case 13:{
            [self addThree_dLayerSource];
        }
            break;
        case 14:{
            [self animateAnnotationView];
        }
            break;
            
        default:
            break;
    }
}

- (void)routeAction:(UIButton *)btn{
    RoutePlanViewController *routeVC = [[RoutePlanViewController alloc] init];
    routeVC.destinationDic = _routeEndDic;
    [self.navigationController pushViewController:routeVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.searchView showInView:self.view];
    __weak typeof(self) weakSelf = self;
    self.searchView.goRoadBlock = ^(NSDictionary *addressInfo) {
        RoutePlanViewController *routeVC = [[RoutePlanViewController alloc] init];
        routeVC.destinationDic = addressInfo;
        [weakSelf.navigationController pushViewController:routeVC animated:YES];
    };
    return NO;
}

#pragma mark - MGLMapViewDelegate
- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation{
    NSDictionary *userLocationDic = @{@"latitude":[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude],@"longitude":[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude]};
    DEF_PERSISTENT_SET_OBJECT(userLocationDic, @"userLocation");
}
- (void)mapView:(MGLMapView *)mapView regionWillChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated{
    if (reason == MGLCameraChangeReasonGesturePinch || reason == MGLCameraChangeReasonGestureZoomOut) {

        NSLog(@"begin");
        [self doWithLayerHiddenOrShow:NO];
    }
}
- (void)mapView:(MGLMapView *)mapView regionDidChangeWithReason:(MGLCameraChangeReason)reason animated:(BOOL)animated{

    if (reason == MGLCameraChangeReasonGesturePinch || reason == MGLCameraChangeReasonGestureZoomOut || reason == 24 || reason == 25 || reason == 8) {
        NSLog(@"end");
        [self doWithLayerHiddenOrShow:YES];
    }
}

//解决缩放时文字堆到一起， 代理调用
- (void)doWithLayerHiddenOrShow:(BOOL)isShow{
    NSArray *layerIdentifierArr = @[@"china-POI-scalerank5",@"china-POI-scalerank4",@"china-POI-park-scalerank4",@"china-POI-scalerank3",@"china-POI-park-scalerank3",@"china-POI-park-scalerank2",@"china-POI-scalerank2",@"china-POI-park-scalerank1",@"china-POI-scalerank1",@"china-road-label-mini",@"china-road-label-small",@"china-road-label-medium",@"china-road-label-large",@"china-road-label-bridge-overpass",@"china-place-village",@"china-place-township"];
    for (NSString *layerIdentifier in layerIdentifierArr) {
        MGLStyleLayer *layer = [self.mapView.style layerWithIdentifier:layerIdentifier];
        layer.visible = isShow;
    }
}

//- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation
//{
//    if (annotation == mapView.userLocation)
//    {
//        return nil;
//    }
//
//    MGLAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"aaa"];
//    if (!annotationView)
//    {
//        annotationView = [[MGLAnnotationView alloc] initWithReuseIdentifier:@"aaa"];
//        annotationView.frame = CGRectMake(0, 0, 10, 10);
//        annotationView.backgroundColor = [UIColor redColor];
//
//        // Note that having two long press gesture recognizers on overlapping
//        // views (`self.view` & `annotationView`) will cause weird behaviour.
//        // Comment out the pin dropping functionality in the handleLongPress:
//        // method in this class to make draggable annotation views play nice.
//        annotationView.draggable = YES;
//    } else {
//        // orange indicates that the annotation view was reused
//        annotationView.backgroundColor = [UIColor orangeColor];
//    }
//    return annotationView;
//}

// Use the default marker. See also: our view annotation or custom marker examples.
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation{
    return nil;
}

// Allow callout view to appear when an annotation is tapped.
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}

//气泡右侧视图，
- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view.backgroundColor= [UIColor lightGrayColor];
    UIButton *goBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    goBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [goBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [goBtn setTitle:@"去这里" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(routeAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:goBtn];
    return view;
}
- (void)mapView:(MGLMapView *)mapView didSelectAnnotation:(id<MGLAnnotation>)annotation{
    
    NSLog(@"%d", [annotation isKindOfClass:[MGLUserLocation class]]);
    
    _routeEndDic = @{@"name":annotation.title,@"lat":[NSString stringWithFormat:@"%f", annotation.coordinate.latitude],@"lon":[NSString stringWithFormat:@"%f", annotation.coordinate.longitude]};
}

//限制地图显示范围
//- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera{
//    // Get the current camera to restore it after.
//    MGLMapCamera *currentCamera = mapView.camera;
//    
//    // From the new camera obtain the center to test if it’s inside the boundaries.
//    CLLocationCoordinate2D newCameraCenter = newCamera.centerCoordinate;
//    
//    // Set the map’s visible bounds to newCamera.
//    mapView.camera = newCamera;
//    MGLCoordinateBounds newVisibleCoordinates = mapView.visibleCoordinateBounds;
//    
//    // Revert the camera.
//    mapView.camera = currentCamera;
//    
//    // Test if the newCameraCenter and newVisibleCoordinates are inside self.colorado.
//    BOOL inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado);
//    BOOL intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.colorado);
//    
//    return inside && intersects;
//}

#pragma mark - MGLComputedShapeSourceDataSource
- (NSArray<id <MGLFeature>>*)featuresInCoordinateBounds:(MGLCoordinateBounds)bounds zoomLevel:(NSUInteger)zoom {
    double gridSpacing;
    if(zoom >= 13) {
        gridSpacing = 0.01;
    } else if(zoom >= 11) {
        gridSpacing = 0.05;
    } else if(zoom == 10) {
        gridSpacing = .1;
    } else if(zoom == 9) {
        gridSpacing = 0.25;
    } else if(zoom == 8) {
        gridSpacing = 0.5;
    } else if (zoom >= 6) {
        gridSpacing = 1;
    } else if(zoom == 5) {
        gridSpacing = 2;
    } else if(zoom >= 4) {
        gridSpacing = 5;
    } else if(zoom == 2) {
        gridSpacing = 10;
    } else {
        gridSpacing = 20;
    }
    
    NSMutableArray <id <MGLFeature>> * features = [NSMutableArray array];
    CLLocationCoordinate2D coords[2];
    
    for (double y = ceil(bounds.ne.latitude / gridSpacing) * gridSpacing; y >= floor(bounds.sw.latitude / gridSpacing) * gridSpacing; y -= gridSpacing) {
        coords[0] = CLLocationCoordinate2DMake(y, bounds.sw.longitude);
        coords[1] = CLLocationCoordinate2DMake(y, bounds.ne.longitude);
        MGLPolylineFeature *feature = [MGLPolylineFeature polylineWithCoordinates:coords count:2];
        feature.attributes = @{@"value": @(y)};
        [features addObject:feature];
    }
    
    for (double x = floor(bounds.sw.longitude / gridSpacing) * gridSpacing; x <= ceil(bounds.ne.longitude / gridSpacing) * gridSpacing; x += gridSpacing) {
        coords[0] = CLLocationCoordinate2DMake(bounds.sw.latitude, x);
        coords[1] = CLLocationCoordinate2DMake(bounds.ne.latitude, x);
        MGLPolylineFeature *feature = [MGLPolylineFeature polylineWithCoordinates:coords count:2];
        feature.attributes = @{@"value": @(x)};
        [features addObject:feature];
    }
    
    return features;
}


- (void)dealloc{
    _mapView.delegate = nil;
    _mapView = nil;
}

- (void)drawShape {
    // Create a coordinates array to hold all of the coordinates for our shape.
    
    CLLocationCoordinate2D coordinates[] = {
        CLLocationCoordinate2DMake(39.919362, 116.205923),
        CLLocationCoordinate2DMake(39.898995, 116.293885),
        CLLocationCoordinate2DMake(39.877736, 116.26169),
    };
    
    [self.mapView setCenterCoordinate:coordinates[1] zoomLevel:11 animated:YES];
    NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
    
    // Create our shape with the formatted coordinates array
    MGLPolygon *shape = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfCoordinates];
    // Add the shape to the map
    [self.mapView addAnnotation:shape];
}
- (void)drawPolyline{
    CLLocationCoordinate2D lineCoordinates[4] = {
        CLLocationCoordinate2DMake(39.994579, 116.29561),
        CLLocationCoordinate2DMake(40.008286, 116.375523),
        CLLocationCoordinate2DMake(39.983081, 116.42669),
        CLLocationCoordinate2DMake(39.952556, 116.476708)
    };
    
    [self.mapView setCenterCoordinate:lineCoordinates[1] zoomLevel:10 animated:YES];
    
    MGLPolyline *line = [MGLPolyline polylineWithCoordinates:lineCoordinates count:4];
    [self.mapView addAnnotation:line];
}
- (void)addCircleLayer{
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(36.9979, 119.0441) zoomLevel:14 animated:NO];
    
    CLLocationCoordinate2D coordinates[] = {
        {37.00145594210082, 119.04960632324219},
        {37.00173012609867, 119.0404224395752},
        {36.99508088541243, 119.04007911682129},
        {36.99453246847359, 119.04960632324219},
        {37.00145594210082, 119.04960632324219},
    };
    MGLPointCollectionFeature *feature = [MGLPointCollectionFeature pointCollectionWithCoordinates:coordinates count:5];
    MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:@"wiggle-source" shape:feature options:nil];
    [self.mapView.style addSource:source];
    
    MGLCircleStyleLayer *layer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"wiggle-layer" source:source];
    [self.mapView.style addLayer:layer];
}

- (void)addLatLonGrid
{
    MGLComputedShapeSource *source = [[MGLComputedShapeSource alloc] initWithIdentifier:@"latlon"
                                                                                options:@{MGLShapeSourceOptionMaximumZoomLevel:@14}];
    source.dataSource = self;//设置MGLComputedShapeSourceDataSource代理
    [self.mapView.style addSource:source];
    MGLLineStyleLayer *lineLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"latlonlines"
                                                                          source:source];
    [self.mapView.style addLayer:lineLayer];
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation {
    // Set the alpha for shape annotations to 0.5 (half opacity)
    return ([annotation isKindOfClass:[MGLPolygon class]] ? 0.5 : 1.0);
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    // Set the stroke color for shape annotations
    return [UIColor redColor];
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
    // Mapbox cyan fill color
    return [UIColor purpleColor];//[UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
}

- (void)mapView:(MGLMapView *)mapView handleSingleTapWithPoint:(CGPoint)point{
    
    NSLog(@"单击了地图！！！");
}

//polyline
- (void)addRouteline{
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(39.967599, 116.491081), CLLocationCoordinate2DMake(39.877293, 116.427265));
    [self.mapView setVisibleCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(150, 90, 150, 90) animated:YES];
    CLLocationCoordinate2D coords[] = {
        { 39.967599, 116.491081 },
        { 39.952999, 116.481882 },
        { 39.91405, 116.485332 },
        { 39.91405, 116.442788 },
        { 39.877293, 116.427265 }
    };
    NSInteger count = sizeof(coords) / sizeof(coords[0]);
    
//    [self.mapView setCenterCoordinate:coords[2] zoomLevel:10 animated:YES];
    
    MGLPolylineFeature *routeLine = [MGLPolylineFeature polylineWithCoordinates:coords count:count];
    
    MGLShapeSource *routeSource = [[MGLShapeSource alloc] initWithIdentifier:@"style-route-source" shape:routeLine options:nil];
    [self.mapView.style addSource:routeSource];
    
    MGLLineStyleLayer *baseRouteLayer = [[MGLLineStyleLayer alloc] initWithIdentifier:@"style-base-route-layer" source:routeSource];
    baseRouteLayer.lineColor = [NSExpression expressionForConstantValue:[UIColor blueColor]];
    baseRouteLayer.lineWidth = [NSExpression expressionForConstantValue:@5];
    baseRouteLayer.lineOpacity = [NSExpression expressionForConstantValue:@0.5];
    baseRouteLayer.lineCap = [NSExpression expressionForConstantValue:@"round"];
    baseRouteLayer.lineJoin = [NSExpression expressionForConstantValue:@"round"];
    [self.mapView.style addLayer:baseRouteLayer];
}

- (void)addSource{
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.748889, 120.492513)];
    
    NSString *tileURL = @"http://geos.emapgo.cn/wuzhen/wms?bbox={bbox-epsg-3857}&format=image/png&service=WMS&version=1.1.0&request=GetMap&srs=EPSG:3857&layers=wuzhen:wuzhen20180727&width=512&height=512&TRANSPARENT=true";
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(30.71859915, 120.4716026), CLLocationCoordinate2DMake(30.7637749, 120.515944));
    MGLRasterTileSource *rasterTileSource = [[MGLRasterTileSource alloc] initWithIdentifier:@"wz_hand_dong" tileURLTemplates:@[tileURL] options:@{MGLTileSourceOptionTileSize: @512,MGLTileSourceOptionMinimumZoomLevel:@10,MGLTileSourceOptionMaximumZoomLevel:@19, MGLTileSourceOptionCoordinateBounds:@(bounds)}];
    [self.mapView.style addSource:rasterTileSource];
    
    MGLRasterStyleLayer *rasterLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"web-map-layer" source:rasterTileSource];
    //文字图层
    MGLStyleLayer *labelLayer = [self.mapView.style layerWithIdentifier:@"housenum-label"];
    //加到文字图层下面
    [self.mapView.style insertLayer:rasterLayer belowLayer:labelLayer];
    
    [self.mapView setVisibleCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(100, 60, 100, 60) animated:YES];
}

- (void)styleRasterTileSource
{
    self.mapView.zoomLevel = 10;
    NSString *tileURL = [NSString stringWithFormat:@"https://stamen-tiles.a.ssl.fastly.net/terrain-background/{z}/{x}/{y}%@.jpg", UIScreen.mainScreen.nativeScale > 1 ? @"@2x" : @""];
    MGLRasterTileSource *rasterTileSource = [[MGLRasterTileSource alloc] initWithIdentifier:@"style-raster-tile-source-id" tileURLTemplates:@[tileURL] options:@{
                                                                                                                                                                 MGLTileSourceOptionTileSize: @256,
                                                                                                                                                                 }];
    [self.mapView.style addSource:rasterTileSource];
    
    MGLRasterStyleLayer *rasterLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"style-raster-layer-id" source:rasterTileSource];
    [self.mapView.style addLayer:rasterLayer];
}

- (void)styleImageSource
{
    MGLCoordinateQuad coordinateQuad = {
        {39.967599, 116.491081},
        {32.967599, 116.491081},
        {32.967599, 108.491081},
        {39.967599, 108.491081} };
    
    MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(39.967599, 116.491081), CLLocationCoordinate2DMake(39.967599, 108.491081));
    
    [self.mapView setVisibleCoordinateBounds:bounds edgePadding:UIEdgeInsetsMake(100, 60, 100, 60) animated:YES];
    
    MGLImageSource *imageSource = [[MGLImageSource alloc] initWithIdentifier:@"style-image-source-id" coordinateQuad:coordinateQuad URL:[NSURL URLWithString:@"https://www.mapbox.com/mapbox-gl-js/assets/radar0.gif"]];
    
    [self.mapView.style addSource:imageSource];
    
    MGLRasterStyleLayer *rasterLayer = [[MGLRasterStyleLayer alloc] initWithIdentifier:@"style-raster-image-layer-id" source:imageSource];
    [self.mapView.style addLayer:rasterLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateAnimatedImageSource:)
                                   userInfo:imageSource
                                    repeats:YES];
}


- (void)updateAnimatedImageSource:(NSTimer *)timer {
    static int radarSuffix = 0;
    MGLImageSource *imageSource = (MGLImageSource *)timer.userInfo;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.mapbox.com/mapbox-gl-js/assets/radar%d.gif", radarSuffix++]];
    [imageSource setValue:url forKey:@"URL"];
    if (radarSuffix > 3) {
        radarSuffix = 0;
    }
}

- (void)styleBuildingLayer
{
    MGLTransition transition =  { 5,  1 };
    self.mapView.style.transition = transition;
    MGLFillStyleLayer *buildingLayer = (MGLFillStyleLayer *)[self.mapView.style layerWithIdentifier:@"china-building"];//china-river  china-ocean-lz  china-building   background
    buildingLayer.fillColor = [NSExpression expressionForConstantValue:[UIColor purpleColor]];
}

- (void)removeParkLayer
{
    MGLFillStyleLayer *parkLayer = (MGLFillStyleLayer *)[self.mapView.style layerWithIdentifier:@"china-landuse-park-golf"];
    [self.mapView.style removeLayer:parkLayer];
}

- (void)Mapthree_d{
    [_mapView setStyleURL:[NSURL URLWithString:@"http://192.168.11.148:10003/styles/outdoor_3Dbuilding/style.json"]];
    [_mapView setZoomLevel:16];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.236886, 121.501898) animated:YES];
}

- (void)addThree_dLayerSource{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(36.9979, 119.0441);
    [self.mapView setCenterCoordinate:coordinate zoomLevel:14 animated:NO];
    
    MGLBackgroundStyleLayer *buildingLayer1 = (MGLBackgroundStyleLayer *)[self.mapView.style layerWithIdentifier:@"background"];
    buildingLayer1.backgroundColor = [NSExpression expressionForConstantValue:[UIColor blackColor]];
    buildingLayer1.backgroundOpacity = [NSExpression expressionForConstantValue:@0.7];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 1; i ++) {
            @autoreleasepool {
                CLLocationCoordinate2D coordinateNew;
                switch (i%4) {
                    case 0:
                        coordinateNew = CLLocationCoordinate2DMake(coordinate.latitude-i*0.001, coordinate.longitude);
                        break;
                    case 1:
                        coordinateNew = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude-i*0.001);
                        break;
                    case 2:
                        coordinateNew = CLLocationCoordinate2DMake(coordinate.latitude+i*0.001, coordinate.longitude);
                        break;
                    case 3:
                        coordinateNew = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude+i*0.001);
                        break;
                        
                    default:
                        break;
                }
                
                
                CLLocationCoordinate2D coordinates[] = {
                    {coordinateNew.latitude-0.0003, coordinateNew.longitude},
                    {coordinateNew.latitude, coordinateNew.longitude-0.0003},
                    {coordinateNew.latitude+0.0003, coordinateNew.longitude},
                    {coordinateNew.latitude, coordinateNew.longitude+0.0003},
                    {coordinateNew.latitude-0.0003, coordinateNew.longitude},
                };
                MGLPointCollectionFeature *feature = [MGLPointCollectionFeature pointCollectionWithCoordinates:coordinates count:5];
                MGLShapeSource *source = [[MGLShapeSource alloc] initWithIdentifier:[NSString stringWithFormat:@"3d-source%i", i] shape:feature options:nil];
                [self.mapView.style addSource:source];
                
                MGLFillExtrusionStyleLayer *layer = [[MGLFillExtrusionStyleLayer alloc] initWithIdentifier:[NSString stringWithFormat:@"buildings%i", i] source:source];
                layer.sourceLayerIdentifier = [NSString stringWithFormat:@"3d-source%i", i];
                layer.minimumZoomLevel = 12;
                layer.fillExtrusionHeight = [NSExpression expressionForConstantValue:@2000];
                layer.fillExtrusionColor = [NSExpression expressionForConstantValue:[UIColor redColor]];
                layer.fillExtrusionOpacity = [NSExpression expressionForConstantValue:@0.8];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView.style addLayer:layer];
                });
            }
        }
    });
}

- (void)removeSelfAddLayer{
    NSArray *layerIdentifierArr = @[@"wiggle-layer",@"latlonlines",@"style-base-route-layer",@"web-map-layer",@"web-map-layer1",@"style-raster-layer-id",@"style-raster-image-layer-id",@"style-raster-image-layer-id"];
    for (NSString *identifierStr in layerIdentifierArr) {
        MGLStyleLayer *parkLayer = [self.mapView.style layerWithIdentifier:identifierStr];
        if (parkLayer != nil) {
            [self.mapView.style removeLayer:parkLayer];
        }
    }
}

- (void)animateAnnotationView{
    MGLPointAnnotation *annot = [[MGLPointAnnotation alloc] init];
    annot.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:annot];
    
    // Move the annotation to a point that is offscreen.
    CGPoint point = CGPointMake(self.view.frame.origin.x - 200, CGRectGetMidY(self.view.frame));
    
    CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:10 animations:^{
            annot.coordinate = coord;
        }];
    });
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
