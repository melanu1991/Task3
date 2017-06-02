#import "ViewController.h"

NSString * const VAKDotCharacter = @".";
NSString * const VAKNullCharacter = @"0";

@interface ViewController ()
@property (nonatomic, assign,getter=isDec) BOOL dec;
@property (nonatomic, assign, getter=isDotButton) BOOL dotButton;
@property (nonatomic, assign, getter=isWaitNextInput) BOOL waitNextInput;
@property (nonatomic, assign, getter=isEqualButtonPressed) BOOL equalButtonPressed;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
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

@property (retain, nonatomic) IBOutlet UIStackView *stackView1;
@property (retain, nonatomic) IBOutlet UIStackView *stackView2;
@property (retain, nonatomic) IBOutlet UIStackView *stackView3;
@property (retain, nonatomic) IBOutlet UIStackView *stackView4;
@property (retain, nonatomic) IBOutlet UIStackView *stackView5;
@property (retain, nonatomic) IBOutlet UIStackView *stackView6;

@property (retain, nonatomic) IBOutlet UIButton *binButton;
@property (retain, nonatomic) IBOutlet UIButton *octButton;
@property (retain, nonatomic) IBOutlet UIButton *decButton;
@property (retain, nonatomic) IBOutlet UIButton *hexButton;
@property (retain, nonatomic) IBOutlet UIButton *fButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
    UIBarButtonItem *item = [[[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAbout)]autorelease];
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
    if (![self.resultLabel.text containsString:VAKDotCharacter]) {
        self.dotButton = NO;
    }
    if (self.resultLabel.text.length == 0 || [self.resultLabel.text isEqualToString:VAKNullCharacter]) {
        self.resultLabel.text = VAKNullCharacter;
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        [self.stackView1 addArrangedSubview:self.binButton];
        [self.stackView2 addArrangedSubview:self.octButton];
        [self.stackView3 addArrangedSubview:self.decButton];
        [self.stackView4 addArrangedSubview:self.hexButton];
        [self.stackView5 addArrangedSubview:self.fButton];
        self.stackView6.hidden = true;
    } else {
        self.stackView6.hidden = false;
        [self.stackView6 addArrangedSubview:self.binButton];
        [self.stackView6 addArrangedSubview:self.octButton];
        [self.stackView6 addArrangedSubview:self.decButton];
        [self.stackView6 addArrangedSubview:self.hexButton];
        [self.stackView6 addArrangedSubview:self.fButton];
    }
}

#pragma mark - action

- (void)transitionAbout {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
}

- (IBAction)buttonLicencePressed:(id)sender {
    LicenseViewController *licenseView = [[LicenseViewController alloc]init];
    [self presentViewController:licenseView animated:YES completion:nil];
    [licenseView release];
}

- (IBAction)buttonNumberPressed:(UIButton *)sender {
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = nil;
    if (self.isEqualButtonPressed) {
        self.resultLabel.text = value;
        self.equalButtonPressed = NO;
        [self.calcModel clearValue];
        return;
    }
    if (self.isWaitNextInput) {
        result = value;
        self.waitNextInput = NO;
        self.calcModel.NextOperand = YES;
    }
    else {
        if (![self.resultLabel.text isEqualToString:@"0"]) {
            result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
        } else if ([self.resultLabel.text isEqualToString:VAKNullCharacter]) {
            result = [NSString stringWithFormat:@"%@",value];
        } else if (self.isDotButton && [value isEqualToString:VAKDotCharacter]) {
            result = self.resultLabel.text;
        }
    }
    self.resultLabel.text = result;
}

- (IBAction)dotButton:(UIButton *)sender {
    if (!self.isDotButton) {
        NSString *temp = [self.resultLabel.text stringByAppendingString:@"."];
        self.resultLabel.text = temp;
        self.dotButton = YES;
    }
}

- (IBAction)buttonPressClear:(UIButton *)sender {
    self.resultLabel.text = VAKNullCharacter;
    self.dotButton = NO;
    self.waitNextInput = YES;
    [self.calcModel clearValue];
}

- (IBAction)equalKeyIsPressed:(id)sender {
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    [self.calcModel executeOperation:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text]];
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
    }
    self.equalButtonPressed = YES;
}

- (IBAction)binaryOperatorKeyIsPressed:(id)sender {
    self.equalButtonPressed = NO;
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    NSDecimalNumber *lableValue = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
    [self.calcModel binaryOperationWithOperand:lableValue operation:[sender titleForState:UIControlStateNormal]];
    self.waitNextInput = YES;
    self.calcModel.NextOperand = NO;
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
    }
}

- (IBAction)unaryOperatorKeyIsPressed:(id)sender {
    self.equalButtonPressed = NO;
    if (self.delegate != nil) {
        self.resultLabel.text = [self.delegate convertToDec:self.resultLabel.text];
    }
    [self.calcModel unaryOperationWithOperand:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text] operation:[sender titleForState:UIControlStateNormal]];
    self.waitNextInput = YES;
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
        [self binaryButtonsEnable];
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
        
    } else if ([value isEqualToString:@"OCT"]) {
        self.delegate = self.octSystem;
        [self octButtonsEnable];
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
        
    } else if ([value isEqualToString:@"DEC"]) {
        [self decButtonsEnable];
        self.dec = YES;
        self.delegate = nil;
    } else if ([value isEqualToString:@"HEX"]) {
        self.delegate = self.hexSystem;
        [self hexButtonsEnable];
        self.resultLabel.text = [self.delegate decToChoiceSystem:self.resultLabel.text];
        self.dec = NO;
    }
    self.waitNextInput = YES;
}

#pragma mark - delegate protocol

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult {
    self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:newResult];
}

- (void)setResultExceptionOnDisplay:(NSString *)showDisplayException {
    [self.resultLabel setText:showDisplayException];
}

#pragma mark - buttons enable

- (void)hexButtonsEnable {
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
    for (UIButton *button in self.disableOperation) {
        button.enabled = NO;
    }
}

- (void)octButtonsEnable {
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
}

- (void)binaryButtonsEnable {
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
    for (UIButton *button in self.disableOperation) {
        button.enabled = YES;
    }
}

#pragma mark - deallocate

- (void)dealloc {
    [_calcModel release];
    [_delegate release];
    [_resultLabel release];
    [_swipeLeft release];
    [_binButtons release];
    [_octButtons release];
    [_hexButtons release];
    [_decButtons release];
    [_disableOperation release];
    [_binarySystem release];
    [_octSystem release];
    [_binarySystem release];
    [_stackView1 release];
    [_stackView2 release];
    [_stackView3 release];
    [_stackView4 release];
    [_stackView5 release];
    [_binButton release];
    [_octButton release];
    [_decButton release];
    [_hexButton release];
    [_fButton release];
    [_stackView6 release];
    [super dealloc];
}
@end
