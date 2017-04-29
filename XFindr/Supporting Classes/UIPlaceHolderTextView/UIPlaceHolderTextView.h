//
//  UIPlaceHolderTextView.h
//  mindpeer-mobile2
//
//  Created by John Qian on 4/1/15.
//  Copyright (c) 2015 John Qian. All rights reserved.
//

#ifndef mindpeer_mobile2_UIPlaceHolderTextView_h
#define mindpeer_mobile2_UIPlaceHolderTextView_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

#endif
