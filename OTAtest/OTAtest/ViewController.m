//
//  ViewController.m
//  OTAtest
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 test1. All rights reserved.
//

#import "ViewController.h"
#import "BadWord.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDate *date3=[NSDate date];
    NSLog(@"data3 = %f",date3.timeIntervalSince1970);
    [BadWord getInstance];
    NSDate *date1=[NSDate date];
    NSLog(@"data1 = %f",date1.timeIntervalSince1970);
    [[BadWord getInstance] check:@"---犯罪--词--汇ggggr-犯    罪--词汇 ggggr-犯 罪--词汇ggggrcccccc犯罪--犯罪--词汇"];
    NSDate *date2=[NSDate date];
    NSLog(@"data2 = %f",date2.timeIntervalSince1970);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
