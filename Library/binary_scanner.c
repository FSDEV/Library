//
//  binary_scanner.c
//  Library
//
//  Created by Christopher Miller on 4/7/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#include "binary_scanner.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    binary_scanner* mkscanner(chunkRetriever getter) {
        binary_scanner* scanner = malloc(sizeof(binary_scanner));
        scanner->getter = getter;
        scanner->chunks = chunk_vector_create_heap(5);
        return scanner;
    }
    
    void freescanner(binary_scanner* scanner) {
        for(size_t i=0; i<scanner->chunks->size; ++i)
            free(scanner->chunks[i].data);
        chunk_vector_free_heap(scanner->chunks);
        free(scanner);
    }
    
#ifdef __cplusplus
}
#endif
