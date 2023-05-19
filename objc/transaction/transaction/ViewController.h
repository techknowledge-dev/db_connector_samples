//
//  ViewController.h
//  transaction
//
//  Created on 2012/08/07.
//  Copyright (c) 2012年 techknowledge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbLib.h"

@interface ViewController : UIViewController {
@private
    dbLib* _db;
}

-(IBAction) onBeginTrans;
-(IBAction) onUpdate;
-(IBAction) onRollback;
-(IBAction) onCommit;

@end
