//
//  Photo+PhotoCategory.m
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 2/4/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "Photo+PhotoCategory.h"
#import "Photographer+Create.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

/**
 Function description: takes a flickr dictionary, adds a photo(an obj) to the DB
 
 @param photoDictionary
 @param context hook to the database
 @returns pointer to the photo(NSManagedObject) in the DB
 */

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo * photo = nil;
    
    //ID value for key could be used here (dots in the data)
    NSString * unique = photoDictionary[FLICKR_PHOTO_ID];
    //is this photo already in the DB?
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    
    //what photo I'm looking for? make it unique!
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
    
    NSError * error;
    //execute the fetch
    NSArray * matches = [context executeFetchRequest:request
                                               error:&error];
    
    if (!matches || error || ([matches count] > 1)) {//if error
        //handle error
    }else if ([matches firstObject]){//if photo exists in the DB
        //return the found obj
        photo = [matches firstObject];
    }else{                           //if don't exists, create photo in DB
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                              inManagedObjectContext:context];
        photo.unique = unique;
        photo.title  = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:photoDictionary
                                              format:FlickrPhotoFormatLarge]absoluteString];
        //create a photo also force to create a photographer.
        NSString * photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        // create other db objs like photographer
        photo.whoTook = [Photographer photographerWithName:photographerName
                                    inManagedObjectCOntext:context];
        
    }


    return photo;
}

/**
 Function description: brings many photo's data from Flikcr
 
 @param photos array of NSDictionary from Flicker
 @param photos array of NSDictionary from Flicker
 @returns ;;
 */

+ (void) loadPhotosFromFlickrArray:(NSArray *)photos //of Flickr NSdictionary
          intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
}


- (UIImage *)image
{
    NSURL * imageURL = [NSURL URLWithString:self.imageURL];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

- (BOOL)isOld
{
    //seconds in a day
    return [self.updateDate timeIntervalSinceNow] > -24*60*60;
}

//this method goes here? 
- (void)prepareForDeletion
{
    //[aDocument.managedObjectContext deleteObject:photo];
}
@end
