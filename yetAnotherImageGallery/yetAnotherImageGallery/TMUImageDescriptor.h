//
//  TMUImageDescriptor.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 11/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMUImageDescriptor : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSURL* link;
@property (nonatomic, retain) NSString* desc;
@property (nonatomic, retain) NSDate* dateTaken;
@property (nonatomic, retain) NSDate* datePublished;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSString* authorId;
@property (nonatomic, retain) NSArray* tags;


@end
