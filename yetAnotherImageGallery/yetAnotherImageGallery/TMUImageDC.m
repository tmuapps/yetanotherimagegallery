//
//  TMUImageDC.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import "TMUImageDC.h"
#import "TMUImageDescriptor.h"
#import "TMUImageWithDescriptor.h"

#define kFlickrURLBase @"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"

#define kImageItemsKey @"items"
#define kImageTitleKey @"title"
#define kImageLinkKey @"link"
#define kImageDescriptionKey @"description"
#define kImageDateTakenKey @"date_taken"
#define kImageDatePublishedKey @"published"
#define kImageAuthorKey @"author"
#define kImageAuthorIdKey @"author_id"
#define kImageTagsKey @"tags"

@interface TMUImageDC () {
@private NSMutableArray* imageArray;
@private NSDateFormatter* rfc3339DateFormatter;
}
@end

@implementation TMUImageDC

//instance initialization
- (id) init {
    if (self = [super init]) {
        
        rfc3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale* enUSPosixlocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [rfc3339DateFormatter setLocale:enUSPosixlocale];
        [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        
    }
    return self;
}



- (NSUInteger) countOfImages {
    if (imageArray != nil) {
        return imageArray.count;
    } else {
        return 0;
    }
}

- (TMUImageWithDescriptor*) imageAtIndex:(NSUInteger) index {
    if (imageArray != nil && imageArray.count >= index+1) {
        return [imageArray objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void) getImageMetaDataArrayWithCompletionBlock: (void (^) (BOOL success)) imageListChangedHandler {
    
    [TMUImageDC downloadDataFromURL:[NSURL URLWithString:kFlickrURLBase] withCompletionHandler: ^ (NSData * data) {
            //Check that we have data
            if (data != nil) {
                
                //Parse the data into a JSONObject (NSDictionary)
                NSError* error = nil;
                NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                //If the data parses correctly, build the array of images for access later
                if (error != nil) {
                    //This is most likely because Flickr returns JSON with single quotes escaped (incorrectly)
                    //So check and remove any escaped single quotes and try to parse again!
                    NSString* jsonString = [[NSString stringWithUTF8String:[data bytes]] stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
                    NSData* revisedData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    //Reset error, the retry the parse.
                    error = nil;
                    parsedData = [NSJSONSerialization JSONObjectWithData:revisedData options:kNilOptions error:&error];
                }
                
                
                if (error == nil) {
                    //Construct new array of TMUimage objects, one for each "item"
                    NSArray* imageItems = [parsedData objectForKey:kImageItemsKey];
                    imageArray =  [NSMutableArray arrayWithCapacity:imageItems.count];
                    for (NSDictionary* imageItem in imageItems) {
                        TMUImageDescriptor* imageDescriptor = [[TMUImageDescriptor alloc] init];

                        imageDescriptor.title = [imageItem objectForKey:kImageTitleKey];
                        imageDescriptor.link = [imageItem objectForKey:kImageLinkKey];
                        imageDescriptor.desc = [imageItem objectForKey:kImageDescriptionKey];
                        if ([imageItem objectForKey:kImageDateTakenKey] != nil) {
                            imageDescriptor.dateTaken = [rfc3339DateFormatter dateFromString:[imageItem objectForKey:kImageDateTakenKey]];
                            
                        }
                        if ([imageItem objectForKey:kImageDatePublishedKey] != nil) {
                            imageDescriptor.datePublished = [rfc3339DateFormatter dateFromString:[imageItem objectForKey:kImageDatePublishedKey]];
                            
                        }
                        imageDescriptor.author = [imageItem objectForKey:kImageAuthorKey];
                        imageDescriptor.authorId = [imageItem objectForKey:kImageAuthorIdKey];
                        imageDescriptor.tags = [imageItem objectForKey:kImageTagsKey];
                        
                        TMUImageWithDescriptor* imageWithDescriptor = [[TMUImageWithDescriptor alloc] init];
                        imageWithDescriptor.imageDescriptor = imageDescriptor;
                        [imageArray addObject:imageWithDescriptor];
                        
                    }
                    // Call the completion handler with the returned data on the main thread.
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        imageListChangedHandler(YES);
                    }];
                } else {
                    NSLog(@"%@: %@", @"JSON string Parse failure!", error);
                    // Call the completion handler reporting the failure
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        imageListChangedHandler(NO);
                    }];
                }
            } else {
                NSLog(@"%@", @"No images to display - connection problem?");
                // Call the completion handler reporting the failure
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    imageListChangedHandler(NO);
                }];
            }
    }];
}

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler{
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

@end
