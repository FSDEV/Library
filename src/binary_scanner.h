//
//  binary_scanner.h
//  Library
//
//  Created by Elder Christopher Miller on 4/7/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

/* Prototype code. Me trying to implement something similar to NSScanner
 * in C, only with support for reading binary data. NSScanner is not
 * available because it isn't C, and because it works with NSString, which
 * promotes to UTF-8 and/or UTF-16 whenever it darn well wants.
 */

#include <stdlib>
#include <Block.h>

#ifdef __cplusplus
extern "C" { // prevents C structs from being promoted to C++ objects
#endif

    typdef struct {
        void* data;
        size_t len;
    } chunk;
    
    typedef chunk* (^chunkRetriever)();
    
    typedef struct {
        chunk* cur_chunk;
        size_t cursor;
        chunkRetriever getter;
    } binary_scanner;
    
    /* Make a new scanner. Will immediately grab a fresh chunk from the
     * supplied chunk retriever.
     */
    binary_scanner* mkscanner(chunkRetriever);

#ifdef __cplusplus
}
#endif
