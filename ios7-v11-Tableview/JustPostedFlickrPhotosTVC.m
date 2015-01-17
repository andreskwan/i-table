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

- (void)fetchPhotos
{
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
#warning Block Main Thread 
    //should be done in the refresher for example
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                        options:0
                                                                          error:&error];

    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    self.photos = photos;
}

@end
