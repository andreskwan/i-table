 //
//  Photographer+Create.m
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 2/16/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *) name
                inManagedObjectCOntext:(NSManagedObjectContext *)context
{
    Photographer * photographer = nil;
    if ([name length]) {
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate   = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count]>1)) {
            //handle error
        }else if (![matches count]){
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                         inManagedObjectContext:context];
            photographer.name = name;
        }else{
            photographer = [matches lastObject];
        }
    }
    return photographer;
}

@end
