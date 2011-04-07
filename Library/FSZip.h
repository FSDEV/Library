/**
 * Abstracts the use of a ZIP file through libzip into a nice Cocoa class.  Like most good
 * things in life, this is not thread-safe.  Important things to note:
 *
 * <ul>
 *  <li>All bugs should be reported.  No exceptions.  Once you isolate a bug, just create
 *      a small program which can reproduce it.  Then send it to me on Github.  I suggest
 *      you host the program on Gist and link to that in the bug report ticket.</li>
 *  <li>ALL DATA IS RETAINED UNTIL THE ZIP FILE IS DEALLOCATED.  So, if you're doing a lot
 *      of write-happy coding, then I suggest that you periodically deallocate and re-alloc
 *      the ZIP file.</li>
 * </ul>
 *
 * Download, build, and install libzip from http://nih.at/libzip.  (usual ./configure, make,
 * make install routine).
 *
 * Copy libzip.1.0.0.dylib to your Xcode project's Linked Frameworks directory.
 * 
 * Next run the following on the dylib in your project directory:
 *		install_name_tool -id @executable_path/../Frameworks/libssh2.1.dylib libssh2.1.dylib
 * 
 * This causes the dylib to link to itself, instead of a (potentially nonexistant) dylib
 * in /usr/local/lib.
 *
 * Now create a "Copy Files" build phase in Xcode.  Set the destination to "Frameworks," then
 * drag the dylib from the Linked Frameworks group to this new copy files build step.  I suggest
 * you rename the build step to something more descriptive.
 * 
 * Finally, create a "Run Script" build phase in Xcode to run the following script:
 *		ABS_PATH="/usr/local/lib/libzip1.0.0.dylib"
 *		REL_PATH="@executable_path/../Frameworks/libzip1.0.0.dylib"
 *		install_name_tool -change $ABS_PATH $REL_PATH $TARGET_BUILD_DIR/$EXECUTABLE_PATH
 * I suggest you rename this to something more descriptive, as well.
 *
 * Or, the not so fun way...
 *
 * ./configure --enable-static --disable-shared
 * make
 * make install
 *
 * and link against libzip.a
 *
 * Which so so totally not as much fun.
 * 
 * @dependencies
 * >= libzip-0.9
 *  zlib
 * (C) 2010 FSDEV.  All rights reserved.
 * This code is two-clause BSD licensed.
 */

#import <Cocoa/Cocoa.h>
#include <zip.h>
#include <stdlib.h>

@interface FSZip : NSObject {
	struct zip * lzip;
	size_t chunksize;
	void * inbuff;
	int files;
    NSArray * _containedFiles;
}

@property(readwrite,assign) struct zip * lzip;	//! it is inadvisable to modify this
@property(readwrite,assign) size_t chunksize;		//! how many bytes to read at a time
@property(readwrite,assign) void * inbuff;		//! input buffer pointer
@property(readonly) int files;					//! number of files in the archive

/**
 * Opens a file as a ZIP archive, either opening a new file or creating a new archive to
 * be written to.  If it is creating a new archive, then that archive will not show up
 * on disk until the FSZip object deallocates.
 */
- (id)initWithFileName:(NSString *)file;

- (NSArray *)containedFiles;					//! listing of contained files

/**
 * Grabs the entire file and puts it into an NSData object.
 *
 * Not a good idea for especially large files.
 */
- (NSData *)dataForFile:(NSString *)file;

/**
 * Grabs the entire file and puts it into a void array, returning by reference
 * the length of the array.
 *
 * Not a good idea for especially large files.
 */
- (void *)cDataForFile:(NSString *)file
			  ofLength:(size_t*)len;

/**
 * Reads <code>chunksize</code> bytes from the specified zip file into <code>buff</code>
 * and returning by reference <code>bytes</code> bytes read.
 *
 * This is a streaming tool.  This is good if you have a file that is larger than
 * 1MiB that you're attempting to perform some kind of streamable operation on.
 */
- (void)readCDataFromFile:(struct zip_file *)file
					 into:(void *)buff
				bytesRead:(size_t *)bytes;

/**
 * Index of a specific file in the ZIP archive.
 */
- (NSUInteger)indexOfFile:(NSString *)file;

/**
 * Returns the zip_file structure associated with a specific file name; used in
 * conjunction with <code>readCDataFromFile:bytesRead:</code>.
 */
- (struct zip_file *)cFileForName:(NSString *)file;

/**
 * Renames file <code>oldName</code> to <code>newName</code>.
 */
- (BOOL)rename:(NSString *)oldName
            to:(NSString *)newName;

/**
 * Every file in a ZIP archive can have a comment.  Returns <code>nil</code> if there
 * is no such file.
 */
- (NSString *)commentForFile:(NSString *)file;

/**
 * Sets the comment for any given file.
 */
- (BOOL)setComment:(NSString *)comment
           forFile:(NSString *)file;

/**
 * Write <code>data</code> to <code>file</code>.  Really quite simple.
 */
- (BOOL)writeData:(NSData *)data
           toFile:(NSString *)file;

/**
 * Despite the horrible naming scheme, this takes the contents of the file on the local
 * disk described by <code>filePath</code> and compresses it into <code>file</code> in
 * the ZIP archive.
 */
- (BOOL)writeFile:(NSString *)filePath
           toFile:(NSString *)file;

/**
 * Changes the name of the file <code>oldName</code> and moves it to <code>newName</code>
 */
- (BOOL)renameFile:(NSString *)oldName
                to:(NSString *)newName;

/**
 * Deletes a file.
 */
- (BOOL)deleteFile:(NSString *)file;

/**
 * Panic and undo all pending changes to the archive.
 */
- (BOOL)panic;

/**
 * Panic and undo all changes to a specific file.
 */
- (BOOL)panicFile:(NSString *)file;

@end
