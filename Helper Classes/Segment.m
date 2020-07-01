//
//  Segment.m
//  KeyToMedicine
//
//  Created by Manoj on 06/11/17.
//  Copyright © 2017 Apple. All rights reserved.
//

#import "Segment.h"
@implementation Segment

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    

//    for borderview in subviews {
//        let upperBorder: CALayer = CALayer()
//        upperBorder.backgroundColor = UIColor.init(red: 215/255.0, green: 0.0, blue: 30/255.0, alpha: 1.0).cgColor
//        upperBorder.frame = CGRect(x: 0, y: borderview.frame.size.height-1, width: borderview.frame.size.width, height: 1)
//        borderview.layer.addSublayer(upperBorder)
//    }
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    
    [[UILabel appearanceWhenContainedIn:[UISegmentedControl class], nil] setNumberOfLines:0];

    
    [self setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics: UIBarMetricsDefault];
    [self setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setDividerImage:[self imageWithColor:[UIColor whiteColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12.0], NSForegroundColorAttributeName:[self getColor:@"909191" withDefault:[UIColor clearColor]]} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12.0], NSForegroundColorAttributeName:[self getColor:@"909191" withDefault:[UIColor clearColor]]} forState:UIControlStateSelected];
}
//-(void)removeBar
//{
//    UIImage *image = [self getColoredRectImageWith:[UIColor whiteColor] andSize:self.bounds.size];
//    [self setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [self setBackgroundImage:image forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    [self setBackgroundImage:image forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    UIImage *deviderImage = [self getColoredRectImageWith:[UIColor whiteColor] andSize: CGSizeMake(1.0, self.bounds.size.height)];
//    [self setDividerImage:deviderImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//}


-(UIColor *)getColor:(NSString *)strHTMLColor withDefault:(UIColor *)defColor
{
    UIColor *clr = defColor;
    if((strHTMLColor != nil) && (![strHTMLColor isEqualToString:@"-1"]))
    {
        unsigned int lColor;
        [[NSScanner scannerWithString:strHTMLColor] scanHexInt:&lColor];
        //= [strHTMLColor intValue];
        clr = [UIColor colorWithRed:((float)((lColor & 0xFF0000) >> 16))/255.0
                              green:((float)((lColor & 0xFF00) >> 8))/255.0
                               blue:((float)(lColor & 0xFF))/255.0
                              alpha:1.0];
    }
    return clr;
}

-(UIImage *)getColoredRectImageWith:(UIColor *)colorr andSize: (CGSize) size
{
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(graphicsContext, colorr.CGColor);
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    CGContextFillRect(graphicsContext, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 29.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end

