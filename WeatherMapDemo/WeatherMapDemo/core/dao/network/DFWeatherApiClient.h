//
//  DFWeatherApiClient.h
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

typedef void (^WeatherDataCompletionHandler)(UIImage *image, NSError *error);

#import "AFHTTPRequestOperationManager.h"
@import CoreLocation;
@interface DFWeatherApiClient : AFHTTPRequestOperationManager

+(instancetype)sharedApiClient;

-(void)getWeatherDataForRegionWithMinLatitude:(CLLocationDegrees)minLat minLongitude:(CLLocationDegrees)minLng maxLatitude:(CLLocationDegrees)maxLat maxLongitude:(CLLocationDegrees)maxLng width:(CGFloat)width height:(CGFloat)height completionHandler:(WeatherDataCompletionHandler)handler;

-(NSString *)urlStringForWeatherDataForRegionWithMinLatitude:(CLLocationDegrees)minLat minLongitude:(CLLocationDegrees)minLng maxLatitude:(CLLocationDegrees)maxLat maxLongitude:(CLLocationDegrees)maxLng width:(CGFloat)width height:(CGFloat)height;

@end
