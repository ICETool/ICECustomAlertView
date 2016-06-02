//
//  ICEViewController.m
//  ICEAlertView
//
//  Created by WLY on 16/6/1.
//  Copyright © 2016年 ICE. All rights reserved.
//

#import "ICEViewController.h"
#import "ICECustomAlertView.h"


@interface ICEViewController ()

@property (nonatomic, strong) ICECustomAlertView *alertView;

@end

@implementation ICEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(handleAlertVC) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleAlertVC{

//    [ICECustomAlertView alertViewWithCustomView:nil];
     [ICECustomAlertView alertViewWithTitle:@"发" withMessage:@"提示" withButtonTitles:@[@"确定",@"确定"] completion:nil];
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    customView.backgroundColor = [UIColor yellowColor];
//    [ICECustomAlertView alertViewWithCustomView:customView withButtonTitles:@[@"确定"] completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
