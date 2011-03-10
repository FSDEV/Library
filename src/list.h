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

/* GENERIC/TEMPLATE LIST IMPLEMENTATION - IN C!
 * List variant: doubly-linked non-circular
 * Guiding principle: be as light and fast as possible without actually using
 * assembler. As a result there is little if no sanity checking in this code.
 * Usage: (better examples will be in the unit tests... when I write those).
 *   #include "list.h"
 *   #LIST_PROTOTYPE(intlist, int);
 *   intlist_list * l = intlist_list_create();
 *   l->data = 0; // [0]
 *   intlist_list_insert(l, 1); // [0, 1]
 *   intlist_list_free_all(l); // NULL
 *   // and so on and so forth
 * Generally speaking, if you're planning on using this, you already know how
 * to make something like this, and you're just grabbing (and/or modifying) my
 * code to prevent yourself from having to bother doing it yourself.
 */

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
    l = NULL;                                                                 \
}                                                                             \
static inline /* inserts a new element after the given element */             \
void name##_list_insert(name##_list * at,                                     \
                        type elem) {                                          \
    name##_list * n_elem = name##_list_create();                              \
    n_elem->data = elem;                                                      \
    n_elem->next = at->next;                                                  \
    n_elem->prev = at;                                                        \
    if(at->next != NULL)                                                      \
        at->next->prev = n_elem;                                              \
    at->next = n_elem;                                                        \
} /* cut elements from the list beginning at start and ending at end */       \
static inline /* this does not check for sanity for you to optimize speed */  \
name##_list name##_list_remove(name##_list * start, /* if it doesn't work, */ \
                               name##_list * end) { /* chances are start */   \
    name##_list * start_anc, end_child; /* and prev need to be switched */    \
    start_anc = start->prev; end_child = end->next;                           \
    start_anc->next = end_child; end_child->prev = start_anc;                 \
    return start; /* returns the removed list */                              \
}

