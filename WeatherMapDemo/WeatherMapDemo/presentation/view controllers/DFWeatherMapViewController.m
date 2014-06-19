//
//  DFWeatherMapViewController.m
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "DFWeatherMapViewController.h"
#import "DFWeatherApiClient.h"
#import "DFWeatherOverlay.h"
#import "DFImageOverlayRenderer.h"
@interface DFWeatherMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) DFWeatherApiClient *apiClient;
@end

@implementation DFWeatherMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.apiClient = [DFWeatherApiClient sharedApiClient];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateOverlay {
    CLLocationCoordinate2D tlCoord = [_mapView convertPoint:_mapView.frame.origin
                                       toCoordinateFromView:self.view];
    CLLocationCoordinate2D brCoord = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width, _mapView.frame.size.height)
                                       toCoordinateFromView:self.mapView];
    CLLocationCoordinate2D centerCoord = [_mapView convertPoint:_mapView.center
                                           toCoordinateFromView:self.view];
    
    __block DFWeatherOverlay *overlay = [[DFWeatherOverlay alloc]initWithULCoord:tlCoord
                                                                          CCoord:centerCoord
                                                                         BRCoord:brCoord];
    
    [self.apiClient getWeatherDataForRegionWithMinLatitude:brCoord.latitude
                                              minLongitude:brCoord.longitude
                                               maxLatitude:tlCoord.latitude
                                              maxLongitude:tlCoord.longitude
                                                     width:CGRectGetWidth(self.mapView.bounds)
                                                    height:CGRectGetHeight(self.mapView.bounds)
                                         completionHandler:^(UIImage *image, NSError *error) {
                                             overlay.image = image;
                                             [self.mapView removeOverlays:self.mapView.overlays];
                                             [self.mapView addOverlay:overlay];
                                         }];
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    DFImageOverlayRenderer *view = (DFImageOverlayRenderer *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mapView"];
    if (!view) {
        view = [[DFImageOverlayRenderer alloc] initWithOverlay:overlay];
        view.image = ((DFWeatherOverlay *)overlay).image;
    }
    return view;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateOverlay];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
