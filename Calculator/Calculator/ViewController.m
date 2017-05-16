//
//  ViewController.m
//  Calculator
//
//  Created by melanu on 11.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
}
@property (nonatomic, assign) BOOL isDotButton;
@property (nonatomic, retain) NSNumberFormatter *formatterDecimal;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, assign) BOOL isOneNumber;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDotButton = NO;
    self.isOneNumber = NO;
    self.formatterDecimal = [[NSNumberFormatter alloc]init];
    self.formatterDecimal.minimumFractionDigits = 1;
    self.formatterDecimal.generatesDecimalNumbers = YES;
    self.formatterDecimal.numberStyle = NSNumberFormatterDecimalStyle;
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
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
        self.isOneNumber = NO;
    }
}

//Такой вариант(хоть и рабочий) мне не очень нравиться,
//т,к, в таком случае делаются две проверки, на 1 строку больше
//+промежуточное преобразование в decimal
//Считаю что лучше хранить все в стринге(можно мутабельном) ,а  при самих расчетах уже преобразовывать в decimal
/*- (IBAction)buttonPressNumber:(UIButton *)sender {
    
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    NSDecimalNumber *decimal = nil;
    
    if (isDotButton && [value isEqualToString:@"0"]) {
        self.resultLabel.text = result;
    }
    else {
        decimal = (NSDecimalNumber *)[formatterDecimal numberFromString:result];
        self.resultLabel.text = [NSString stringWithFormat:@"%@", decimal];
    }

}*/

//хотя уже начинаю сомневаться что это лучше)))
- (IBAction)buttonNumberPressed:(UIButton *)sender {

    NSString *value = [sender titleForState:UIControlStateNormal];

    if (self.isOneNumber) {
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
    }
    else if (![value isEqualToString:@"0"] && ![self.resultLabel.text isEqualToString:@"0"]) {
        self.resultLabel.text = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
        self.isOneNumber = YES;
    }
    else if ([self.resultLabel.text isEqualToString:@"0"]) {
        self.resultLabel.text = value;
    }
    
}
- (IBAction)dotButton:(UIButton *)sender {
    if (!self.isDotButton) {
        NSString *temp = [self.resultLabel.text stringByAppendingString:@"."];
        self.resultLabel.text = temp;
        self.isDotButton = YES;
        self.isOneNumber = YES;
    }
}

- (IBAction)buttonPressClear:(UIButton *)sender {
    self.resultLabel.text = @"0";
    self.isDotButton = NO;
    self.isOneNumber = NO;
}
- (void)dealloc {
    [_resultLabel release];
    [_formatterDecimal release];
    [_swipeLeft release];
    [super dealloc];
}
@end
