//
//  Photo+PhotoCategory.h
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 2/4/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "Photo.h"
#import <UIKit/UIKit.h>

@interface Photo (PhotoCategory)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context;


+ (void) loadPhotosFromFlickrArray:(NSArray *)photos //of Flickr NSdictionary
          intoManagedObjectContext:(NSManagedObjectContext *)context;

- (UIImage *)image;

@property (readonly) BOOL isOld;

@end
