//
//  SFScrollableNumberAnimatedView.h
//  ECalendar-Pro
//
//  Created by Fernando on 2018/4/8.
//  Copyright © 2018年 etouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFScrollableNumberAnimatedView : UIView

/**
 The number to be displayed
 */
@property (nonatomic, strong) NSNumber *value;


@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont  *font;

/**
 * number scroll animation max duration
 *
 * default value is 2.f;
 */
@property (nonatomic, assign) CFTimeInterval maxDuration;

/**
 * time interval between two adjacent digits
 *
 * @attention If the value is too large, this value may fail
 *
 * default value is 0.2f
 */
@property (nonatomic, assign) CFTimeInterval durationOffset;

/**
 * scroll density
 * default value is 5
 */
@property (nonatomic, assign) NSUInteger density;

/**
 * minimum digits of displaying number
 *
 * e.g. if minLength is 5 , 234 will be display just like 00234
 */
@property (nonatomic, assign) NSUInteger minLength;

/**
 * the padding between two adjacent digits
 *
 * default value is 0.f
 */
@property (nonatomic, assign) NSUInteger numberPadding;

/**
 * The number of digits after the decimal point
 *
 * @attention: This value is valid only when the displayed number is a floating-point type
 */
@property (assign, nonatomic) NSUInteger decimalPlaces;

/**
 * The scroll order of each digit
 */
@property (nonatomic, assign) BOOL isAscending;



/**
 * The width callback when the value setted
 */
@property (nonatomic, copy) void(^widthChangedBlock)(CGFloat width);




/**
 * This method is called after the value is setted
 */
- (void)startAnimation;

/**
 * This method need to be manually called
 */
- (void)stopAnimation;

@end
