//
//  DFWeatherApiClient.h
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface DFWeatherApiClient : AFHTTPSessionManager

+(instancetype)sharedApiClient;

@end
