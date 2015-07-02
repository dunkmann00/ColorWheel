//
//  GWColorWheel.m
//  TicTacToe 2
//
//  Created by George Waters on 1/27/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import "GWColorWheel.h"

@interface GWColorWheel ()

@property (strong, nonatomic) UIImage *colorWheelImage;

@end

@implementation GWColorWheel

-(void)awakeFromNib
{
    [super awakeFromNib];
    _brightness = 1.0;
    _saturation = 1.0;
    [self drawColorWheel];
    
    
    //self.backgroundColor = [UIColor blackColor];
    //self.opaque = YES;
}

-(void)setBrightness:(CGFloat)brightness
{
    _brightness = brightness;
    [self drawColorWheel];
}

-(void)setSaturation:(CGFloat)saturation
{
    _saturation = saturation;
    [self drawColorWheel];
}

-(void)setBounds:(CGRect)bounds
{
    BOOL redrawColorwheel = NO;
    if(!CGSizeEqualToSize(self.bounds.size, bounds.size))
        redrawColorwheel = YES;
    
    [super setBounds:bounds];
    
    if(redrawColorwheel)
        [self drawColorWheel];
}

-(void)setFrame:(CGRect)frame
{
    BOOL redrawColorwheel = NO;
    if(!CGSizeEqualToSize(self.frame.size, frame.size))
        redrawColorwheel = YES;
    
    [super setFrame:frame];
    
    if(redrawColorwheel)
        [self drawColorWheel];
}

-(instancetype)initWithType:(GWColorWheelType)type andSize:(CGSize)aSize
{
    self = [self initWithImage:nil];
    if(self)
    {
        CGFloat width = MIN(aSize.width, aSize.height);
        self.frame = CGRectMake(0.0, 0.0, width, width);
        _brightness = 1.0;
        _saturation = 1.0;
        _colorWheelType = type;
        [self drawColorWheel];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:nil highlightedImage:nil];
    return self;
}

-(instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:nil];
    return self;
}

-(void)drawColorWheel
{
    CGImageRef maskImageRef = [self maskImage];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        
    int splices = 360;
    CGFloat radius = self.bounds.size.width / 2.0;
    CGFloat radianAngle = (360.0 / splices) * (M_PI / 180.0);
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.width / 2.0);
    UIBezierPath *splicePath;
    UIColor *spliceColor;
    CGFloat saturation = 1.0;
    CGFloat brightness = 1.0;
    
    if(self.colorWheelType == GWColorWheelSaturation)
        brightness = self.brightness;
    if(self.colorWheelType == GWColorWheelBrightness)
        saturation = self.saturation;
    
    for(int i = 0; i < splices ; i++)
    {
        
        splicePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:(i * radianAngle) endAngle:((i + 2) * radianAngle) clockwise:YES];
        [splicePath addLineToPoint:center];
        [splicePath closePath];
        splicePath.lineWidth = 1.0;
        spliceColor = [UIColor colorWithHue:(1.0 * i)/splices saturation:saturation brightness:brightness alpha:1.0];
        [spliceColor setFill];
        //[spliceColor setStroke]; //By taking these out I save a good amount of time drawing the color wheel
        //[splicePath stroke];     //Some testing showed a little over 50ms. To correct for not stroking I made
        [splicePath fill];         //each splicePath endAngle +2 rather than +1. This creates +1 with stroke look
    }
    
    CGContextClipToMask(UIGraphicsGetCurrentContext(), self.bounds, maskImageRef);
    
    splicePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    brightness = self.colorWheelType == GWColorWheelSaturation ? brightness : 0.0;
    [[UIColor colorWithHue:0.0 saturation:0.0 brightness:brightness alpha:1.0] setFill];
    [splicePath fill];
    
    
    
    self.colorWheelImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.image = self.colorWheelImage;
    
    self.userInteractionEnabled = YES;
}

-(CGImageRef)maskImage
{
    CGGradientRef maskGradient;
    CGColorSpaceRef myColorspace;
    CGFloat locations[2] = { 0.0, 1.0 };
    //CGFloat colors[8] = { 0.0, 0.0, 0.0, 1.0,  // Start color
    //                      1.0, 1.0, 1.0, 0.0}; // End color
    
    CGFloat colors[2] = { 1.0,  // Start color
                          1.0 }; // End color
    
    
    myColorspace = CGColorSpaceCreateDeviceGray();
    maskGradient = CGGradientCreateWithColorComponents (myColorspace, colors, locations, 2);
    
    
    CGContextRef myContext = CGBitmapContextCreate(NULL, self.bounds.size.width * [UIScreen mainScreen].scale, self.bounds.size.height * [UIScreen mainScreen].scale, 8, 0, myColorspace, (CGBitmapInfo)kCGImageAlphaNone);
    
    
    CGPoint startCenter = CGPointMake((self.bounds.size.width * [UIScreen mainScreen].scale) / 2.0, (self.bounds.size.height * [UIScreen mainScreen].scale) / 2.0);
    CGPoint endCenter = CGPointMake((self.bounds.size.width * [UIScreen mainScreen].scale) / 2.0, (self.bounds.size.height * [UIScreen mainScreen].scale) / 2.0);
    
    CGFloat startRadial = 0.0;
    CGFloat endRadial = (self.bounds.size.width * [UIScreen mainScreen].scale) / 2.0;

    CGContextDrawRadialGradient (myContext, maskGradient, startCenter, startRadial, endCenter, endRadial, kCGGradientDrawsAfterEndLocation);
    
    CGImageRef maskImageRef = CGBitmapContextCreateImage(myContext);
    
    CGContextRelease(myContext);
    CGColorSpaceRelease(myColorspace);
    
    return maskImageRef;
}

-(UIColor *)colorAtPoint:(CGPoint)aPoint
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    
    CGPoint referencePoint = CGPointMake(aPoint.x, center.y);
    
    CGFloat opposite = fabs(aPoint.y - referencePoint.y);
    CGFloat adjacent = fabs(center.x - referencePoint.x);
    
    CGFloat referenceAngle = atanf(opposite/adjacent);
    
    if(adjacent == 0.0)
        referenceAngle = M_PI_2;
    
    CGFloat radius = self.bounds.size.width / 2.0;
    
    CGFloat percentOut = distanceBetweenPoints(center, aPoint) / radius;
    
    CGFloat absoluteAngle;
    
    
    if(aPoint.y > center.y)
    {
        if(aPoint.x > center.x)
        {
            //bottomright
            absoluteAngle = referenceAngle;
        }else{
            //bottomleft
            absoluteAngle = (M_PI_2 - referenceAngle) + M_PI_2;
        }
    }else{
        if(aPoint.x > center.x)
        {
            //topright
            absoluteAngle = (M_PI_2 - referenceAngle) + (M_PI_2 * 3.0);
        }else{
            //topleft
            absoluteAngle = referenceAngle + (M_PI_2 * 2.0);
        }
    }
    
    CGFloat saturation = self.saturation;
    CGFloat brightness = self.brightness;
    
    if(self.colorWheelType == GWColorWheelSaturation)
        saturation = percentOut;
    if(self.colorWheelType == GWColorWheelBrightness)
        brightness = percentOut;
    
    UIColor *constructedColor = [UIColor colorWithHue:(absoluteAngle / (2.0 * M_PI)) saturation:saturation brightness:brightness alpha:1.0];
    
    
    return constructedColor;
}

CGFloat distanceBetweenPoints(CGPoint point1, CGPoint point2)
{
    CGFloat xDist = point1.x - point2.x;
    CGFloat yDist = point1.y - point2.y;
    
    CGFloat distance = sqrtf((xDist * xDist) + (yDist * yDist));
    
    return distance;
}

@end
