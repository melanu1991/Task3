//
//  ViewController.m
//  Calculator
//
//  Created by melanu on 11.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"

@interface ViewController () {
}
@property (nonatomic,assign) BOOL isDotButton;
@property (nonatomic,retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDotButton = NO;
    self.formatterDecimal = [[NSNumberFormatter alloc]init];
    self.formatterDecimal.minimumFractionDigits = 1;
    self.formatterDecimal.generatesDecimalNumbers = YES;
    self.formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAbout)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe {
    if (self.resultLabel.text.length != 0) {
        NSString *result = [self.resultLabel.text substringToIndex:self.resultLabel.text.length-1 ];
        self.resultLabel.text = result;
    }
    if (![self.resultLabel.text containsString:@"."]) {
        self.isDotButton = NO;
    }
    if (self.resultLabel.text.length == 0 || [self.resultLabel.text isEqualToString:@"0"]) {
        self.resultLabel.text = @"0";
    }
}

- (void)transitionAbout {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
}

- (IBAction)buttonNumberPressed:(UIButton *)sender {
    
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    NSDecimalNumber *decimal = nil;
    
    if (self.isDotButton && [value isEqualToString:@"0"]) {
        self.resultLabel.text = result;
    }
    else {
        decimal = (NSDecimalNumber *)[self.formatterDecimal numberFromString:result];
        self.resultLabel.text = [NSString stringWithFormat:@"%@", decimal];
    }

}

- (IBAction)dotButton:(UIButton *)sender {
    if (!self.isDotButton) {
        NSString *temp = [self.resultLabel.text stringByAppendingString:@"."];
        self.resultLabel.text = temp;
        self.isDotButton = YES;
    }
}

- (IBAction)buttonPressClear:(UIButton *)sender {
    self.resultLabel.text = @"0";
    self.isDotButton = NO;
}
- (IBAction)buttonAboutModal:(id)sender {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self presentViewController:aboutView animated:YES completion:nil];
    [aboutView release];
}

- (IBAction)buttonAbout:(id)sender {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
}

- (void)dealloc {
    [_resultLabel release];
    [_formatterDecimal release];
    [_swipeLeft release];
    [super dealloc];
}
@end
