//
//  IRLViewController.m
//  IRLSizeExample
//
//  Created by Jeff Kelley on 11/13/2014.
//  Copyright © 2017 Detroit Labs. All rights reserved.
//

#import "IRLViewController.h"

#import <IRLSize/IRLSize.h>

#import "IRLSizeExample-Swift.h"

@interface IRLViewController ()

@property (assign) BOOL didTransformRuler;

@property (nullable, weak, nonatomic) UIView *rulerView;

@property (nullable, weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (nullable, weak, nonatomic) IBOutlet UILabel *heightLabel;

@end


@implementation IRLViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (@available(iOS 10.0, *)) {
        RulerView *rulerView = [[RulerView alloc] init];
        
        rulerView.backgroundColor = UIColor.whiteColor;
        rulerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIVisualEffectView *vibrancyEffectView =
        [[UIVisualEffectView alloc] initWithEffect:
         [UIVibrancyEffect effectForBlurEffect:blurEffect]];
        
        vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [vibrancyEffectView.contentView addSubview:rulerView];
        [blurEffectView.contentView addSubview:vibrancyEffectView];
        [self.view addSubview:blurEffectView];
        
        [rulerView.leadingAnchor constraintEqualToAnchor:vibrancyEffectView.leadingAnchor].active = YES;
        [rulerView.trailingAnchor constraintEqualToAnchor:vibrancyEffectView.trailingAnchor].active = YES;
        [rulerView.topAnchor constraintEqualToAnchor:vibrancyEffectView.topAnchor].active = YES;
        [rulerView.bottomAnchor constraintEqualToAnchor:vibrancyEffectView.bottomAnchor].active = YES;
        
        [vibrancyEffectView.leadingAnchor constraintEqualToAnchor:blurEffectView.leadingAnchor].active = YES;
        [vibrancyEffectView.trailingAnchor constraintEqualToAnchor:blurEffectView.trailingAnchor].active = YES;
        [vibrancyEffectView.topAnchor constraintEqualToAnchor:blurEffectView.topAnchor].active = YES;
        [vibrancyEffectView.bottomAnchor constraintEqualToAnchor:blurEffectView.bottomAnchor].active = YES;
        
        [blurEffectView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [blurEffectView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
        [blurEffectView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [blurEffectView.heightAnchor constraintEqualToConstant:128.0f].active = YES;
        
        if (@available(iOS 11.0, *)) {
            [self.heightLabel.topAnchor
             constraintGreaterThanOrEqualToSystemSpacingBelowAnchor:blurEffectView.bottomAnchor
             multiplier:0.0f].active = YES;
        } else {
            [self.heightLabel.topAnchor constraintGreaterThanOrEqualToAnchor:blurEffectView.bottomAnchor
                                                                    constant:8.0f].active = YES;
        }
        
        self.rulerView = rulerView;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self configureLabels];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    [self.rulerView setNeedsDisplay];
}

- (void)viewDidLayoutSubviews
{
    [self configureLabels];
}

- (void)configureLabels
{
    if (@available(iOS 10.0, *)) {
        NSMeasurementFormatter *formatter = [[NSMeasurementFormatter alloc] init];
        formatter.unitOptions = NSMeasurementFormatterUnitOptionsProvidedUnit;
        formatter.numberFormatter.maximumFractionDigits = 1;
        
        NSUnitLength *lengthUnitToDisplay;
        
        if ([[NSLocale currentLocale] usesMetricSystem]) {
            lengthUnitToDisplay = [NSUnitLength centimeters];
        }
        else {
            lengthUnitToDisplay = [NSUnitLength inches];
        }
        
        self.widthLabel.text = [formatter stringFromMeasurement:
                                [[self.view irl_physicalWidth]
                                 measurementByConvertingToUnit:lengthUnitToDisplay]];
        
        self.heightLabel.text = [formatter stringFromMeasurement:
                                 [[self.view irl_physicalHeight]
                                  measurementByConvertingToUnit:lengthUnitToDisplay]];
    } else {
        self.widthLabel.text = [NSString stringWithFormat:@"%.2f m",
                                self.view.irl_rawPhysicalWidth];
        
        self.heightLabel.text = [NSString stringWithFormat:@"%.2f m",
                                 self.view.irl_rawPhysicalHeight];
    }
    
}

@end
