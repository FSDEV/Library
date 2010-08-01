//
//  testCompat.m
//  Library
//
//  Created by Chris Miller on 7/31/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#ifdef __OBJC__
    #import <Cocoa/Cocoa.h>
#endif

#import "../../src/FSZip.h"

// purpose is to read the stuff from syszip.zip
// syszip.zip/test0.txt:
// FooEOF
// syszip.zip/test1.txt:
// BarEOF
int main(int argc, char *args[]) {
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"Testing compatibility with POSIX zip");
    
    if(argc<2) {
        NSLog(@"Too few calling arguments!");
        return -1;
    }
    
    FSZip * syszip = [[FSZip alloc] initWithFileName:[NSString stringWithUTF8String:args[1]]];
    if(!syszip) {
        NSLog(@"Cannot open zip file %s", args[1]);
        return -1;
    }
    
    if([[syszip containedFiles] indexOfObject:@"test0.txt"] == NSNotFound
       ||
       [[syszip containedFiles] indexOfObject:@"test1.txt"] == NSNotFound) {
        NSLog(@"Missing a file!");
        return -1;
    }
    
    NSString * str;
    
    str = [[NSString alloc] initWithData:[syszip dataForFile:@"test0.txt"]
                                encoding:NSUTF8StringEncoding];

    if(![str isEqual:@"Foo"]) {
        NSLog(@"Issue decoding stored test0.txt");
        return -1;
    }
    
    [str release];
    
    str = [[NSString alloc] initWithData:[syszip dataForFile:@"test1.txt"]
                                encoding:NSUTF8StringEncoding];
    
    if(![str isEqual:@"Bar"]) {
        NSLog(@"Issue decoding stored test1.txt");
        return -1;
    }
    
    [str release];
    [syszip release];
    
    [pool0 release];
    return 0;
}
