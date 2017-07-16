#import "ViewController.h"
#import "Constants.h"

typedef NSDecimalNumber *(^ExecuteOperation)(void);

@interface ViewController ()
@property (nonatomic, assign, getter=isWaitNextInput) BOOL waitNextInput;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) CalculatorModel *calcModel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *digitButtons;

@property (weak, nonatomic) IBOutlet UIStackView *stackView1;
@property (weak, nonatomic) IBOutlet UIStackView *stackView2;
@property (weak, nonatomic) IBOutlet UIStackView *stackView3;
@property (weak, nonatomic) IBOutlet UIStackView *stackView4;
@property (weak, nonatomic) IBOutlet UIStackView *stackView5;
@property (weak, nonatomic) IBOutlet UIStackView *stackView6;

@property (weak, nonatomic) IBOutlet UIButton *binButton;
@property (weak, nonatomic) IBOutlet UIButton *octButton;
@property (weak, nonatomic) IBOutlet UIButton *decButton;
@property (weak, nonatomic) IBOutlet UIButton *hexButton;
@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *cButton;
@property (weak, nonatomic) IBOutlet UIButton *dButton;
@property (weak, nonatomic) IBOutlet UIButton *eButton;
@property (weak, nonatomic) IBOutlet UIButton *fButton;
@property (weak, nonatomic) IBOutlet UIButton *sinButton;
@property (weak, nonatomic) IBOutlet UIButton *cosButton;
@property (weak, nonatomic) IBOutlet UIButton *tanButton;
@property (weak, nonatomic) IBOutlet UIButton *ctgButton;
@property (weak, nonatomic) IBOutlet UIButton *piButton;
@property (weak, nonatomic) IBOutlet UIButton *lnButton;
@property (weak, nonatomic) IBOutlet UIButton *dotButton;
@property (weak, nonatomic) IBOutlet UIButton *reverseButton;
@property (weak, nonatomic) IBOutlet UIButton *sqrtButton;
@property (weak, nonatomic) IBOutlet UIButton *modButton;

@property (strong, nonatomic) UIBarButtonItem *beforeItem;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    self.swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeLeft];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(transitionAbout)];
    item.tintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *simpleCalc = [[UIBarButtonItem alloc]initWithTitle:VAKSimpleCalc style:UIBarButtonItemStylePlain target:self action:@selector(changeCalc:)];
    UIBarButtonItem *ingenerCalc = [[UIBarButtonItem alloc]initWithTitle:VAKIngenerCalc style:UIBarButtonItemStylePlain target:self action:@selector(changeCalc:)];
    UIBarButtonItem *notationCalc = [[UIBarButtonItem alloc]initWithTitle:VAKNotationCalc style:UIBarButtonItemStylePlain target:self action:@selector(changeCalc:)];
    simpleCalc.tintColor = [UIColor blueColor];
    ingenerCalc.tintColor = [UIColor blueColor];
    notationCalc.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItems = @[simpleCalc, ingenerCalc, notationCalc];
    [self changeCalc:simpleCalc];
    
    self.calcModel = [[CalculatorModel alloc]init];
    self.calcModel.delegate = self;
    self.waitNextInput = YES;
    [self changeStateNotationButtonsForSystem:VAKSystemDec];
}

- (void)changeCalc:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:VAKSimpleCalc] && ![self.beforeItem isEqual:item]) {
        [self.stackView1 addArrangedSubview:self.reverseButton];
        [self.stackView1 addArrangedSubview:self.modButton];
        
        [self.stackView1 removeArrangedSubview:self.aButton];
        [self.stackView2 removeArrangedSubview:self.bButton];
        [self.stackView3 removeArrangedSubview:self.cButton];
        [self.stackView4 removeArrangedSubview:self.dButton];
        [self.stackView5 removeArrangedSubview:self.eButton];
        [self.stackView1 removeArrangedSubview:self.sqrtButton];
        [self.stackView1 removeArrangedSubview:self.sinButton];
        [self.stackView2 removeArrangedSubview:self.cosButton];
        [self.stackView3 removeArrangedSubview:self.tanButton];
        [self.stackView4 removeArrangedSubview:self.ctgButton];
        [self.stackView5 removeArrangedSubview:self.piButton];
        [self.stackView5 removeArrangedSubview:self.lnButton];
        self.stackView6.hidden = YES;
        
        if (![self.calcModel.currentNumberSystem isEqualToString:VAKSystemDec] && ![self.beforeItem.title isEqualToString:VAKIngenerCalc]) {
            [self changeStateNotationButtonsForSystem:VAKSystemDec];
            [self.calcModel convertAnyNumberSystemToDecimalNumberSystemWithNumber:self.resultLabel.text];
        }
    }
    else if ([item.title isEqualToString:VAKIngenerCalc] && ![self.beforeItem isEqual:item]) {
        [self.stackView1 addArrangedSubview:self.reverseButton];
        [self.stackView1 addArrangedSubview:self.sqrtButton];
        [self.stackView1 addArrangedSubview:self.modButton];
        [self.stackView1 addArrangedSubview:self.sinButton];
        [self.stackView2 addArrangedSubview:self.cosButton];
        [self.stackView3 addArrangedSubview:self.tanButton];
        [self.stackView4 addArrangedSubview:self.ctgButton];
        [self.stackView5 addArrangedSubview:self.piButton];
        [self.stackView5 addArrangedSubview:self.lnButton];
        
        [self.stackView1 removeArrangedSubview:self.aButton];
        [self.stackView2 removeArrangedSubview:self.bButton];
        [self.stackView3 removeArrangedSubview:self.cButton];
        [self.stackView4 removeArrangedSubview:self.dButton];
        [self.stackView5 removeArrangedSubview:self.eButton];
        self.stackView6.hidden = YES;
        
        if (![self.calcModel.currentNumberSystem isEqualToString:VAKSystemDec] && ![self.beforeItem.title isEqualToString:VAKSimpleCalc]) {
            [self changeStateNotationButtonsForSystem:VAKSystemDec];
            [self.calcModel convertAnyNumberSystemToDecimalNumberSystemWithNumber:self.resultLabel.text];
        }
    }
    else if ([item.title isEqualToString:VAKNotationCalc] && ![self.beforeItem isEqual:item]) {
        [self.stackView1 addArrangedSubview:self.aButton];
        [self.stackView2 addArrangedSubview:self.bButton];
        [self.stackView3 addArrangedSubview:self.cButton];
        [self.stackView4 addArrangedSubview:self.dButton];
        [self.stackView5 addArrangedSubview:self.eButton];
        
        [self.stackView1 removeArrangedSubview:self.sinButton];
        [self.stackView1 removeArrangedSubview:self.modButton];
        [self.stackView1 removeArrangedSubview:self.reverseButton];
        [self.stackView1 removeArrangedSubview:self.sqrtButton];
        [self.stackView2 removeArrangedSubview:self.cosButton];
        [self.stackView3 removeArrangedSubview:self.tanButton];
        [self.stackView4 removeArrangedSubview:self.ctgButton];
        [self.stackView5 removeArrangedSubview:self.piButton];
        [self.stackView6 removeArrangedSubview:self.lnButton];
        [self.stackView5 removeArrangedSubview:self.lnButton];
        self.stackView6.hidden = NO;
        
        [self.calcModel convertDecimalNumberSystemToAnyNumberSystemWithNumber:self.resultLabel.text];
    }
    
    [self.beforeItem setTintColor:[UIColor blueColor]];
    self.beforeItem = item;
    [item setTintColor:[UIColor grayColor]];
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

//- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
//
//    if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
//        [self.stackView1 addArrangedSubview:self.binButton];
//        [self.stackView2 addArrangedSubview:self.octButton];
//        [self.stackView3 addArrangedSubview:self.decButton];
//        [self.stackView4 addArrangedSubview:self.hexButton];
//        [self.stackView5 addArrangedSubview:self.fButton];
//        self.stackView6.hidden = true;
//    } else {
//        self.stackView6.hidden = false;
//        [self.stackView6 addArrangedSubview:self.binButton];
//        [self.stackView6 addArrangedSubview:self.octButton];
//        [self.stackView6 addArrangedSubview:self.decButton];
//        [self.stackView6 addArrangedSubview:self.hexButton];
//        [self.stackView6 addArrangedSubview:self.fButton];
//    }
//}

#pragma mark - action

- (void)transitionAbout {
    AboutViewController *aboutView = [[AboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
}

- (IBAction)buttonLicencePressed:(id)sender {
    LicenseViewController *licenseView = [[LicenseViewController alloc]init];
    [self presentViewController:licenseView animated:YES completion:nil];
}

- (IBAction)buttonNumberPressed:(UIButton *)sender {
    NSString *value = [sender titleForState:UIControlStateNormal];
    NSString *result = nil;
    if ([value isEqualToString:VAKPi]) {
        value = [NSString stringWithFormat:@"%f", M_PI];
    }
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
    NSString *operation = [sender titleForState:UIControlStateNormal];
    [self.calcModel addOperation:operation withExecuteBlock:[self returnSelectedExecuteBlockWithName:operation]];
    [self.calcModel unaryOperationWithOperand:(NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text] operation:operation];
    self.waitNextInput = YES;
    [self.calcModel convertDecimalNumberSystemToAnyNumberSystemWithNumber:self.resultLabel.text];    
}

- (IBAction)numberSystemButtonPressed:(UIButton *)sender {
    NSString *newSystem = [sender titleForState:UIControlStateNormal];
    [self changeStateNotationButtonsForSystem:newSystem];
    [self.calcModel changeNumberSystemWithNewSystem:newSystem withCurrentValue:self.resultLabel.text];
    
}

#pragma mark - add new operation

- (ExecuteOperation )returnSelectedExecuteBlockWithName:(NSString *)name {
    ExecuteOperation executeBlock = nil;
    NSDecimalNumber *currentNumber = (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:self.resultLabel.text];
    if ([name isEqualToString:VAKSinOperation]) {
        executeBlock = ^{
            NSString *resultString = [NSString stringWithFormat:@"%f", sin(currentNumber.doubleValue)];
            return (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:resultString];
        };
    }
    else if ([name isEqualToString:VAKCosOperation]) {
        executeBlock = ^{
            NSString *resultString = [NSString stringWithFormat:@"%f", cos(currentNumber.doubleValue)];
            return (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:resultString];
        };
    }
    else if ([name isEqualToString:VAKTanOperation]) {
        executeBlock = ^{
            NSString *resultString = [NSString stringWithFormat:@"%f", tan(currentNumber.doubleValue)];
            return (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:resultString];
        };
    }
    else if ([name isEqualToString:VAKCtgOperation]) {
        executeBlock = ^{
            NSString *resultString = [NSString stringWithFormat:@"%f", 1/tan(currentNumber.doubleValue)];
            return (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:resultString];
        };
    }
    else if ([name isEqualToString:VAKLnOperation]) {
        executeBlock = ^{
            NSString *resultString = [NSString stringWithFormat:@"%f", log(currentNumber.doubleValue)];
            return (NSDecimalNumber *)[self.calcModel.formatterDecimal numberFromString:resultString];
        };
    }
    return executeBlock;
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

- (void)changeStateNotationButtonsForSystem:(NSString *)notation {
    int countDigitsNotation = 0;
    if ([notation isEqualToString:VAKSystemBin]) {
        countDigitsNotation = VAKCountBinaryNumber;
    }
    else if ([notation isEqualToString:VAKSystemDec]) {
        countDigitsNotation = VAKCountDecNumber;
    }
    else if ([notation isEqualToString:VAKSystemHex]) {
        countDigitsNotation = VAKCountHexNumber;
    }
    else {
        countDigitsNotation = VAKCountOctNumber;
    }
    for (int i = 0; i < countDigitsNotation; i++) {
        UIButton *currentButton = self.digitButtons[i];
        [currentButton setValue:@"YES" forKey:@"enabled"];
        [currentButton setTintColor:[UIColor blackColor]];
    }
    for (int i = countDigitsNotation; i < VAKCountHexNumber; i++) {
        UIButton *currentButton = self.digitButtons[i];
        [currentButton setValue:@"NO" forKey:@"enabled"];
        [currentButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    }
}

@end
