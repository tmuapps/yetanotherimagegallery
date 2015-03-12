//
//  TMUImageDC.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMUImageWithDescriptor;

@interface TMUImageDC : NSObject


+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;

- (void) getImageMetaDataArrayWithCompletionBlock: (void (^) (BOOL success)) imageListChangedHandler;

- (NSUInteger) countOfImages;
- (TMUImageWithDescriptor*) imageAtIndex:(NSUInteger) index;

@end
