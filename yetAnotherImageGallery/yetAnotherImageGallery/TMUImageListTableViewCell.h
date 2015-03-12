//
//  TMUImageListItemTableViewCell.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 12/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMUImageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageAuthor;
@property (weak, nonatomic) IBOutlet UILabel *dateImagePublished;
@property (weak, nonatomic) IBOutlet UILabel *dateImageCaptured;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
