//
//  Photographer+Create.h
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 2/16/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *) name
                inManagedObjectCOntext:(NSManagedObjectContext *)context;
@end
