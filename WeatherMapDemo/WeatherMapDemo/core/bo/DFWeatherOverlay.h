//
//  DFWeatherOverlay.h
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@interface DFWeatherOverlay : NSObject <MKOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D upperLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D bottomRightCoordinate;
@property (nonatomic, strong) UIImage *image;
- (id)initWithULCoord:(CLLocationCoordinate2D)ULCoord CCoord:(CLLocationCoordinate2D)CCoord BRCoord:(CLLocationCoordinate2D)BRCoord;
- (CLLocationCoordinate2D)coordinate;
- (MKMapRect)boundingMapRect;
@end
