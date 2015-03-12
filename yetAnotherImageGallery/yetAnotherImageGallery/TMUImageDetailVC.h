//
//  DetailViewController.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 10/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMUImageWithDescriptor;

@interface TMUImageDetailVC : UIViewController

@property (strong, nonatomic) TMUImageWithDescriptor* imageWithDescriptor;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tagsView;

- (IBAction)openInBrowserAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end

