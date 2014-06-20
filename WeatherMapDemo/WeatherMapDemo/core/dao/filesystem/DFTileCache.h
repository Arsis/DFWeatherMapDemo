//
//  DFTileCache.h
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 20.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFTileCache : NSObject
-(void)cacheImage:(UIImage *)image forURLString:(NSString *)ulrString;
-(UIImage *)imageForURLString:(NSString *)urlString;
-(void)asyncImageForURLString:(NSString *)urlString completionHandler:(void (^)(UIImage *image))handler;
@end
