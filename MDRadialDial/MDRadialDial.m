/**
 * @file MDRadialDial.m
 * @author Michael Diakonov
 * @version 1.0
 *
 * @section LICENSE
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Michael Diakonov
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "MDRadialDial.h"
#import "Common.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kRadianAnglePadding DEGREES_TO_RADIANS(90)
#define kLinePadding 4

@interface MDRadialDial ()

@property (assign) double initialValue;
@property (assign) double angleInRadians;
@property (assign) int lineWidth;

@end

@implementation MDRadialDial

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MDRadialDialDelegate>)delegate initialValue:(double)initialValue{
    
    CGSize size = kMDRadialDialExtraSmallSize;
    
    if((frame.size.width != frame.size.height) || (frame.size.width <  size.width))
        frame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
    
    self = [super initWithFrame:frame];
    if(!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    _delegate = delegate;
    _initialValue  = initialValue <= 1.0 ? initialValue : 0.0;
    _lineWidth = (self.frame.size.width / 50) + kLinePadding;
    
    _angleInRadians = DEGREES_TO_RADIANS(_initialValue);
    
    return self;
    
}

- (instancetype)init{
    
    CGSize size = kMDRadialDialDefaultSize;
    return [self initWithFrame:CGRectMake(5, 5, size.width, size.height) delegate:nil initialValue:0];
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    CGRect frame = self.bounds;
    
    //Create and save context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //Draw glow holder circle i.e. circle below the glow
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth, 0, 2 * M_PI, 1);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetRGBStrokeColor(ctx, .375, .375, .375, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth , 0, 2 * M_PI, 1);
    CGContextSetLineWidth(ctx, _lineWidth/2);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    [[UIColor whiteColor] setStroke];
    CGContextSetAlpha(ctx, 0.025f);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Restore and re-save the clean context state
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    double startLoc = kRadianAnglePadding;
    double endLoc = _angleInRadians + kRadianAnglePadding;
    
    //Draw glow circle
    //CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth , 0, 2 * M_PI, 1);
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth ,startLoc , endLoc, 0); //Test
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetRGBStrokeColor(ctx, 124/255.0, 252/255.0, 0/255.0, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Draw glow effect
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 5.0f, [UIColor greenColor].CGColor);
    //CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth , 0, 2 * M_PI, 1);
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - _lineWidth , startLoc, endLoc, 0); //Test
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetRGBStrokeColor(ctx, 124/255.0, 252/255.0, 0/255.0, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Restore and re-save the clean context state
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);

    //Draw dial and shadow
    CGContextSetShadow(ctx, CGSizeMake(8, 10), 14.0f);
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.height/2 - (_lineWidth + (_lineWidth / 2)) , 0, 2 * M_PI, 1);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    [[UIColor grayColor] setFill];
    CGContextDrawPath(ctx, kCGPathFill);
    
    //Restore and re-save the clean context state
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);

    //Draw dial outline
    CGContextAddArc(ctx, frame.size.width/2, frame.size.height/2, frame.size.height/2 - (_lineWidth + (_lineWidth / 2)) , 0, 2 * M_PI, 1);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    [[UIColor blackColor] setStroke];
    CGContextSetAlpha(ctx, 0.06f);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Restore and re-save the clean context state
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    
    //Draw dial indicator
    int dialWidth = frame.size.width/10;
    float dialDistance = frame.size.width/3.5;
    CGContextAddArc(ctx, frame.size.width / 2 + (dialDistance * cos(_angleInRadians+1.5707)), frame.size.height/2+(dialDistance*sin(_angleInRadians+1.5707)), dialWidth , 0, 2 * M_PI, 1);
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetRGBFillColor(ctx, .456, .456, .456, 1.0);
    CGContextDrawPath(ctx, kCGPathFill);
    
    //Create clipping mask for radial gradient
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef maskCtx = UIGraphicsGetCurrentContext();
    
    CGContextSetShadow(maskCtx, CGSizeMake(8, 10), 10.0f);
    CGContextAddArc(maskCtx, frame.size.width/2, frame.size.height/2, frame.size.width/2 - (_lineWidth + (_lineWidth / 2)), 0, 2 * M_PI, 1);
    CGContextSetLineWidth(maskCtx, _lineWidth);
    CGContextSetLineCap(maskCtx, kCGLineCapButt);
    [[UIColor redColor] setFill];
    CGContextDrawPath(maskCtx, kCGPathFill);
    
    CGImageRef mask = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
    UIGraphicsEndImageContext();
    
    //Clip context
    CGContextClipToMask(ctx, self.bounds, mask);
    CGImageRelease(mask);
    
    //Apply radial gradient to dial
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {
                            1.0,1.0,1.0,0.1,
                            1.0,1.0,1.0,0.02
                           };
    
    CGFloat locations[] = {0.0,0.25,0.5,0.75,1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGPoint startPoint = CGPointMake(_lineWidth, _lineWidth);
    CGPoint endPoint = CGPointMake(_lineWidth, _lineWidth);
    CGContextDrawRadialGradient(ctx, gradient, startPoint, 1, endPoint, frame.size.width/2 + frame.size.width / 8, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //Restore and re-save the clean context state
    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);

    
}

//-----------------------------------------------
#pragma mark - UIControl Tracking touch methods
//-----------------------------------------------

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    return YES;
    
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint touchLocation = [touch locationInView:self];
    
    CGRect frame = self.bounds;
    
    
    double dy = (touchLocation.y - frame.size.height / 2);
    double dx = -(touchLocation.x - frame.size.width / 2);
   
    double theta = atan2(dy, dx);
   
    double angle = (int)(90 - ((theta * 180) / M_PI)) % 360;
    
    _angleInRadians = DEGREES_TO_RADIANS(angle);
    
    [self setNeedsDisplay];
    
    return YES;
    
}

- (void)endTrackingWithTouch:(UITouch *)touches withEvent:(UIEvent *)event{
    
    [super endTrackingWithTouch:touches withEvent:event];
    
    CGPoint touchLocation = [touches locationInView:self];
    
}

@end
