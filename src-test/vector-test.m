//! Created by Chris Miller on 24 December 2009.
//! Copyright 2009 FSDEV. Aw richts is pitten by.

#import "vector-test.h"

@implementation vector_test

- (void)testVector {
	int_vector v = int_vector_create(10);
	
	int i;
	for(i=0; i<10; ++i)
		int_vector_push_back(&v, i);
	
	{
		int expected_values[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
		
		/*
		 v.length   := 10		v.capacity := 10
		 v[ 0]      :=  0		v[ 5]      :=  5
		 v[ 1]      :=  1		v[ 6]      :=  6
		 v[ 2]      :=  2		v[ 7]      :=  7
		 v[ 3]      :=  3		v[ 8]      :=  8
		 v[ 4]      :=  4		v[ 9]      :=  9
		 */
		
		STAssertTrue(v.length == 10l, @"Length not what it should be");
		STAssertTrue(v.capacity == 10l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 10l), 0, @"Contents not what it should be");
	}
		
	int_vector_push_back(&v, 11);
	
	{
		int expected_values[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11 };
			
		/*
		 v.length   := 11		v.capacity := 20
		 v[ 0]      :=  0		v[ 6]      :=  6
		 v[ 1]      :=  1		v[ 7]      :=  7
		 v[ 2]      :=  2		v[ 8]      :=  8
		 v[ 3]      :=  3		v[ 9]      :=  9
		 v[ 4]      :=  4		v[10]      := 11
		 v[ 5]      :=  5
		 */
		
		STAssertTrue(v.length == 11l, @"Length not what it should be");
		STAssertTrue(v.capacity == 20l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 11l), 0, @"Contents not what it should be");
	}
	
	int_vector_insert(&v, 5l, 12);
	
	{
		int expected_values[] = { 0, 1, 2, 3, 4, 12, 5, 6, 7, 8, 9, 11 };
		
		/*
		 v.length   := 12		v.capacity := 20
		 v[ 0]      :=  0		v[ 6]      :=  5
		 v[ 1]      :=  1		v[ 7]      :=  6
		 v[ 2]      :=  2		v[ 8]      :=  7
		 v[ 3]      :=  3		v[ 9]      :=  8
		 v[ 4]      :=  4		v[10]      :=  9
		 v[ 5]      := 12		v[11]      := 11
		 */
		
		STAssertTrue(v.length == 12l, @"Length not what it should be");
		STAssertTrue(v.capacity == 20l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 12l), 0, @"Contents not what it should be");
	}
	
	int r[] = { 13, 14, 15 };
	int_vector_insert_range(&v, 6l, r, r+3);
	
	{
		int expected_values[] = { 0, 1, 2, 3, 4, 12, 13, 14, 15, 5, 6, 7, 8, 9, 11 };
		
		/*
		 v.length   := 15		v.capacity := 20
		 v[ 0]      :=  0		v[ 8]      := 15
		 v[ 1]      :=  1		v[ 9]      :=  5
		 v[ 2]      :=  2		v[10]      :=  6
		 v[ 3]      :=  3		v[11]      :=  7
		 v[ 4]      :=  4		v[12]      :=  8
		 v[ 5]      := 12		v[13]      :=  9
		 v[ 6]      := 13		v[14]      := 11
		 v[ 7]      := 14
		 */
		
		STAssertTrue(v.length == 15l, @"Length not what it should be");
		STAssertTrue(v.capacity == 20l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 15l), 0, @"Contents not what it should be");
	}
	
	int_vector_remove(&v, 5l);

	{
		int expected_values[] = { 0, 1, 2, 3, 4, 13, 14, 15, 5, 6, 7, 8, 9, 11 };
		
		/*
		 v.length   := 14		v.capacity := 20
		 v[ 0]      :=  0		v[ 7]      := 15
		 v[ 1]      :=  1		v[ 8]      :=  5
		 v[ 2]      :=  2		v[ 9]      :=  6
		 v[ 3]      :=  3		v[10]      :=  7
		 v[ 4]      :=  4		v[11]      :=  8
		 v[ 5]      := 13		v[12]      :=  9
		 v[ 6]      := 14		v[13]      := 11
		 */
		
		STAssertTrue(v.length == 14l, @"Length not what it should be");
		STAssertTrue(v.capacity == 20l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 14l), 0, @"Contents not what it should be");
	}
	
	int_vector_remove_range(&v, 5l, 7l);

	{
		int expected_values[] = { 0, 1, 2, 3, 4, 15, 5, 6, 7, 8, 9, 11 };
		
		/*
		 v.length   := 12		v.capacity := 20
		 v[ 0]      :=  0		v[ 6]      :=  5
		 v[ 1]      :=  1		v[ 7]      :=  6
		 v[ 2]      :=  2		v[ 8]      :=  7
		 v[ 3]      :=  3		v[ 9]      :=  8
		 v[ 4]      :=  4		v[10]      :=  9
		 v[ 5]      := 15		v[11]      := 11
		 */
		
		STAssertTrue(v.length == 12l, @"Length not what it should be");
		STAssertTrue(v.capacity == 20l, @"Capacity not what it should be");
		STAssertEquals(memcmp(v.data, expected_values, sizeof(int) * 12l), 0, @"Contents not what it should be");
	}
	
	int_vector_free_stack(&v);
	
}

@end
