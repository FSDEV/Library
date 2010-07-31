//
//  FSZip.m
//  mines
//
//  Created by Chris Miller on 7/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "FSZip.h"

void logErrorStuff(int error) {
	switch (error) {
		case ZIP_ER_OPEN:
			NSLog(@"FSZip: Cannot open archive for reading.");
			break;
		case ZIP_ER_ZLIB:
			NSLog(@"FSZip: Error [de]compressing file.");
			break;
		case ZIP_ER_WRITE:
			NSLog(@"FSZip: Error writing to output file.");
			break;
		case ZIP_ER_EOF:
			NSLog(@"FSZip: Unexpected end-of-file found while reading from a file.");
			break;
		case ZIP_ER_INTERNAL:
			NSLog(@"FSZip: The callback function of an added or replaced file returned an error but failed to report which.");
			break;
		case ZIP_ER_INVAL:
			NSLog(@"FSZip: The path argument is NULL.");
			break;
		case ZIP_ER_MEMORY:
			NSLog(@"FSZip: Required memory could not be allocated.");
			break;
		case ZIP_ER_NOZIP:
			NSLog(@"FSZip: The file is not a zip archive, dude.");
			break;
		case ZIP_ER_READ:
			NSLog(@"FSZip: A file read failed.");
			break;
		case ZIP_ER_RENAME:
			NSLog(@"FSZip: A temporary file could not be renamed to its final name.");
			break;
		case ZIP_ER_SEEK:
			NSLog(@"FSZip: A file seek failed.");
			break;
		case ZIP_ER_TMPOPEN:
			NSLog(@"FSZip: A temporary file could not be created.");
			break;
		default:
			// do nothing
			NSLog(@"FSZip: Returned error code %d.",error);
			break;
	}	
}

@implementation FSZip

@synthesize lzip;
@synthesize chunksize;
@synthesize inbuff;

- (id)initWithFileName:(NSString *)file {
	if(self=[self init]) {
#if DEBUG
		NSLog(@"FSZip: Attempting to open %@ as ZIP file.",file);
#endif
		int error=0;
		lzip = zip_open([file UTF8String], 0, &error);
		if(error!=0) {
			logErrorStuff(error);
			return nil;
		}
	}
	return self;
}

- (NSArray*)containedFiles {
	NSMutableArray * _files = [[NSMutableArray alloc] initWithCapacity:self.files];
	for(int i=0; i<self.files; ++i)
		[_files addObject:[NSString stringWithUTF8String:zip_get_name(lzip, i, 0)]];
	return [NSArray arrayWithArray:[_files autorelease]];
}

- (NSData *)dataForFile:(NSString *)file {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_UNCHANGED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		return nil;
	}
	NSMutableData * zdata = [[NSMutableData alloc] init];
	void * stuff = (void*)malloc(sizeof(void)*chunksize);
	int read;
	do {
		read = zip_fread(zf, stuff, sizeof(void)*chunksize);
		[zdata appendBytes:stuff
					length:read];
	} while (read>0);
	free(stuff);
	[pool0 release];
	return [NSData dataWithData:[zdata autorelease]];
}

- (void *)cDataForFile:(NSString *)file
			  ofLength:(size_t*)len {
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_UNCHANGED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		(*len) = 0;
		return NULL;
	}
	void * toReturn = (void *)malloc(sizeof(void)*chunksize);
	int read;
	do {
		read = zip_fread(zf, toReturn+read, sizeof(void)*chunksize);
		toReturn = (void *)realloc(toReturn, read+sizeof(void)*chunksize);
	} while (read>0);
	return toReturn;
}

- (void)readCDataFromFile:(struct zip_file *)file
					 into:(void *)buff
				bytesRead:(size_t *)bytes {
	(*bytes) = zip_fread(file, buff, chunksize);
}

- (struct zip_file *)cFileForName:(NSString *)file {
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_UNCHANGED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		return NULL;
	}
	return zf;
}

- (int)files {
	if(files==-1)
		files = zip_get_num_files(lzip);
	return files;
}

#pragma mark NSObject

- (id)init {
	if(self=[super init]) {
		lzip = NULL;
		chunksize=1024;
		inbuff=NULL;
		files=-1;
	}
	return self;
}

- (void)dealloc {
	if(lzip!=NULL) {
		int error = zip_close(lzip);
		if(error!=0)
			logErrorStuff(error);
	}
	if(inbuff!=NULL)
		free(inbuff);
	[super dealloc];
}

@end
