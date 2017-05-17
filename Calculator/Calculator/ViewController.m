//
//  ViewController.m
//  Calculator
//
//  Created by melanu on 11.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import "LicenseViewController.h"
#import "CalculatorModel.h"

@interface ViewController () {
}
@property (nonatomic,assign) BOOL isDotButton;
@property (nonatomic, assign) BOOL waitNextOperand;
@property (nonatomic,retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) NSDecimalNumber *decimal;
@property (nonatomic, strong) CalculatorModel *calcModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDotButton = NO;
    self.waitNextOperand = NO;
    self.formatterDecimal = [[NSNumberFormatter alloc]init];
    self.formatterDecimal.minimumFractionDigits = 1;
    self.formatterDecimal.generatesDecimalNumbers = YES;
    self.formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAbout)];
    self.navigationItem.leftBarButtonItem = item;
    self.calcModel = [[CalculatorModel alloc]init];
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
    
    if (self.isDotButton && [value isEqualToString:@"0"]) {
        self.resultLabel.text = result;
        self.decimal = (NSDecimalNumber *)[self.formatterDecimal numberFromString:result];
    }
    else {
        self.decimal = (NSDecimalNumber *)[self.formatterDecimal numberFromString:result];
        self.resultLabel.text = [NSString stringWithFormat:@"%@", self.decimal];
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
    self.decimal = nil;
}
- (IBAction)buttonLicense:(id)sender {
    LicenseViewController *licenseView = [[LicenseViewController alloc]init];
    [self presentViewController:licenseView animated:YES completion:nil];
    [licenseView release];
}
- (IBAction)equalKeyIsPressed:(id)sender {
    NSDecimalNumber *temp = [self.calcModel performOperand:self.decimal];
    self.resultLabel.text = [NSString stringWithFormat:@"%@",temp];
    self.decimal = temp;
    self.waitNextOperand = NO;
}
- (IBAction)binaryOperatorKeyIsPressed:(id)sender {
   
    if (self.waitNextOperand) {
        NSDecimalNumber *temp = [self.calcModel performOperand:self.decimal];
        self.resultLabel.text = [NSString stringWithFormat:@"%@",temp];
        self.decimal = temp;
        self.waitNextOperand = NO;
    }
    else {
        self.calcModel.currentOperand = self.decimal;
        [self buttonPressClear:nil];
        self.waitNextOperand = YES;
    }
    self.calcModel.operation = [sender titleForState:UIControlStateNormal];
}
- (IBAction)unaryOperatorKeyIsPressed:(id)sender {
    self.calcModel.operation = [sender titleForState:UIControlStateNormal];
    NSDecimalNumber *temp = [self.calcModel performOperand:self.decimal];
    self.resultLabel.text = [NSString stringWithFormat:@"%@",temp];
    self.decimal = temp;
}

- (void)dealloc {
    [_resultLabel release];
    [_formatterDecimal release];
    [_swipeLeft release];
    [_calcModel release];
    [_decimal release];
    [super dealloc];
}
@end
