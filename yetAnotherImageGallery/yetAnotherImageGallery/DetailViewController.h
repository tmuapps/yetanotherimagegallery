//
//  DetailViewController.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 10/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

