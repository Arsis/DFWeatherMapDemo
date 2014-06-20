//
//  DFImgeOverlayView.m
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 20.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "DFImgeOverlayView.h"

@implementation DFImgeOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = _image.CGImage;
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

@end
