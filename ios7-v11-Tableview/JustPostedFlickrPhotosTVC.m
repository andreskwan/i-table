//
//  JustPostedFlickrPhotosTVC.m
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 1/17/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

/**
 This class goal is to set the model
 */
@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

/**
 Function description: Go to flicker and get the photos and metadata related in 
 JSON format, we have to turn to NSDictionary
 
 @param none
 @returns void
 */
- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    //1 create the alternative queue
    dispatch_queue_t otherQ = dispatch_queue_create("Q", NULL);
    //2 send process to the otherQ //not to the main queue
    dispatch_async(otherQ, ^{
        //should be done in the refresher for example
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:&error];
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = photos;
            [self.refreshControl endRefreshing];
        });
    });
    
}

@end
