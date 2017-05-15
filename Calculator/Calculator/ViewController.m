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
    BOOL isDotButton;
    NSNumberFormatter *formatterDecimal;
    UISwipeGestureRecognizer *swipeLeft;
}
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isDotButton = NO;
    formatterDecimal = [[NSNumberFormatter alloc]init];
    formatterDecimal.minimumFractionDigits = 1;
    formatterDecimal.generatesDecimalNumbers = YES;
    formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
    swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe {
    if (self.resultLabel.text.length != 0) {
        NSString *result = [self.resultLabel.text substringToIndex:self.resultLabel.text.length-1 ];
        self.resultLabel.text = result;
    }
    if (![self.resultLabel.text containsString:@"."]) {
        isDotButton = NO;
    }
    if (self.resultLabel.text.length == 0 || [self.resultLabel.text isEqualToString:@"0"]) {
        self.resultLabel.text = @"0";
    }
}

- (IBAction)buttonPressNumber:(UIButton *)sender {
    
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    NSDecimalNumber *decimal = nil;
    
    if (isDotButton && [value isEqualToString:@"0"]) {
        self.resultLabel.text = [NSString stringWithFormat:@"%@", result];
    }
    else {
        decimal = (NSDecimalNumber *)[formatterDecimal numberFromString:result];
        self.resultLabel.text = [NSString stringWithFormat:@"%@", decimal];
    }

}

- (IBAction)dotButton:(UIButton *)sender {
    if (!isDotButton) {
        NSString *temp = [self.resultLabel.text stringByAppendingString:@"."];
        self.resultLabel.text = temp;
        isDotButton = YES;
    }
}

- (IBAction)buttonPressClear:(UIButton *)sender {
    self.resultLabel.text = @"0";
    isDotButton = NO;
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
    [formatterDecimal release];
    [swipeLeft release];
    [super dealloc];
}
@end
