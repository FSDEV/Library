//! Created by Chris Miller on 20 July 2009.
//! Copyright 2009 FSDEV. Aw richts is pitten by.

#import "FSLog.h"
#import <stdarg.h>
#import <stdio.h>

void FSLog(NSString * format, ...) {
	va_list args;
	va_start(args, format);
	[[FSLogger logger:@""] log:[[[NSString alloc] initWithFormat:format
                                                       arguments:args]
                                autorelease]];
}
NSMutableArray* FSLogGetListeners() {
	return [[FSLogger logger:@""] listeners];
}
void FSLogToNSLog(BOOL v) {
	[[FSLogger logger:@""] setLogsToNSLog:v];
}
BOOL FSLogsToNSLog() {
	return [[FSLogger logger:@""] logsToNSLog];
}

void FSLog2(NSString * logger, NSString * format, ...) {
	va_list args;
	va_start(args, format);
	[[FSLogger logger:logger] log:[[[NSString alloc] initWithFormat:format
														  arguments:args]
								   autorelease]];
}
void FSLog2NoPrefix(NSString * logger, NSString * format, ...) {
	va_list args;
	va_start(args, format);
	[[FSLogger logger:logger] log:[[[NSString alloc] initWithFormat:format
														  arguments:args]
								   autorelease]
						usePrefix:NO];
}
NSMutableArray* FSLog2GetListeners(NSString * logger) {
	return [[FSLogger logger:logger] listeners];
}
void FSLogToNSLog2(NSString * logger, BOOL v) {
	[[FSLogger logger:logger] setLogsToNSLog:v];
}
BOOL FSLogsToNSLog2(NSString * logger) {
	return [[FSLogger logger:logger] logsToNSLog];
}

void FSLogSetUpDefaults() {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	FSLogRelay * relay;
	
    //	relay = [FSLogRelay relayForLogger:FSLogLevelWarning];
    //	[[[FSLogger logger:FSLogLevelError] listeners] addObject:relay];
	
	relay = [FSLogRelay relayForLogger:FSLogLevelInfo];
	[[[FSLogger logger:(NSString *)FSLogLevelError] listeners] addObject:relay];
	
	relay = [FSLogRelay relayForLogger:FSLogLevelInfo];
	[[[FSLogger logger:FSLogLevelWarning] listeners] addObject:relay];
	
	FSLogToNSLog2(FSLogLevelInfo, YES);
	
	[pool release];
}

@implementation FSLogger

static NSMutableDictionary * kLoggers;

+ (id)logger:(NSString *)name {
	if(!kLoggers)
		kLoggers = [[NSMutableDictionary alloc] init];
	if([kLoggers objectForKey:name]==nil) {
		FSLogger * l = [[FSLogger alloc] init];
		l.name = name;
		[kLoggers setObject:l
					 forKey:name];
		if([name isEqualToString:@""])
			l.logsToNSLog = YES;
		return [l autorelease];
	}
	return [kLoggers objectForKey:name];
}

@synthesize listeners = _listeners;
@synthesize name = _name;
@synthesize logsToNSLog = _logsToNSLog;

- (void)log:(NSString *)msg
  usePrefix:(BOOL)prefix {
	if(_logsToNSLog)
		if(self.name!=nil&&![self.name isEqualToString:@""]&&prefix==YES)
			printf("%s",[[NSString stringWithFormat:@"%@: %@\n",_name,msg] UTF8String]);
    //			NSLog(@"%@: %@",_name,msg);
		else
			printf("%s",[[NSString stringWithFormat:@"%@\n",msg] UTF8String]);
    //			NSLog(msg,nil);
    
	if(self.name==nil)
		for(id<FSLogListener> l in _listeners)
			[l log:msg];
	else
		for(id<FSLogListener> l in _listeners)
			[l log:[NSString stringWithFormat:@"%@: %@",_name,msg]];
	
}

- (void)log:(NSString *)msg {
	
	if(_logsToNSLog)
		if(self.name!=nil&&![self.name isEqualToString:@""])
			printf("%s",[[NSString stringWithFormat:@"%@: %@\n",_name,msg] UTF8String]);
    //			NSLog(@"%@: %@",_name,msg);
		else
			printf("%s",[[NSString stringWithFormat:@"%@\n"] UTF8String]);
    //			NSLog(msg,nil);
	
	if(self.name==nil)
		for(id<FSLogListener> l in _listeners)
			[l log:msg];
	else
		for(id<FSLogListener> l in _listeners)
			[l log:[NSString stringWithFormat:@"%@: %@",_name,msg]];
	
}

#pragma mark -
#pragma mark NSObject

- (id)init {
    self = [super init];
    if (!self) return nil;
    _listeners = [[NSMutableArray alloc] init];
    _logsToNSLog = NO;
	return self;
}

- (void)dealloc {
	[_listeners release];
	[_name release];
	
	[super dealloc];
}

@end

@implementation FSLogRelay

+ (id)relayForLogger:(NSString *)targetLogger {
	return [[[FSLogRelay alloc] initForLogger:targetLogger] autorelease];
}

@synthesize targetLogger = _targetLogger;

- (id)initForLogger:(NSString *)targetLogger {
    self = [super init];
    if (!self) return nil;
    _targetLogger = [targetLogger retain];
	return self;
}

- (void)log:(NSString *)msg {
	FSLog2NoPrefix(_targetLogger, msg, nil);
}

- (void)dealloc {
	[_targetLogger release];
	
	[super dealloc];
}

@end

