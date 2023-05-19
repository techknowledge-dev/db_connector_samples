//
//  ViewController.m
//  querySample
//
//  Created on 2020/12/04.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -- dbLib code --

-(void) startConnect {
    
    _db = [[dbLib alloc] init];
    // _db.url = @"http://192.168.0.15/";    // <== change here.
    _db.url = @"http://localhost:8000";    // <== change here.
    _db.verbose = TRUE;
    _db.delegate = self;
    
    dbLibStatus rc = [_db connect];
    
    if(rc != Normal) {
        
        NSLog(@"connect failed %d",rc);
        return;
    }
    
}

-(void) startQuery {
    
    bool rc = [_db query:@"select EMPNO,ENAME from EMP order by EMPNO"];
    
    if(rc){
        NSLog(@"query request failed");
    }
}

-(void) requestCompleted:(NSString*) methodName {
    
    NSLog(@"request completed %@",methodName);
    
    if([methodName isEqualToString:@"Login"]){
        
        [self startQuery];
        
    }
}

-(void) requestFailed:(NSString*)methodName :(NSError *)error {
    
    NSLog(@"request failed %@ %@",methodName,_db.lastErrorText);
        
}

-(bool) rowFetched:(NSMutableDictionary *)row {
    
    NSString* empno = [row objectForKey:@"EMPNO"];
    NSString* ename = [row objectForKey:@"ENAME"];
    
    NSString* str = [NSString stringWithFormat:@"%@ %@", empno, ename];
    [_array addObject:str];
    
    _count++;
    
    return true;
}

-(void) queryCompleted {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_db disconnect];
        [self->_tableView reloadData];
    });
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 0;
    _array = [NSMutableArray array];
    
    [self startConnect];

}

#pragma mark -- table view delegate --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_array objectAtIndex: indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
