#import "ViewController.h"

NSString * const VAKDotCharacter = @".";
NSString * const VAKNullCharacter = @"0";

@interface ViewController ()
@property (nonatomic, assign, getter=isWaitNextInput) BOOL waitNextInput;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) CalculatorModel *calcModel;

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
    [self decButtonsEnable];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe {
    if (self.resultLabel.text.length != 0) {
        NSString *result = [self.resultLabel.text substringToIndex:self.resultLabel.text.length-1 ];
        self.resultLabel.text = result;
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
    if (self.calcModel.equalOperation) {
        self.resultLabel.text = value;
        self.calcModel.equalOperation = NO;
        [self.calcModel clearValue];
        return;
    }
    if (self.isWaitNextInput) {
        result = value;
        self.waitNextInput = NO;
        self.calcModel.nextOperand = YES;
    }
    else {
        if (![self.resultLabel.text isEqualToString:VAKNullCharacter]) {
            result = [NSString stringWithFormat:@"%@%@",self.resultLabel.text,value];
        } else if ([self.resultLabel.text isEqualToString:VAKNullCharacter]) {
            result = [NSString stringWithFormat:@"%@",value];
        } else if ([self.resultLabel.text containsString:VAKDotCharacter] && [value isEqualToString:VAKDotCharacter]) {
            result = self.resultLabel.text;
        }
    }
    self.resultLabel.text = result;
}

- (IBAction)dotButton:(UIButton *)sender {
    if (![self.resultLabel.text containsString:VAKDotCharacter]) {
        NSString *temp = [self.resultLabel.text stringByAppendingString:VAKDotCharacter];
        self.resultLabel.text = temp;
    }
}

- (IBAction)buttonPressClear:(UIButton *)sender {
    self.resultLabel.text = VAKNullCharacter;
    self.waitNextInput = YES;
    [self.calcModel clearValue];
}

- (IBAction)equalKeyIsPressed:(id)sender {
    [self.calcModel convertAnyNumberSystemToDecimalNumberSystemWithNumber:self.resultLabel.text];
    [self.calcModel executeOperation:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text]];
    self.calcModel.equalOperation = YES;
    [self.calcModel convertDecimalNumberSystemToAnyNumberSystemWithNumber:self.resultLabel.text];
}

- (IBAction)binaryOperatorKeyIsPressed:(id)sender {
    [self.calcModel convertAnyNumberSystemToDecimalNumberSystemWithNumber:self.resultLabel.text];
    self.calcModel.equalOperation = NO;
    NSDecimalNumber *lableValue = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
    [self.calcModel binaryOperationWithOperand:lableValue operation:[sender titleForState:UIControlStateNormal]];
    self.waitNextInput = YES;
    self.calcModel.nextOperand = NO;
    [self.calcModel convertDecimalNumberSystemToAnyNumberSystemWithNumber:self.resultLabel.text];
}

- (IBAction)unaryOperatorKeyIsPressed:(id)sender {
    [self.calcModel convertAnyNumberSystemToDecimalNumberSystemWithNumber:self.resultLabel.text];
    self.calcModel.equalOperation = NO;
    [self.calcModel unaryOperationWithOperand:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text] operation:[sender titleForState:UIControlStateNormal]];
    self.waitNextInput = YES;
    [self.calcModel convertDecimalNumberSystemToAnyNumberSystemWithNumber:self.resultLabel.text];    
}

- (IBAction)BinOctDecHexSystemPressedButton:(UIButton *)sender {
    NSString *newSystem = [sender titleForState:UIControlStateNormal];
    if ([newSystem isEqualToString:@"BIN"]) {
        [self binaryButtonsEnable];
    }
    else if ([newSystem isEqualToString:@"OCT"]) {
        [self octButtonsEnable];
    }
    else if ([newSystem isEqualToString:@"DEC"]) {
        [self decButtonsEnable];
    }
    else if ([newSystem isEqualToString:@"HEX"]) {
        [self hexButtonsEnable];
    }
    [self.calcModel changeNumberSystemWithNewSystem:newSystem withCurrentValue:self.resultLabel.text];
    self.waitNextInput = YES;
}

#pragma mark - delegate protocol

- (void)setNewResultOnDisplay:(NSDecimalNumber *)newResult {
    self.resultLabel.text = [self.calcModel.formatterDecimal stringFromNumber:newResult];
}

- (void)setResultExceptionOnDisplay:(NSString *)showDisplayException {
    [self.resultLabel setText:showDisplayException];
}

- (void)setNewResultOnDisplayNotDecimalSystem:(NSString *)newResult {
    self.resultLabel.text = newResult;
}

#pragma mark - buttons enable

- (void)hexButtonsEnable {
    [self.binButtons setValue:@"YES" forKey:@"enabled"];
    [self.octButtons setValue:@"YES" forKey:@"enabled"];
    [self.hexButtons setValue:@"YES" forKey:@"enabled"];
    [self.disableOperation setValue:@"NO" forKey:@"enabled"];
}

- (void)octButtonsEnable {
    [self.binButtons setValue:@"YES" forKey:@"enabled"];
    [self.octButtons setValue:@"YES" forKey:@"enabled"];
    [self.hexButtons setValue:@"NO" forKey:@"enabled"];
    [self.disableOperation setValue:@"NO" forKey:@"enabled"];
}

- (void)binaryButtonsEnable {
    [self.binButtons setValue:@"YES" forKey:@"enabled"];
    [self.octButtons setValue:@"NO" forKey:@"enabled"];
    [self.hexButtons setValue:@"NO" forKey:@"enabled"];
    [self.disableOperation setValue:@"NO" forKey:@"enabled"];
}

- (void)decButtonsEnable {
    [self.binButtons setValue:@"YES" forKey:@"enabled"];
    [self.octButtons setValue:@"YES" forKey:@"enabled"];
    [self.hexButtons setValue:@"NO" forKey:@"enabled"];
    [self.disableOperation setValue:@"YES" forKey:@"enabled"];
    [self.decButtons setValue:@"YES" forKey:@"enabled"];
}

#pragma mark - deallocate

- (void)dealloc {
    [_calcModel release];
    [_resultLabel release];
    [_swipeLeft release];
    [_binButtons release];
    [_octButtons release];
    [_hexButtons release];
    [_decButtons release];
    [_disableOperation release];
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
