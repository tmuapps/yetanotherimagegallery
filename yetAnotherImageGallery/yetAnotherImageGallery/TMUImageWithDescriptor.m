//
//  TMUImageWithDescriptor.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import "TMUImageWithDescriptor.h"
#import "TMUImageDC.h"

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
        if (self.imageDescriptor.link != nil) {
            [TMUImageDC downloadDataFromURL:self.imageDescriptor.media withCompletionHandler:^(NSData* imageData){
                // Create the uiimage from the returned data
                self.image = [UIImage imageWithData:imageData];
                
                // Call the image handler with the returned data on the main thread.
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imageHandler(self.image);
                }];
                
            }];
        }
        //Note: if there is no link in the descriptor, we cannot download the image so the imageHandler is not called!
    }
}


@end
