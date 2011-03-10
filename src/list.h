//! Created by Chris Miller on 10 March 2011.
//! Copyright 2011 FSDEV. All rights reserved.

#pragma once

#ifndef __LIST_H__
#define __LIST_H__

#ifdef __cplusplus
#define LIST_CPLUSPLUS_ESC_BEGIN extern "C" {
#define LIST_CPLUSPLUS_ESC_END }
#else
#define LIST_CPLUSPLUS_ESC_BEGIN
#define LIST_CPLUSPLUS_ESC_END
#endif

#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#define LIST_PROTOTYPE(name, type)                                            \
LIST_CPLUSPLUS_ESC_BEGIN                                                      \
typedef struct __##name##_list __##name##_list;                               \
struct __##name##_list {                                                      \
    type * data;                                                              \
    __##name##_list* next;                                                    \
    __##name##_list* prev;                                                    \
};                                                                            \
typedef struct __##name##_list name##_list;                                   \
static inline                                                                 \
name##_list* name##_list_create() {                                           \
    name##_list * list;                                                       \
    list->data = NULL;                                                        \
    list->next = NULL;                                                        \
    list->prev = NULL;                                                        \
    return list;                                                              \
}                                                                             \
static inline                                                                 \
void name##_list_free_all(name##_list * l) {                                  \
    name##_list * cursor = l;                                                 \
    while(cursor->next != NULL) {                                             \
        free(cursor->data);                                                   \
        cursor = cursor->next;                                                \
        free(cursor->prev);                                                   \
    }                                                                         \
    free(cursor->data);                                                       \
    free(cursor);                                                             \
}                                                                             \
static inline /* inserts a new element after the given element */             \
void name##_list_insert(name##_list * at,                                     \
                        type elem) {                                          \
    name##_list * n_elem = name##_list_create();                              \
    n_elem->data = elem;                                                      \
    n_elem->next = at->next;                                                  \
    n_elem->prev = at;                                                        \
    at->next->prev = n_elem;                                                  \
    at->next = n_elem;                                                        \
}
    
    

