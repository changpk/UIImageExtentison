


//
//  SecondViewController.m
//  ImageExtension
//
//  Created by sinagame on 16/2/25.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"

@implementation SecondViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ViewController *firsetVC = (ViewController *)self.presentingViewController;
    [firsetVC reloadMaintableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
