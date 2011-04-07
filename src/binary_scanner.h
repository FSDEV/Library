//
//  binary_scanner.h
//  Library
//
//  Created by Elder Christopher Miller on 4/7/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

/* Prototype code. I'm trying to implement something similar to NSScanner
 * in C, only with support for reading binary data. NSScanner is not
 * available because it isn't C, and because it works with NSString, which
 * promotes to UTF-8 and/or UTF-16 whenever it darn well wants. */

#include <stdlib.h>
#include <Block.h>
#include "vector.h"

#ifdef __cplusplus
extern "C" { // prevents C structs from being promoted to C++ objects
#endif
    
    typedef unsigned short ushort;

    typedef struct {
        ushort* data;
        size_t len;
    } chunk;
    
    /* Return a single chunk. The chunk's data can be however long
     * you want, and it does not need to be consistent in size. */
    typedef chunk* (^chunkRetriever)();
    
    VECTOR_PROTOTYPE(chunk, chunk);
    
    typedef struct {
        chunk* cur_chunk;
        size_t cursor;
        chunk_vector* chunks;
        chunkRetriever getter;
    } binary_scanner;
    
    /* Make a new scanner. Will immediately grab a fresh chunk from the
     * supplied chunk retriever. */
    binary_scanner* mkscanner(chunkRetriever);
    
    /* Get rid of a scanner. It has some pointers to data in it, so
     * using the library function is kind of useful. */
    void freescanner(binary_scanner*);
    

#ifdef __cplusplus
}
#endif
