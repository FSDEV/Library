//
//  testWrite.m
//  Library
//
//  Created by Chris Miller on 7/31/10.
//  Copyright 2010 FSDEV. All rights reserved.
//


#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#endif

#import "../../src/FSZip.h"

// purpose is to attempt to write an archive file
// args[1] zipfile
// args[2..$] files to zip
int main(int argc, char *args[]) {
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];

    NSLog(@"Testing ZIP file creation and editing!");
    
    if(argc<3) {
        NSLog(@"Too few arguments!");
        return -1;
    }
    
    FSZip * zipfile = [[FSZip alloc] initWithFileName:[NSString stringWithUTF8String:args[1]]];
    if(!zipfile) {
        NSLog(@"Unable to create ZIP archive %s", args[1]);
        return -1;
    }
    
    BOOL result;
    // write all files to except for the last one, which
    for(int i=2; i < argc-1; ++i) {
        result = [zipfile writeFile:[NSString stringWithUTF8String:args[i]]
                             toFile:[NSString stringWithFormat:@"file%d",i]];
        if(result==NO) {
            NSLog(@"Failed to write %s using FSZip writeFile:toFile:", args[i]);
            [zipfile release];
            return -1;
        }
    }
    
    // should load into memory as NSData
    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithUTF8String:args[argc-1]]];
    if(data==nil) {
        NSLog(@"Failed to load file %s into memory", args[argc-1]);
        [zipfile release];
        return -1;
    }
    // and write as NSData
    result = [zipfile writeData:data
                         toFile:@"lastfile"];
    if(result==NO) {
        NSLog(@"Failed to write file %s", args[argc-1]);
        [zipfile release];
        return -1;
    }
    // attempt to set the comment for the last file
    result = [zipfile setComment:@"this is a comment!"
                         forFile:@"lastfile"];
    if(result==NO) {
        NSLog(@"Unable to set comment for lastfile");
        [zipfile release];
        return -1;
    }
    
    [pool0 release]; // best possible way to force an error
    [zipfile release]; // will write to disk
    
    return 0;
}
