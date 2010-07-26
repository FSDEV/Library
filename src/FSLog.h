//! Created by Chris Miller on 20 July 2009.
//! Copyright 2009 FSDEV. Aw richts is pitten by.

static NSString * FSLogLevelError = @"ERROR";
static NSString * FSLogLevelWarning = @"WARNING";
static NSString * FSLogLevelInfo = @"INFO";

/*!
 * Logs a message to NSLog and also to all log listeners of the default logger.
 * This is useful for logging a message to multiple locations such as a file,
 * the terminal, and to (for instance) and in-game Quake-style terminal.
 */
void FSLog(NSString * format, ...) __attribute__((format(__NSString__, 1, 2)));
/*!
 * Gets all the listeners registered to the global logger.  You may add listeners
 * to this mutable array, or remove them from it.
 */
NSMutableArray* FSLogGetListeners();
/*!
 * Instructs the default logger whether it should log to NSLog.
 */
void FSLogToNSLog(BOOL v);
/*!
 * Asks the default logger whether it logs to NSLog or not.
 */
BOOL FSLogsToNSLog();

/*!
 * Logs a message to a specific logger.  If the logger does not exist it is created.
 * You can use named loggers to control where logging output goes.
 */
void FSLog2(NSString * logger, NSString * format, ...) __attribute__((format(__NSString__, 2, 3)));
/*!
 * Logs a message to a specific logger, without prepending the logger's name.  If the logger
 * does not exist it is created.  You can use named loggers to control where logging output goes.
 */
void FSLog2NoPrefix(NSString * logger, NSString * format, ...) __attribute__((format(__NSString__, 2, 3)));
/*!
 * Gets all the listeners registered to a specific logger.  You may add listeners
 * to this mutable array, or remove them from it.
 */
NSMutableArray* FSLog2GetListeners(NSString * logger);
/*!
 * Instructs the specified logger whether it should log to NSLog.
 */
void FSLogToNSLog2(NSString * logger, BOOL v);
/*!
 * Asks the specified logger whether or not it logs to NSLog;
 */
BOOL FSLogsToNSLog2(NSString * logger);

/*!
 * Sets up a default configuration of loggers (Error, Warning, and Info)
 * in such a configuration that Info logs to just Info, Warning logs to
 * Warning and Info, Error logs to itself, Warning, and Info.
 */
void FSLogSetUpDefaults();

/*!
 * A simple protocol that you can implement to forward log messages to interesting
 * places.
 */
@protocol FSLogListener

- (void)log:(NSString *)msg;

@end

/*!
 * Logger implementation.  In most situations you should not need to worry about this
 * interface.  In the event that you wish to remove the prefixing performed by named
 * loggers, you may use the class message logger: to retreive the logger you want and
 * then set its name property to nil which will stop it from prefixing messages with its
 * name.
 */
@interface FSLogger : NSObject {

	NSMutableArray * _listeners;
	NSString * _name;
	
	BOOL _logsToNSLog;
	
}

+ (id)logger:(NSString *)name;

@property(readonly) NSMutableArray * listeners;
@property(readwrite,retain) NSString * name;
@property(readwrite,assign) BOOL logsToNSLog;

- (void)log:(NSString *)msg;
- (void)log:(NSString *)msg
  usePrefix:(BOOL)prefix;

@end

/*!
 * Relay FSLogListener used to relay log messages from one logger to
 * another.  This is similar to Java logging levels, where a message
 * sent to a higher logging level is sent to all loggers on the lower
 * levels.  For instance, a log message of level ERROR will appear in
 * the INFO and WARNING logs as well, but an INFO log message will not
 * appear in WARNING or ERROR because ERROR is higher than WARNING which
 * is higher than INFO (in this particular arbitrary example).
 */
@interface FSLogRelay : NSObject <FSLogListener> {
	NSString * _targetLogger;
}

@property(readwrite,retain) NSString * targetLogger;

+ (id)relayForLogger:(NSString *)targetLogger;

- (id)initForLogger:(NSString *)targetLogger;

@end

