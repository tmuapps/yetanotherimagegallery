//
//  DetailViewController.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 10/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import "TMUImageDetailVC.h"
#import "TMUImageWithDescriptor.h"
#import "TMUImageDescriptor.h"

@interface TMUImageDetailVC ()

@end

@implementation TMUImageDetailVC

#pragma mark - Managing the detail item

- (void)setImageWithDescriptor:(TMUImageWithDescriptor*) newImageWithDescriptor {
    if (_imageWithDescriptor != newImageWithDescriptor) {
        _imageWithDescriptor = newImageWithDescriptor;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.imageWithDescriptor) {
        [self.tagsView setText:self.imageWithDescriptor.imageDescriptor.tags];
        
        if (self.imageWithDescriptor.image) {
            
            [self.imageView setImage:self.imageWithDescriptor.image];
            
        } else {
            //Request asynchronous retrieval of image
            [self.imageWithDescriptor getImageWithCompletionBlock: ^(UIImage* image) {
                if (image != nil) {
                    //post update the image view
                    [self.imageView setImage:image];
                }
            }];
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openInBrowserAction:(id)sender {
    //Open the image in the system browser
    if (self.imageWithDescriptor.image) {
        [[UIApplication sharedApplication] openURL:self.imageWithDescriptor.imageDescriptor.media];
    }
}

- (IBAction)shareAction:(id)sender {
    //send the image by email
    if (self.imageWithDescriptor.image) {
        NSData* imageData = UIImagePNGRepresentation(self.imageWithDescriptor.image);
        NSString* emailBodyWithImage = [NSString stringWithFormat:
                                        @"<html>"
                                        @"<body>"
                                        @"<p>%@</p>"
                                        @"<p><b><img src='data:image/png;base64,%@'</b></p>"
                                        ,self.imageWithDescriptor.imageDescriptor.description
                                        ,[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]
                                        ];
        NSString* mailString = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@"
                                , [@"Check out this photo!" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                                ,   emailBodyWithImage
                                ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
    }
}

- (IBAction)saveAction:(id)sender {
    //Save the image to the system image gallery
    if (self.imageWithDescriptor.image) {
        if (self.imageWithDescriptor.image) {
            UIImageWriteToSavedPhotosAlbum(self.imageWithDescriptor.image, nil, nil, nil);
        }
    }
}
@end
