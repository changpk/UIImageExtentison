//
//  ViewController.m
//  ImageExtension
//
//  Created by sinagame on 16/2/23.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Extension.h"
#import "UIColor+Extention.h"
#import "SecondViewController.h"
#import "UserInfo.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTb;
    SecondViewController *_secVC;
    NSMutableArray *_dataSource;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    
//   _mainTb = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 200, 200) style:UITableViewStyleGrouped];
//    _mainTb.delegate = self;
//    _mainTb.dataSource = self;
    
    [self.view addSubview:_mainTb];
    
    for (int i = 0; i < 4; i ++) {
        UserInfo *obj = [[UserInfo alloc]init];
        obj.name = [NSString stringWithFormat:@"名称%ld",(long)i];
        [_dataSource addObject:obj];
    }
    

//    [_mainTb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    __block UserInfo *myUserInfo = nil;
    
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserInfo *userInfo = (UserInfo *)obj;
        if ([userInfo.name isEqualToString:@"名称3"]) {
            myUserInfo = userInfo;
            *stop = YES;
        }
    }];
    
    if (myUserInfo) {
        NSUInteger myUserInfoIndex = [_dataSource indexOfObject:myUserInfo];
        [_dataSource insertObject:myUserInfo atIndex:0];
        [_dataSource removeObjectAtIndex:myUserInfoIndex + 1];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    return cell;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _secVC = [[SecondViewController alloc]init];
    _secVC.view.backgroundColor = [UIColor cyanColor];
    [self presentViewController:_secVC animated:YES completion:^{
        
    }];
}

- (void)reloadMaintableView {
    self.view.backgroundColor = [UIColor yellowColor];
    
    [_dataSource removeAllObjects];
    
    [_dataSource addObject:@"5"];
    [_dataSource addObject:@"6"];
    [_dataSource addObject:@"7"];
    [_dataSource addObject:@"8"];
    [_mainTb reloadData];
    
    
}

@end
