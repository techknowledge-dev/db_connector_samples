//
//  ViewController.h
//  querySample
//
//  Created on 2020/12/04.
//

#import <UIKit/UIKit.h>
#import "dbLib.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,dbLibDelegate> {

@private
    dbLib* _db;
    UITableView* _tableView;
    NSInteger _count;
    NSMutableArray* _array;

}

@property(nonatomic,retain) IBOutlet UITableView* tableView;

@end

