//
//  CDDocumentContainer.m
//  ios7-v11-Tableview
//
//  Created by Andres Kwan on 1/31/15.
//  Copyright (c) 2015 Kwan Castle. All rights reserved.
//

#import "CDDocumentContainer.h"

@interface CDDocumentContainer()
@property (nonatomic, strong)UIManagedDocument * document;

@end
@implementation CDDocumentContainer

- (UIManagedDocument *)createDocument:(NSString *)documentName
{
    
    //no place for errors here!!!
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSURL * documentDirectory  = [[fileManger URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSURL * url = [documentDirectory URLByAppendingPathComponent:documentName];
    UIManagedDocument * document = [[UIManagedDocument alloc]initWithFileURL:url];
    return document;
    
}

- (void) openDocument:(UIManagedDocument *)document
{
    NSURL * docURL     = [document fileURL];
    NSString * docPath = [docURL path];
    //1 check if the UIMangedDocument exists
    
    BOOL fileExists = [[NSFileManager defaultManager]
                        fileExistsAtPath:docPath];
    
    //here I'm saying that if exist then open
    //but the example says open or create, is differen why not my approach? 
    if (!fileExists) {
        //fro
        [document saveToURL:docURL
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              //execute when create is done
              if (success) [self documentIsReady];
              if (!success) NSLog(@"couldn't create document at %@",docURL);
          }];
    }
    [document openWithCompletionHandler:^(BOOL success){
        //execute this block when doc open
        if (success) [self documentIsReady];
        if (!success) NSLog(@"couldn't open document at %@",docURL);
    }];
    
}


- (void)documentIsReady
{
    if (self.document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext * context = self.document.managedObjectContext;
    }
}

@end
