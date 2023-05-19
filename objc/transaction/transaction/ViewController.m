//
//  ViewController.m
//  transaction
//
//  Created on 2012/08/07.
//  Copyright (c) 2012年 techknowledge. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) requestCompleted:(NSString*) methodName {
    NSLog(@"request finished %@",methodName);
}

-(void) requestFailed:(NSString*) methdName :(NSError*)error {
    NSLog(@"request failed %@",methdName);
    if(_db.lastErrorText != nil){
        NSLog(@"last error = %@",_db.lastErrorText);
    }
}


-(IBAction) onBeginTrans {
    dbLibStatus rc;
    rc = [_db beginTrans];
    NSLog(@"begin trans rc=%d",rc);
    
}

-(IBAction) onUpdate {
    dbLibStatus rc;
    rc = [_db execute:@"update emp set ENAME='SCOTT' where EMPID='10000'"];
    NSLog(@"execute rc=%d",rc);
}

-(IBAction) onCommit {
    dbLibStatus rc;
    rc = [_db commitTrans];
    NSLog(@"commit rc=%d",rc);
}

-(IBAction) onRollback {
    dbLibStatus rc;
    rc = [_db rollbackTrans];
    NSLog(@"rollback rc=%d",rc);
}

-(void) dealloc {
    [_db release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_db = [[dbLib alloc] init];
	_db.url = @"http://192.168.0.18:8000";       // <== change here
	_db.delegate = self;
    _db.verbose = YES;
	
	dbLibStatus rc = [_db connect];
	
	if(rc != Normal) {
		
		NSLog(@"connect failed %d",rc);
		return;
	}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [_db disconnect];
    [_db release] ,_db =nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
