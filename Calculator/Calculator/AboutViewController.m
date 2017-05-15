//
//  AboutViewController.m
//  Calculator
//
//  Created by melanu1991 on 15.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)buttonReturnMain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buttonReturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
