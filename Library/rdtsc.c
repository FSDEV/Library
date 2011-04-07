/*
 *  rdtsc.c
 *  Library
 *
 *  Created by Chris Miller on 8/10/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

#include "rdtsc.h"

#if !defined(__WIN32)
    #if defined(__X86_64) || defined(__X86) || defined(_LP64)
        uint64_t r;
        uint64_t rdtsc() {
            asm("cpuid\n\t"
                "rdtsc"
                : "=A" (r)
                : /* no inputs */ );
            return r;
        }
    #else
        #warning "Sorry, I only have an IA32/IA64 version of RDTSC"
    #endif
#endif
