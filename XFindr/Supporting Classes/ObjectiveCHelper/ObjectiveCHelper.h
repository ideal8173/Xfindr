//
//  ObjectiveCHelper.h
//  XFindr
//
//  Created by Rajat on 3/30/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ObjectiveCHelper : NSObject

+ (void)gradientView:(UIView *) view withStartColor:(UIColor *) startColor andEndColor:(UIColor *) endColor;
+ (void)gradientView:(UIView *) view withArrayColor:(NSArray <UIColor *> *) arrColor;
+ (void)removeGradientView:(UIView *) view;
+ (double)getFlatDistaneBetweenTwoLatLongs:(CLLocationCoordinate2D) pickupCoord andLong:(CLLocationCoordinate2D) deliveryCoord;
+ (double)honeyCDonvertDirectMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to;
+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D) fromCoord toCoordinate:(CLLocationCoordinate2D) toCoordinate;

@end
