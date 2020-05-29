//
//  UIView+IRLSize.m
//  IRLSize
//
//  Created by Jeff Kelley on 11/13/2014.
//  Copyright © 2019 Detroit Labs. All rights reserved.
//

#import "IRLSize.h"

#if SWIFT_PACKAGE
#import "../Private/IRLSizeMacros.h"
#import "../Private/UIDevice+IRLSizePrivate.h"
#else
#import "IRLSizeMacros.h"
#import "UIDevice+IRLSizePrivate.h"
#endif

@implementation UIView (IRLSizePrivate)

- (IRLRawDimensions)irl_rawPhysicalSize
{
    return [UIDevice.currentDevice irl_rawPhysicalSizeOfView:self];
}

- (BOOL)irl_isOnMainScreen
{
    return (self.window.screen == UIScreen.mainScreen);
}

- (BOOL)irl_isOnSecondaryScreen
{
    return (self.window != nil && ![self irl_isOnMainScreen]);
}

@end

@implementation UIView (IRLSize)

- (NSMeasurement<NSUnitLength *> *)irl_physicalWidth
{
    if ([self irl_isOnSecondaryScreen]) {
        return nil;
    }
    
    return IRL_MM(self.irl_rawPhysicalWidth);
}

- (NSMeasurement<NSUnitLength *> *)irl_physicalHeight
{
    if ([self irl_isOnSecondaryScreen]) {
        return nil;
    }
    
    return IRL_MM(self.irl_rawPhysicalHeight);
}

- (IRLRawMillimeters)irl_rawPhysicalWidth
{
    return self.irl_rawPhysicalSize.width;
}

- (IRLRawMillimeters)irl_rawPhysicalHeight
{
    return self.irl_rawPhysicalSize.height;
}

- (CGAffineTransform)irl_transformForPhysicalWidth:(NSMeasurement<NSUnitLength *> *)physicalWidth
{
    NSMeasurement<NSUnitLength *> *currentPhysicalWidth = self.irl_physicalWidth;
    
    if (currentPhysicalWidth == nil || [self irl_isOnSecondaryScreen]) {
        return self.transform;
    }
    
    return [self irl_scaleTransformForTargetMeasurement:physicalWidth
                                     currentMeasurement:currentPhysicalWidth];
}

- (CGAffineTransform)irl_transformForPhysicalHeight:(NSMeasurement<NSUnitLength *> *)physicalHeight
{
    NSMeasurement<NSUnitLength *> *currentPhysicalHeight = self.irl_physicalHeight;
    
    if (currentPhysicalHeight == nil || [self irl_isOnSecondaryScreen]) {
        return self.transform;
    }
    
    return [self irl_scaleTransformForTargetMeasurement:physicalHeight
                                     currentMeasurement:currentPhysicalHeight];
}

- (CGAffineTransform)irl_scaleTransformForTargetMeasurement:(NSMeasurement *)target
                                         currentMeasurement:(NSMeasurement *)current
IRL_IOS_AVAILABLE(10.0)
{
    if ([target canBeConvertedToUnit:current.unit]) {
        NSMeasurement *convertedTarget =
        [target measurementByConvertingToUnit:current.unit];
        
        return [self irl_scaleTransformForTargetRawMeasurement:convertedTarget.doubleValue
                                         currentRawMeasurement:current.doubleValue];
    }
    else {
        return self.transform;
    }
}

- (CGAffineTransform)irl_transformForRawPhysicalWidth:(IRLRawMillimeters)rawPhysicalWidth
{
    if ([self irl_isOnSecondaryScreen]) {
        return self.transform;
    }
    
    IRLRawMillimeters currentValue = self.irl_rawPhysicalWidth;
    
    return [self irl_scaleTransformForTargetRawMeasurement:rawPhysicalWidth
                                     currentRawMeasurement:currentValue];
}

- (CGAffineTransform)irl_transformForRawPhysicalHeight:(IRLRawMillimeters)rawPhysicalHeight
{
    if ([self irl_isOnSecondaryScreen]) {
        return self.transform;
    }
    
    IRLRawMillimeters currentValue = self.irl_rawPhysicalHeight;
    
    return [self irl_scaleTransformForTargetRawMeasurement:rawPhysicalHeight
                                     currentRawMeasurement:currentValue];
}

- (CGAffineTransform)irl_scaleTransformForTargetRawMeasurement:(IRLRawMillimeters)target
                                         currentRawMeasurement:(IRLRawMillimeters)current
{
    double ratio = target / current;
    
    return CGAffineTransformScale(self.transform, ratio, ratio);
}

@end
