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

@interface ViewController ()
@property (nonatomic,assign,getter=isEqualButton) BOOL equalButton;
@property (nonatomic,assign) BOOL isDotButton;
@property (nonatomic, assign) BOOL waitNextOperand;
@property (nonatomic, assign) BOOL flagNextInput;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) NSDecimalNumber *decimal;
@property (nonatomic, strong) CalculatorModel *calcModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - action

- (void)transitionAbout {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
}

- (IBAction)buttonLicense:(id)sender {
    LicenseViewController *licenseView = [[LicenseViewController alloc]init];
    [self presentViewController:licenseView animated:YES completion:nil];
    [licenseView release];
}

- (IBAction)buttonNumberPressed:(UIButton *)sender {
    
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = nil;
    
    if (self.flagNextInput) {
        self.resultLabel.text = value;
        self.flagNextInput = NO;
    }
    else {
        result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
        if (self.isDotButton && [value isEqualToString:@"0"]) {
            self.resultLabel.text = result;
        }
        else {
            self.resultLabel.text = [NSString stringWithFormat:@"%@", (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:result]];
        }
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
    self.flagNextInput = NO;
    self.waitNextOperand = NO;
    self.equalButton = NO;
    self.calcModel.currentOperand = nil;
    self.decimal = nil;
}

- (IBAction)equalKeyIsPressed:(id)sender {
    
    if (!self.isEqualButton) {
        self.calcModel.beforeOperand = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
        NSDecimalNumber *temp = [self.calcModel binaryOperand:self.calcModel.beforeOperand];
        self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber: temp];
        self.waitNextOperand = NO;
        self.flagNextInput = NO;
    }
    else {
        
        NSDecimalNumber *temp = [self.calcModel binaryOperand:self.calcModel.beforeOperand];
        self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber: temp];
        
    }
    
    self.equalButton = YES;
    
}
- (IBAction)binaryOperatorKeyIsPressed:(id)sender {
    self.decimal = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
    if (self.waitNextOperand && !self.flagNextInput) {
        self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:[self.calcModel binaryOperand:self.decimal]];
    }
    else {
        self.calcModel.currentOperand = self.decimal;
        self.waitNextOperand = YES;
    }
    self.flagNextInput = YES;
    self.isDotButton = NO;
    self.equalButton = NO;
    self.calcModel.operation = [sender titleForState:UIControlStateNormal];
}
- (IBAction)unaryOperatorKeyIsPressed:(id)sender {
    
    self.decimal = [self.calcModel unaryOperand:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text] operation:[sender titleForState:UIControlStateNormal]];
    self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:self.decimal];
    self.flagNextInput = YES;
}

#pragma mark - deallocate

- (void)dealloc {
    [_resultLabel release];
    [_swipeLeft release];
    [_calcModel release];
    [_decimal release];
    [super dealloc];
}
@end
