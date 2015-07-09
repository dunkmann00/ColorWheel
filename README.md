# ColorWheel
<img src="/Color Wheel/ScreenCapture.gif" align="right">
A simple color wheel UI that can be added to an app.

This produces a color wheel that is represented in a view using UIImageView. Generally color wheels represent hue and saturation. In order to represent brightness a separate color selector is needed. This may be inconvenient and not work well with the flow or layout of an app. GWColorWheel will represent either hue and saturation or hue and brightness based on the colorWheelType property. When representing saturation the brightness can be set to a constant value with the brightness property and when representing brightness the saturation can be set to a constant value with the saturation property. This allows for a simple layout of color choices while also providing a more customizable palette.

The Xcode project in the repository has a working example of the color wheel in use. Tapping or panning over the color wheel will change the selected color banner below.
