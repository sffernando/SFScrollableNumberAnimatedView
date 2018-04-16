//
//  SFScrollableNumberAnimatedView.m
//  ECalendar-Pro
//
//  Created by Fernando on 2018/4/8.
//  Copyright © 2018年 etouch. All rights reserved.
//

#import "SFScrollableNumberAnimatedView.h"

NSString *const kSFScrollAnimationKey               = @"SFScrollableNumberAnimatedView";
NSString *const kSFScrollPointDigitLayerNameKey     = @"point_digit_layer";
NSString *const kSFScrollNegativeSymbolLayerNameKey = @"negative_symbol_layer";

@interface SFScrollableNumberAnimatedView() {
    NSMutableArray *numbersText;
    NSMutableArray *scrollLayers;
    NSMutableArray *scrollLabels;
}

@end

@implementation SFScrollableNumberAnimatedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self generateDefaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self generateDefaultValues];
    }
    return self;
}

- (void)generateDefaultValues
{
    self.maxDuration = 1.5;
    self.durationOffset = .2;
    self.density = 5;
    self.minLength = 0;
    self.isAscending = NO;
    self.numberPadding = 0;
    self.decimalPlaces = 2;
    
    self.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.textColor = [UIColor blackColor];
    
    numbersText  = [NSMutableArray array];
    scrollLayers = [NSMutableArray array];
    scrollLabels = [NSMutableArray array];
}

- (void)setValue:(NSNumber *)value
{
    _value = value;
    [self prepareAnimations];
}

- (void)startAnimation
{
    if (!self.value) {
        return;
    }
    [self stopAnimation];
    [self prepareAnimations];
    [self createAnimations];
}

- (void)stopAnimation
{
    for(CALayer *layer in scrollLayers){
        if ([layer animationForKey:kSFScrollAnimationKey]) {
            [layer removeAnimationForKey:kSFScrollAnimationKey];
        }
    }
}

- (void)prepareAnimations
{
    for(CALayer *layer in scrollLayers){
        [layer removeFromSuperlayer];
    }
    
    [numbersText  removeAllObjects];
    [scrollLayers removeAllObjects];
    [scrollLabels removeAllObjects];
    
    [self createNumbersText];
    [self createScrollLayers];
}

- (void)createNumbersText
{
    NSString * textValue = @"";
    
    if ([self valueIsInteger]) {
        textValue = [NSString stringWithFormat:@"%zd",self.value.integerValue];
    } else {
        NSString *formatString = [NSString stringWithFormat:@"%%.%zdf", self.decimalPlaces];
        textValue = [NSString stringWithFormat:formatString, self.value.doubleValue];
    }
    
    if ([self valueIsNegetive]) {
        if ([textValue rangeOfString:@"-"].location != NSNotFound) {
            textValue = [textValue stringByReplacingCharactersInRange:[textValue rangeOfString:@"-"] withString:@""];
        }
    }
    
    for(NSInteger i = 0; i < (NSInteger)self.minLength - (NSInteger)[textValue length]; ++i){
        [numbersText addObject:@"0"];
    }
    
    for(NSUInteger i = 0; i < [textValue length]; ++i){
        if ([textValue substringWithRange:NSMakeRange(i, 1)]) {
            [numbersText addObject:[textValue substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    if ([self valueIsNegetive]) {
        if (numbersText.count > 0) {
            [numbersText insertObject:@"-" atIndex:0];
        }
    }
    
    CGSize size = [@"0" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.font}
                                     context:nil].size;
    if (self.widthChangedBlock) {
        CGFloat width = [numbersText count] * roundf(size.width) + (self.numberPadding * ([numbersText count] - 1));
        self.widthChangedBlock(width);
    }
}

- (BOOL)valueIsInteger {
    
    if (![self.value isKindOfClass:[NSNumber class]]) {
        self.value = nil;
    }
    
    if (!self.value) {
        self.value = @(0);
        return YES;
    }
    
    CFNumberRef numberRef = (__bridge CFNumberRef)(self.value);
    if (CFNumberIsFloatType(numberRef)) {
        return NO;
    }
    return YES;
}

- (BOOL)valueIsNegetive {
    if ([self valueIsInteger]) {
        return [self.value integerValue] < 0;
    } else {
        return [self.value doubleValue] < 0;
    }
}


- (void)createScrollLayers
{
    CGFloat width = roundf((CGRectGetWidth(self.frame) - (numbersText.count - 1) * self.numberPadding) / numbersText.count);
    CGFloat height = CGRectGetHeight(self.frame);
    
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = [CAScrollLayer layer];
        layer.frame = CGRectMake(roundf(i * (width + self.numberPadding)), 0, width, height);
        NSString *numberText = numbersText[i];
        if ([numberText isEqualToString:@"."]) {
            layer.name = kSFScrollPointDigitLayerNameKey;
        } else if ([numberText isEqualToString:@"-"]){
            layer.name = kSFScrollNegativeSymbolLayerNameKey;
        } else {
            layer.name = nil;
        }
        
        [scrollLayers addObject:layer];
        [self.layer addSublayer:layer];
    }
    
    for(NSUInteger i = 0; i < numbersText.count; ++i){
        CAScrollLayer *layer = (i < scrollLayers.count) ? scrollLayers[i] : nil;
        NSString *numberText = (i < numbersText.count) ? numbersText[i] : nil;
        if (layer && numberText) {
            [self createContentForLayer:layer withNumberText:numberText];
        }
    }
}

- (void)createContentForLayer:(CAScrollLayer *)scrollLayer withNumberText:(NSString *)numberText
{
    NSInteger number = [numberText integerValue];
    NSMutableArray *textForScroll = [NSMutableArray new];
    
    if (![numberText isEqualToString:@"."] && ![numberText isEqualToString:@"-"]) {
        for(NSUInteger i = 0; i < self.density + 1; ++i){
            [textForScroll addObject:[NSString stringWithFormat:@"%lu", (number + i) % 10]];
        }
    }
    
    [textForScroll addObject:numberText];
    
    if(!self.isAscending){
        textForScroll = [[[textForScroll reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    CGFloat height = 0;
    for(NSString *text in textForScroll){
        UILabel * textLabel = [self createLabel:text];
        textLabel.frame = CGRectMake(0, height, CGRectGetWidth(scrollLayer.frame), CGRectGetHeight(scrollLayer.frame));
        [scrollLayer addSublayer:textLabel.layer];
        [scrollLabels addObject:textLabel];
        height = CGRectGetMaxY(textLabel.frame);
    }
}

- (UILabel *)createLabel:(NSString *)text
{
    UILabel *view = [UILabel new];
    
    view.textColor = self.textColor;
    view.font = self.font;
    view.textAlignment = NSTextAlignmentCenter;
    
    view.text = text;
    
    return view;
}

- (void)createAnimations
{
    CFTimeInterval duration = self.maxDuration - ([numbersText count] * self.durationOffset);
    if (duration <= 0) {
        duration = self.durationOffset;
    }
    CFTimeInterval offset = 0;
    
    for(CALayer *scrollLayer in scrollLayers){
        
        CGFloat animationDuration = duration + offset;
        if (self.maxDuration > 0 && animationDuration > self.maxDuration) {
            animationDuration = self.maxDuration;
        }
        
        CGFloat maxY = [[scrollLayer.sublayers lastObject] frame].origin.y;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.y"];
        animation.duration = animationDuration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        if(self.isAscending){
            animation.fromValue = [NSNumber numberWithFloat:-maxY];
            animation.toValue = @0;
        }
        else{
            animation.fromValue = @0;
            animation.toValue = [NSNumber numberWithFloat:-maxY];
        }
        
        if (![scrollLayer.name isEqualToString:kSFScrollPointDigitLayerNameKey] && ![scrollLayer.name isEqualToString:kSFScrollPointDigitLayerNameKey]) {
            [scrollLayer addAnimation:animation forKey:kSFScrollAnimationKey];
        }
        offset += self.durationOffset;
    }
}

@end
