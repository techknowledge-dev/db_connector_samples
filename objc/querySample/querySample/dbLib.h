//
//  dbLib.h
//  dbLib
//
//  Created on 10/05/16.
//  Copyright 2010-2020 TechKnowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef enum _dbLibStatus {
	
	Normal = 0,
	NetworkFail = 1,
	NoURL = 2,
	NoUID = 3,
	NoPwd = 4,
	WebServiceFailed = 5,
	WebServiceException = 6,
	SqlEmpty = 7,
	StillInRequest = 8
	
} dbLibStatus;

@interface Column: NSObject;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* value;
@end

@interface dbLib : NSObject;

@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) NSString* uid;
@property (nonatomic,retain) NSString* pwd;
@property (nonatomic,retain) NSString* cns;
@property (nonatomic,retain) NSString* lastErrorText;
@property (nonatomic,retain) NSMutableArray* results;
@property (nonatomic,strong) id delegate;
@property (nonatomic,readonly) bool isInRequest;
@property (nonatomic,readwrite) bool encode;
@property (nonatomic,readwrite) bool verbose;
@property (nonatomic,readwrite) bool rawUrl;
@property (nonatomic,readwrite) bool lowerColName;
@property (nonatomic,readwrite) bool useMainQueue;      // 2018/2/2 added
@property (nonatomic,readwrite) NSTimeInterval timeOut; // 2018/3/12 added

-(dbLibStatus) connect;
-(dbLibStatus) disconnect;
-(dbLibStatus) query: (NSString*) sql;
-(dbLibStatus) queryRows: (NSString*) sql :(NSInteger) maxRows;
-(dbLibStatus) execute: (NSString*) sql;
-(dbLibStatus) beginTrans;
-(dbLibStatus) commitTrans;
-(dbLibStatus) rollbackTrans;
-(dbLibStatus) getLastErrorText;
-(dbLibStatus) endQuery;

@end

@protocol dbLibDelegate
@optional

-(void) requestCompleted:(NSString*) methodName;
-(void) requestFailed:(NSString*) methdName :(NSError*)error;
-(bool) rowFetched:(NSMutableDictionary*) row;
-(void) queryRowsCompleted:(NSMutableArray*) rows;
-(void) queryCompleted;
-(void) gotLastErrorString:(NSString*) message;
-(void) gotLastErrorString:(NSString*) message methodName:(NSString*) mn;	// 2018/9/19 added.

@end
