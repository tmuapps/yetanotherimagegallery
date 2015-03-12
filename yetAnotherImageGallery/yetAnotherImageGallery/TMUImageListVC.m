//
//  MasterViewController.m
//  yetAnotherImageGallery
//
//  Created by tim millington on 10/03/2015.
//  Copyright (c) 2015 tmuApps. All rights reserved.
//

#import "TMUImageListVC.h"
#import "TMUImageDetailVC.h"
#import "TMUImageDescriptor.h"
#import "TMUImageWithDescriptor.h"
#import "TMUImageListTableViewCell.h"


@interface TMUImageListVC () {
@private NSDateFormatter* dateFormatter;
}
@end


@implementation TMUImageListVC

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Uncomment the next line to add theediut button
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //Add a sort button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(organizeList:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (TMUImageDetailVC *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //Create a data controller
    self.imageDC = [[TMUImageDC alloc] init];
    
    //Set up the date formatter
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    //Initiate the request for image data to populate the list.
    
    [self.imageDC getImageMetaDataArrayWithCompletionBlock: ^ (BOOL success) {
        if (success) {
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TMUImageDetailVC *controller = (TMUImageDetailVC *)[[segue destinationViewController] topViewController];
        [controller setImageWithDescriptor:[[self imageDC] imageAtIndex:indexPath.row]];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.imageDC countOfImages];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMUImageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageListCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(TMUImageListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TMUImageWithDescriptor* imageWithDescriptor = [self.imageDC imageAtIndex:indexPath.row];
    TMUImageDescriptor* imageDescriptor = imageWithDescriptor.imageDescriptor;
    //Title
     [cell.imageTitle setText: ( [imageDescriptor title] != nil )
                               ? [imageDescriptor title]
                               : NSLocalizedString(@"Unknown title",nil)
     ];

    //Author
    [cell.imageAuthor setText: ( [imageDescriptor author] != nil )
                            ? [imageDescriptor author]
                            : NSLocalizedString(@"Unknown Author",nil)
     ];

    //Date published
    [cell.dateImagePublished setText: ( [imageDescriptor datePublished] != nil )
                             ? [ dateFormatter stringFromDate:[imageDescriptor datePublished]]
                             : NSLocalizedString(@"Unknown",nil)
     ];

    //Date captured (taken)
    [cell.dateImageCaptured setText: ( [imageDescriptor dateTaken] != nil )
                             ? [ dateFormatter stringFromDate:[imageDescriptor dateTaken]]
                             : NSLocalizedString(@"Unknown",nil)
     ];

    //Image
    if ([imageWithDescriptor image]  != nil) {
        [cell.image setImage:[imageWithDescriptor image]];
    } else {
        //Set the image to nil, in case this is a reused cell with an old image
        [cell.image setImage:nil];
        
        //Request asynchronous retrieval of correct image
        [imageWithDescriptor getImageWithCompletionBlock: ^(UIImage* image) {
            if (image != nil) {
                NSArray* visibleImageIndexes = [self.tableView indexPathsForVisibleRows];
                if (   indexPath.row >= ((NSIndexPath*)visibleImageIndexes[0]).row
                    && indexPath.row <= ((NSIndexPath*)visibleImageIndexes[visibleImageIndexes.count-1]).row
                    ) {
                    //post reload the row
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }];
    }
}

-(void) organizeList:(id) action {
    //TO DO
}

@end
