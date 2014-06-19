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
/*
http://api.wunderground.com/api/0fd62d9f5e0841e9/satellite/image.gif?maxlat=47.709&maxlon=-69.263&minlat=31.596&minlon=-97.388&width=640&height=480&key=sat_ir4_bottom>t=107&timelabel=1&timelabel.x=470&timelabel.y=41&proj=me
*/
@implementation DFWeatherApiClient


-(id)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFImageResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/png", nil];
//        [self.requestSerializer setValue:@"image/png, */*"
//                      forHTTPHeaderField:@"Content-Type"];
//        [self.requestSerializer setValue:@"image/png, */*"
//                      forHTTPHeaderField:@"Accept"];
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"satellite/image.png?maxlat=%f&maxlon=%f&minlat=%f&minlon=%f&width=%f&height=%f",minLat,minLng,maxLat,maxLng,width,height]
                         relativeToURL:self.baseURL];
    
    [self GET:[NSString stringWithFormat:@"satellite/image.png?maxlat=%f&maxlon=%f&minlat=%f&minlon=%f&width=%f&height=%f&key=sat_ir4&basemap=0&proj=me",minLat,minLng,maxLat,maxLng,width,height]
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          UIImage *image = (UIImage *)responseObject;
          handler(image,nil);
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          handler(nil,error);
      }];
}

@end
