//
//  ObjectiveCHelper.m
//  XFindr
//
//  Created by Rajat on 3/30/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

#import "ObjectiveCHelper.h"

static const double kDegreesToRadians = M_PI / 180.0;

@implementation ObjectiveCHelper

+ (void)gradientView:(UIView *) view withStartColor:(UIColor *) startColor andEndColor:(UIColor *) endColor {
    view.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    UIColor *topColor = startColor;
    UIColor *bottomColor = endColor;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
}

+ (void)gradientView:(UIView *) view withArrayColor:(NSArray <UIColor *> *) arrColor {
    view.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.2);
    gradient.endPoint = CGPointMake(1.0, 0.2);
    NSMutableArray * colors = [NSMutableArray new];
    for (UIColor *color in arrColor) {
        [colors addObject:(id)[color CGColor]];
    }
    gradient.colors = colors;
    UIView *tagView = [view viewWithTag:78542369];
    if (tagView != nil) {
        [tagView removeFromSuperview];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.bounds];
    [imgView.layer insertSublayer:gradient atIndex:0];
    imgView.tag = 78542369;
    /*
     CAGradientLayer *gradient2 = (CAGradientLayer *)imgView.layer.sublayers[0];
     NSLog(@"gradient2 >>>>> %@", gradient2.colors);
     */
    [view addSubview:imgView];
    //[view.layer insertSublayer:gradient atIndex:0];
}

+ (void)removeGradientView:(UIView *) view {
    UIView *tagView = [view viewWithTag:78542369];
    if (tagView != nil) {
        [tagView removeFromSuperview];
    }
}

+ (double)getFlatDistaneBetweenTwoLatLongs:(CLLocationCoordinate2D) pickupCoord andLong:(CLLocationCoordinate2D) deliveryCoord {
    CLLocation *pickupLocation, *deliveryLocation;
    pickupLocation = [[CLLocation alloc] initWithLatitude:pickupCoord.latitude longitude:pickupCoord.longitude];
    deliveryLocation = [[CLLocation alloc] initWithLatitude:deliveryCoord.latitude longitude:deliveryCoord.longitude];
    CLLocationDistance distance = [pickupLocation distanceFromLocation:deliveryLocation];
    double distanceInMeters = distance;
    NSLog(@"distance =========> %f", distance);
    return distanceInMeters;
}

+ (double)honeyCDonvertDirectMetersFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to {
    static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
    static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
    double latitudeArc  = (from.latitude - to.latitude) * DEG_TO_RAD;
    double longitudeArc = (from.longitude - to.longitude) * DEG_TO_RAD;
    double latitudeH = sin(latitudeArc * 0.5);
    latitudeH *= latitudeH;
    double lontitudeH = sin(longitudeArc * 0.5);
    lontitudeH *= lontitudeH;
    double tmp = cos(from.latitude*DEG_TO_RAD) * cos(to.latitude*DEG_TO_RAD);
    return EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));
}


+ (CLLocationDistance)distanceFromCoordinate:(CLLocationCoordinate2D) fromCoord toCoordinate:(CLLocationCoordinate2D) toCoordinate {
    double earthRadius = 6371.01; // Earth's radius in Kilometers
    
    // Get the difference between our two points then convert the difference into radians
    double nDLat = (fromCoord.latitude - toCoordinate.latitude) * kDegreesToRadians;
    double nDLon = (fromCoord.longitude - toCoordinate.longitude) * kDegreesToRadians;
    
    double fromLat =  toCoordinate.latitude * kDegreesToRadians;
    double toLat =  fromCoord.latitude * kDegreesToRadians;
    
    double nA = pow ( sin(nDLat/2), 2 ) + cos(fromLat) * cos(toLat) * pow ( sin(nDLon/2), 2 );
    
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = earthRadius * nC;
    // 1 KM == 0.621371 Miles
    
    return nD * 1000; // Return our calculated distance in meters
}

@end
