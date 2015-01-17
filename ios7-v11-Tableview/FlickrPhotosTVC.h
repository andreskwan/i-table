//
//  KWTableViewController.h
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 1/13/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 this is a generic class, not set to a particular group of photos
 we are going to subclass it to be specific to just posted photos
 */
@interface FlickrPhotosTVC : UITableViewController
//of Flickr photo NSDictionary, just photo metadata about the content
@property (nonatomic, strong) NSArray * photos;

@end
