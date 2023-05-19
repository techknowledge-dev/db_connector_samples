//
//  ViewController.m
//  queryRowsSample
//
//  Created on 2020/12/06.
//

#import "ViewController.h"
#import "dbLib.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -- dbLib code --

-(void) startConnect {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    _db = [[dbLib alloc] init];
    _db.useMainQueue = FALSE;
    _db.url = @"http://192.168.0.18:8000";
    // _db.url = @"http://192.168.179.3";
    // _db.url = @"http://localhost:8000";
    //_db.url = @"http://localhost:8000/dbLibServer.asmx";
    
    // _db.url = @"http://160.16.231.181:8080/dbLibServer.asmx";
    //_db.url = @"http://160.248.14.42:8000/dbLibServer.asmx";        // wa1
    //_db.rawUrl = TRUE;

    // _db.url = @"http://160.248.14.42:8000";        // wa1
    //_db.url = @"https://160.248.14.42:8443";        // wa1
    // _db.url = @"https://conf2.storeapp.jp:8443";        // wa1
    //_db.url = @"https://uid:pass@conf2.storeapp.jp:8443";        // wa1
    //_db.rawUrl = TRUE;

    _db.delegate = self;
    _db.verbose = TRUE;
    
    
    dbLibStatus rc = [_db connect];
    
    if(rc != Normal) {
        
        NSLog(@"connect failed %d",rc);
        return;
    }
    
}

-(void) startQueryRows {
    
    bool rc = [_db queryRows:@"select EMPNO,ENAME from emp order by empno" :0];
    
    if(rc){
        NSLog(@"query rows request failed");
    }
}

-(void) requestCompleted:(NSString*) methodName {
    
    NSLog(@"request completed %@",methodName);
    
    if([methodName isEqualToString:@"Login"]){
        
        [self startQueryRows];
        
    }
}

-(void) requestFailed:(NSString*)methodName :(NSError *)error {
    
    NSLog(@"request failed %@ %@",methodName,_db.lastErrorText);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void) queryRowsCompleted:(NSMutableArray *)rows {

    dispatch_async(dispatch_get_main_queue(), ^{
        self->_rows = rows;
        [self->_table reloadData];
        [self->_db disconnect];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startConnect];
}

#pragma mark -- table view delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_rows == nil) return 0;
    return [_rows count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary* row = [_rows objectAtIndex:indexPath.row];
    NSString* empno = [row objectForKey:@"EMPNO"];
    NSString* ename = [row objectForKey:@"ENAME"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", empno, ename];
    
    return cell;
}

@end
