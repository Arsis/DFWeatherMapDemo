//
//  DFWeatherOverlay.m
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "DFWeatherOverlay.h"

@implementation DFWeatherOverlay

-(id)initWithULCoord:(CLLocationCoordinate2D)ULCoord CCoord:(CLLocationCoordinate2D)CCoord BRCoord:(CLLocationCoordinate2D)BRCoord {
    if (self = [super init]) {
        _upperLeftCoordinate = ULCoord;
        _centerCoordinate = CCoord;
        _bottomRightCoordinate = BRCoord;
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate {
    return _centerCoordinate;
}

- (MKMapRect)boundingMapRect {
    MKMapPoint upperLeft   = MKMapPointForCoordinate(_upperLeftCoordinate);
    MKMapPoint bottomRight  = MKMapPointForCoordinate(_bottomRightCoordinate);
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, fabs(upperLeft.x - bottomRight.x), fabs(upperLeft.y - bottomRight.y));
    return bounds;
}

@end
