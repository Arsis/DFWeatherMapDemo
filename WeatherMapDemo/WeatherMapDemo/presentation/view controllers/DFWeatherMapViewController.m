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
#import "DFImgeOverlayView.h"
#import "DFTileCache.h"

static NSString *const kOverlayId = @"com.df.kOverlayId";

@interface DFWeatherMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) DFWeatherApiClient *apiClient;
@property (nonatomic, strong) DFTileCache *cache;
@property (nonatomic) BOOL isMapLoaded;
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

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.apiClient = [DFWeatherApiClient sharedApiClient];
    self.cache = [[DFTileCache alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.cache = nil;
}

#pragma mark - Custom navigation item

- (void)setupActivityIndicator
{
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityIndicatorView];
    [activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = barButtonItem;
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
    NSString *urlString = [self.apiClient urlStringForWeatherDataForRegionWithMinLatitude:tlCoord.latitude
                                                                             minLongitude:tlCoord.longitude
                                                                              maxLatitude:brCoord.latitude
                                                                             maxLongitude:brCoord.longitude
                                                                                    width:CGRectGetWidth(self.mapView.bounds)
                                                                                   height:CGRectGetHeight(self.mapView.bounds)];
    [self.cache asyncImageForURLString:urlString
                      completionHandler:^(UIImage *cachedImage) {
                                    if (cachedImage) {
                                                    overlay.image = cachedImage;
                                                    [self addOverlay:overlay];
                                                }
                                                else {
                                                    [self setupActivityIndicator];
                                                    [self.apiClient getWeatherDataForRegionWithMinLatitude:tlCoord.latitude
                                                                                              minLongitude:tlCoord.longitude
                                                                                               maxLatitude:brCoord.latitude
                                                                                              maxLongitude:brCoord.longitude
                                                                                                     width:CGRectGetWidth(self.mapView.bounds)
                                                                                                    height:CGRectGetHeight(self.mapView.bounds)
                                                                                         completionHandler:^(UIImage *image, NSError *error) {
                                                                                             self.navigationItem.rightBarButtonItem = nil;
                                                                                             overlay.image = image;
                                                                                             [self.cache cacheImage:image
                                                                                                       forURLString:urlString];
                                                                                             [self addOverlay:overlay];
                                                                                         }];
                                                }
                                            }];
}

-(void)addOverlay:(id <MKOverlay>)overlay {
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView addOverlay:overlay];
}

#pragma mark - MKMapViewDelegate methods

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay { //ios7
    DFImageOverlayRenderer *view = (DFImageOverlayRenderer *)[mapView dequeueReusableAnnotationViewWithIdentifier:kOverlayId];
    if (!view) {
        view = [[DFImageOverlayRenderer alloc] initWithOverlay:overlay];
    }
    view.image = ((DFWeatherOverlay *)overlay).image;
    return view;
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay { //ios < 7
    DFImgeOverlayView *overlayView = (DFImgeOverlayView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kOverlayId];
    if (!overlayView) {
        overlayView = [[DFImgeOverlayView alloc] initWithOverlay:overlay];
    }
    overlayView.image = ((DFWeatherOverlay *)overlay).image;
    return overlayView;
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1 && !self.isMapLoaded) {
        self.isMapLoaded = YES;
        [self updateOverlay];
    }
}

-(void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 && !self.isMapLoaded) {
        self.isMapLoaded = YES;
        [self updateOverlay];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if (self.isMapLoaded) {
        [self updateOverlay];
    }
    
}


@end
