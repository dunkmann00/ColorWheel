//
//  GWColorWheel.h
//  TicTacToe 2
//
//  Created by George Waters on 1/27/15.
//  Copyright (c) 2015 George Waters. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GWColorWheelType) {
    GWColorWheelSaturation,
    GWColorWheelBrightness
};
/**
 This produces a color wheel that is represented in a view using UIImageView. Generally color wheels represent hue and saturation. In order to represent brightness a separate color selector is needed. This may be inconvenient and not work well with the flow or layout of an app. GWColorWheel will represent either hue and saturation or hue and brightness based on the colorWheelType property. When representing saturation the brightness can be set to a constant value with the brightness property and when representing brightness the saturation can be set to a constant value with the saturation property. This allows for a simple layout of color choices while also providing a more customizable palette.
 */
@interface GWColorWheel : UIImageView
/**
 The type of colors the color wheel represents.
 */
@property (nonatomic) GWColorWheelType colorWheelType;

/**
 The brightness component of the color wheel. The value of this property must be in the range 0.0 to 1.0. The default value of this property is 1.0.
 
 When colorWheelType is GWColorWheelSaturation this value represents the brightness component of every color on the color wheel.  If colorWheelType is GWColorWheelBrightness this value is ignored.
 */
@property (nonatomic) IBInspectable CGFloat brightness;

/**
 The saturation component of the color wheel. The value of this property must be in the range 0.0 to 1.0. The default value of this property is 1.0.
 
 When colorWheelType is GWColorWheelBrightness this value represents the saturation component of every color on the color wheel.  If colorWheelType is GWColorWheelSaturation this value is ignored.
 */
@property (nonatomic) IBInspectable CGFloat saturation;

/**
 @param type The type of color wheel to make.
 @param  aSize The size of the color wheel.
 
 @return An initialized color wheel object.
 
 Returns a color wheel view initialized to a set type and size.
 
 This method creates a color wheel that represents hue and saturation/brightness.  It is also sized to be a perfect circle.  If the size values provided were not the same the smaller of the two is used.
 */
-(instancetype)initWithType:(GWColorWheelType)type andSize:(CGSize)aSize;


/**
 @param aPoint A point in the coordinate system of the color wheel.
 
 @return The color that is at aPoint of the color wheel.
 
 The color from the color wheel at aPoint of the color wheels coordinate system.
 
 */
-(UIColor *)colorAtPoint:(CGPoint)aPoint;

@end
