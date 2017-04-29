//
//  HMWebService.h
//  testWebService
//
//  Created by Honey Maheshwari on 6/8/16.
//  Copyright © 2016 Honey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HM_HTTPMethod) {
    HM_HTTPMethodGET,
    HM_HTTPMethodPOST,
    HM_HTTPMethodPUT
};

typedef void(^HMRequestCompletion)(NSDictionary<NSString *, id> *dictResponse, NSError *error, NSString *theReply);

@interface HMWebService : NSObject

+ (NSData *)encodeDictionary:(NSDictionary*) dictionary;
+ (void)createRequestAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters onCompletion:(HMRequestCompletion) completed;
+ (void)createRequestForImageAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters andImageNameAsKeyAndImageAsItsValue:(NSDictionary<NSString *, UIImage *> *) dictImages onCompletion:(HMRequestCompletion) completed;
+ (void)createRequestForNodeJSAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters onCompletion:(HMRequestCompletion) completed;
+ (NSDictionary<NSString *, id> *)getDictionaryFromResponseObject:(id) responseObject;
@end
