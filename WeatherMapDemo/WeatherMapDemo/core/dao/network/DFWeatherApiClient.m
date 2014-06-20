//
//  DFWeatherApiClient.m
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "DFWeatherApiClient.h"

static NSString *const kWeatherApiKey = @"0fd62d9f5e0841e9";
static NSString *const kBaseURL = @"http://api.wunderground.com/api/";

@implementation DFWeatherApiClient


-(id)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFImageResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/png", nil];
    }
    return self;
}


+(instancetype)sharedApiClient {
    static DFWeatherApiClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kBaseURL, kWeatherApiKey];
        _client = [[DFWeatherApiClient alloc]initWithBaseURL:[NSURL URLWithString:urlString]];
    });
    return _client;
}

-(void)getWeatherDataForRegionWithMinLatitude:(CLLocationDegrees)minLat minLongitude:(CLLocationDegrees)minLng maxLatitude:(CLLocationDegrees)maxLat maxLongitude:(CLLocationDegrees)maxLng width:(CGFloat)width height:(CGFloat)height completionHandler:(WeatherDataCompletionHandler)handler {
    
    NSString *urlString = [self urlStringForWeatherDataForRegionWithMinLatitude:minLat
                                                                   minLongitude:minLng
                                                                    maxLatitude:maxLat
                                                                   maxLongitude:maxLng
                                                                          width:width
                                                                         height:height];
    
    [self GET:urlString
   parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          UIImage *image = (UIImage *)responseObject;
          handler(image,nil);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          handler(nil,error);
      }];
}

-(NSString *)urlStringForWeatherDataForRegionWithMinLatitude:(CLLocationDegrees)minLat minLongitude:(CLLocationDegrees)minLng maxLatitude:(CLLocationDegrees)maxLat maxLongitude:(CLLocationDegrees)maxLng width:(CGFloat)width height:(CGFloat)height {
    return [NSString stringWithFormat:@"satellite/image.png?maxlat=%f&maxlon=%f&minlat=%f&minlon=%f&width=%f&height=%f&key=sat_vis&basemap=0&proj=me&borders=1",maxLat,maxLng,minLat,minLng,width,height];
}

@end
