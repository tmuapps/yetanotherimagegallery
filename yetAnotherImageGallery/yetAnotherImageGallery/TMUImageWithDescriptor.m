//
//  TMUImageWithDescriptor.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import "TMUImageWithDescriptor.h"

@implementation TMUImageWithDescriptor


// Get the image asyncronously from the web, if necessary
- (void) getImageWithCompletionBlock: (void (^) (UIImage*)) imageHandler {
    
    if (self.image != nil) {
        // Call the completion handler with the returned data on the main thread.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            imageHandler(self.image);
        }];
    } else {
        //getTheImage from the web, link in imageDescriptor.link
        
        // Call the completion handler with the returned data on the main thread.
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            imageHandler(self.image);
        }];
    }
}


@end
