//
//  ViewController.h
//  Calculator
//
//  Created by melanu on 11.05.17.
//  Copyright © 2017 melanu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "LicenseViewController.h"
#import "CalculatorModel.h"
#import "ChangedResultDelegate.h"
#import "SystemProtocol.h"
#import "BinarySystem.h"
#import "OctSystem.h"
#import "HexSystem.h"

@interface ViewController : UIViewController <ChangedResultDelegate>

@end

