//
//  TMUImageWithDescriptor.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TMUImageDescriptor.h"

@interface TMUImageWithDescriptor : NSObject

@property (nonatomic, retain) TMUImageDescriptor* imageDescriptor;
@property (nonatomic, retain, readonly) UIImage* image;

- (void) getImageWithCompletionBlock: (void (^) (UIImage*)) imageHandler;


@end
