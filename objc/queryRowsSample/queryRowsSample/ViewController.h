//
//  ViewController.h
//  queryRowsSample
//
//  Created on 2020/12/06.
//

#import <UIKit/UIKit.h>

@class dbLib;

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
@private
    UITableView* _table;
    NSMutableArray* _rows;
    dbLib* _db;
}

@property(nonatomic,retain) IBOutlet UITableView* table;

@end

