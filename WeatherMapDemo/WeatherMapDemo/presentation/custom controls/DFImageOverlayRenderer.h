//
//  DFImageOverlayRenderer.h
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 19.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DFImageOverlayRenderer : MKOverlayRenderer
@property (nonatomic, strong) UIImage *image;
@end
