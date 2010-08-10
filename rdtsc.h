/*
 *  rdtsc.h
 *  Library
 *
 *  Created by Chris Miller on 8/10/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

#include <stdint.h>

#ifdef __WIN32
    uint rdtsc_lo, rdtsc_hi;
    uint64_t r;
    #ifdef __cplusplus
        extern "C" {
    #endif
            inline
            uint64_t rdtsc() {
                __asm {
                    cpuid
                    rdtsc
                    mov rdtsc_lo,eax
                    mov rdtsc_hi,edx
                }
                r = 0L;
                r = ((r | (uint64_t)rdtsc_hi) << 32) | (uint64_t)rdtsc_lo;
                return r;
            }
    #ifdef __cplusplus
        }
    #endif
#else
    #if defined(__X86_64) || defined(__X86)
        uint64_t rdtsc();
    #else
        #error "Sorry, I only have an IA32/IA64 version of RDTSC"
    #endif
#endif
