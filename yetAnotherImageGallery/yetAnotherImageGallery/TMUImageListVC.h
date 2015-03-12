//
//  MasterViewController.h
//  yetAnotherImageGallery
//
//  Created by tim millington on 10/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TMUImageDC.h"

@class TMUImageDetailVC;

@interface TMUImageListVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TMUImageDetailVC *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) TMUImageDC* imageDC;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

