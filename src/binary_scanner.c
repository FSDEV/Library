//
//  binary_scanner.c
//  Library
//
//  Created by Elder Christopher Miller on 4/7/11.
//  Copyright 2011 FSDEV. All rights reserved.
//

#include "binary_scanner.h"

#ifdef __cplusplus
extern "C" {
#endif
    
    binary_scanner* mkscanner(chunkRetriever getter) {
        binary_scanner* scanner = malloc(sizeof(binary_scanner));
        scanner->getter = getter;
        return scanner;
    }
    
#ifdef __cplusplus
}
#endif
