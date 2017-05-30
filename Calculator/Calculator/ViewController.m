#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign,getter=isDec) BOOL dec;
@property (nonatomic,assign,getter=isEqualButton) BOOL equalButton;
@property (nonatomic,assign) BOOL isDotButton;
@property (nonatomic, assign) BOOL waitNextOperand;
@property (nonatomic, assign) BOOL flagNextInput;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) NSDecimalNumber *decimal;
@property (nonatomic, strong) CalculatorModel *calcModel;
@property (nonatomic, strong) BinarySystem *binarySystem;
@property (nonatomic, strong) OctSystem *octSystem;
@property (nonatomic, strong) HexSystem *hexSystem;
@property (nonatomic, unsafe_unretained) id<SystemProtocol> delegate;

@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *binButtons;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *octButtons;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *hexButtons;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *decButtons;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *disableOperation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAbout)];
    self.navigationItem.leftBarButtonItem = item;
    self.calcModel = [[[CalculatorModel alloc]init]autorelease];
    self.calcModel.delegate = self;
    self.binarySystem = [[[BinarySystem alloc]init]autorelease];
    self.octSystem = [[[OctSystem alloc]init]autorelease];
    self.hexSystem = [[[HexSystem alloc]init]autorelease];
    [self decButtonsEnable];
    self.dec = YES;
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
        result = [NSString stringWithFormat:@"%@%@",[self.resultLabel.text isEqualToString:@"0"] ? @"": self.resultLabel.text,value];
        if (self.isDotButton && [value isEqualToString:@"0"]) {
            self.resultLabel.text = result;
        }
        else {
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEF"];
            if ([result rangeOfCharacterFromSet:set].length != 0) {
                self.resultLabel.text = result;
            }
            else {
                self.resultLabel.text = [NSString stringWithFormat:@"%@", (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:result]];
            }
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
    self.dec = YES;
}

- (IBAction)equalKeyIsPressed:(id)sender {
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    if (!self.isEqualButton) {
        self.calcModel.beforeOperand = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
        NSDecimalNumber *temp = [self.calcModel binaryOperand:self.calcModel.beforeOperand];
        if (temp!=nil) {
            self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber: temp];
        }
        self.waitNextOperand = NO;
        self.flagNextInput = NO;
    }
    else {
        
        NSDecimalNumber *temp = [self.calcModel binaryOperand:self.calcModel.beforeOperand];
        if (temp!=nil) {
            self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber: temp];
        }
        
    }
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
    }
    self.equalButton = YES;
    self.flagNextInput = YES;
    
}
- (IBAction)binaryOperatorKeyIsPressed:(id)sender {
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    self.decimal = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
    if (self.waitNextOperand && !self.flagNextInput) {
        NSDecimalNumber *temp = [self.calcModel binaryOperand:self.decimal];
        if (temp!=nil) {
            self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:temp];
        }
    }
    else {
        self.calcModel.currentOperand = self.decimal;
        self.waitNextOperand = YES;
    }
    self.flagNextInput = YES;
    self.isDotButton = NO;
    self.equalButton = NO;
    self.calcModel.operation = [sender titleForState:UIControlStateNormal];
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
    }
}
- (IBAction)unaryOperatorKeyIsPressed:(id)sender {
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    self.decimal = [self.calcModel unaryOperand:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text] operation:[sender titleForState:UIControlStateNormal]];
    if (self.decimal!=nil) {
        self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:self.decimal];
    }
    self.flagNextInput = YES;
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
    }
}
- (IBAction)BinOctDecHexSystemPressedButton:(UIButton *)sender {
    
    NSString *value = [sender titleForState:UIControlStateNormal];
    if (!self.isDec) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    
    if ([value isEqualToString:@"BIN"]) {
        
        self.delegate = self.binarySystem;
        for (UIButton *button in self.binButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.octButtons) {
            button.enabled = NO;
        }
        for (UIButton *button in self.hexButtons) {
            button.enabled = NO;
        }
        for (UIButton *button in self.disableOperation) {
            button.enabled = NO;
        }
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
        
    } else if ([value isEqualToString:@"OCT"]) {
        
        self.delegate = self.octSystem;
        for (UIButton *button in self.binButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.octButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.hexButtons) {
            button.enabled = NO;
        }
        for (UIButton *button in self.disableOperation) {
            button.enabled = NO;
        }
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
        
    } else if ([value isEqualToString:@"DEC"]) {
        
        [self decButtonsEnable];
        self.dec = YES;
        self.delegate = nil;
        
    } else if ([value isEqualToString:@"HEX"]) {
        
        self.delegate = self.hexSystem;
        for (UIButton *button in self.binButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.octButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.hexButtons) {
            button.enabled = YES;
        }
        for (UIButton *button in self.disableOperation) {
            button.enabled = NO;
        }
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
    }

}

- (void)decButtonsEnable {
    for (UIButton *button in self.binButtons) {
        button.enabled = YES;
    }
    for (UIButton *button in self.octButtons) {
        button.enabled = YES;
    }
    for (UIButton *button in self.hexButtons) {
        button.enabled = NO;
    }
    for (UIButton *button in self.decButtons) {
        button.enabled = YES;
    }
}

#pragma mark - delegate protocol

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult {
//    self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:newResult];
}

- (void)setResultExceptionOnDisplay:(NSString *)showDisplayException {
    [self.resultLabel setText:showDisplayException];
}

#pragma mark - deallocate

- (void)dealloc {
    [_resultLabel release];
    [_swipeLeft release];
    [_calcModel release];
    [_decimal release];
    [_binButtons release];
    [_octButtons release];
    [_hexButtons release];
    [_decButtons release];
    [_disableOperation release];
    [_binarySystem release];
    [_octSystem release];
    [_binarySystem release];
    [super dealloc];
}
@end
