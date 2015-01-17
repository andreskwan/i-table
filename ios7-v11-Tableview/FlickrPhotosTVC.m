//
//  KWTableViewController.m
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 1/13/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t otherQ = dispatch_queue_create("Q", NULL);
    dispatch_async(otherQ, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    });
}

/**
 Function description: lazy instantiation for photos property
 reload table view everytime the photo data is set! (model change)
 
 @param NSArray of NSDictionary that holds metadata for photos
 @returns void
 */

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    // we need info from our model
    NSDictionary *photo = self.photos[indexPath.row];
    
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([cell.textLabel.text  length] <= 1) {
        cell.textLabel.text = @"Img without title";
        NSRange range = [cell.detailTextLabel.text rangeOfString:@""];
        NSLog(@"%@, %@",cell.detailTextLabel.text, NSStringFromRange(range));

    }

    if ([cell.detailTextLabel.text  length] <= 1) {
        cell.detailTextLabel.text = @"Img without subtitle";
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareImageViewController:(ImageViewController *)ivc
                    toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo
                                       format:FlickrPhotoFormatOriginal];
    ivc.title = [photo valueForKey:FLICKR_PHOTO_TITLE];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                [self prepareImageViewController:segue.destinationViewController
                                  toDisplayPhoto:self.photos[indexPath.row]];
            }
        }
    }
}


@end
