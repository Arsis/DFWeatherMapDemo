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
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"application/json, */*"
                      forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setValue:@"application/json, */*"
                      forHTTPHeaderField:@"Accept"];
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

@end
