//
//  DFTileCache.m
//  WeatherMapDemo
//
//  Created by Dmitry Fedorov on 20.06.14.
//  Copyright (c) 2014 Lab. All rights reserved.
//

#import "DFTileCache.h"
#import <NSDate-Utilities.h>

static NSUInteger const kCacheDuration = 30;

@implementation DFTileCache

-(void)cacheImage:(UIImage *)image forURLString:(NSString *)ulrString {
    /*так как я не нашел беслпатного тайл-провайдера который бы отдавал тайлы не целым куском как в данном 
     случае, а, например, сначала в зависимости от региона возвращался некий JSON(XML) тайл дескриптор, 
     содержащий ссылки на небольшие тайлы, заполняющие регион карты, данный мезанизм неэффективен, так как 
     вероятность, что пользователь выберет аналогичный регион с точностью до секунд крайне мала; он представлен
     больше для ознакомительных целей
    */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                       NSString *documentsDirectory = paths[0];
                       NSString *filePathString = [ulrString substringFromIndex:[ulrString rangeOfString:@"?"].location + 1];
                       documentsDirectory = [documentsDirectory stringByAppendingPathComponent:filePathString];
                       NSError *error;
                       [UIImagePNGRepresentation(image) writeToFile:documentsDirectory
                                                            options:NSDataWritingAtomic
                                                              error:&error];
                       if (error) {
                           NSLog(@"error while saving image at URL %@",ulrString);
                       }
                   });    
}

-(void)asyncImageForURLString:(NSString *)urlString completionHandler:(void (^)(UIImage *image))handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self imageForURLString:urlString];
        dispatch_sync(dispatch_get_main_queue(), ^{
            handler(image);
        });
    });
}

-(UIImage *)imageForURLString:(NSString *)urlString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    NSString *filePathString = [urlString substringFromIndex:[urlString rangeOfString:@"?"].location + 1];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:filePathString];
    NSData *data;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:documentsDirectory])
    {
        NSDictionary* fileAttribs = [fm attributesOfItemAtPath:documentsDirectory
                                                         error:nil];
        NSDate *fileModiciationDate = [[fileAttribs fileModificationDate] dateByAddingMinutes:kCacheDuration];
        if ([fileModiciationDate compare:[NSDate date]] == NSOrderedAscending) {
            NSError *error;
            [fm removeItemAtPath:documentsDirectory
                           error:&error];
        }
        else {
            data  = [[NSData alloc] initWithContentsOfFile:documentsDirectory];
            return [UIImage imageWithData:data];
        }
    }
    return nil;
    
}

@end
