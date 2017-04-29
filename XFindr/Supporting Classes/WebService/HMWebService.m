//
//  HMWebService.m
//  testWebService
//
//  Created by Honey Maheshwari on 6/8/16.
//  Copyright © 2016 Honey. All rights reserved.
//

#import "HMWebService.h"
#import "UIImage+fixOrientation.h"

@implementation HMWebService

+ (void)createRequestAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters onCompletion:(HMRequestCompletion) completed {
    NSMutableURLRequest * request = [HMWebService createRequest:strUrl methodType:method andHeaderDict:dictHeader andParameterDict:dictParameters];
    [HMWebService getResponseFromUrl:request onCompletion:completed];
}

+ (void)createRequestForImageAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters andImageNameAsKeyAndImageAsItsValue:(NSDictionary<NSString *, UIImage *> *) dictImages onCompletion:(HMRequestCompletion) completed {
    NSMutableURLRequest * request = [HMWebService createRequestForImage:strUrl methodType:method andHeaderDict:dictHeader andParameterDict:dictParameters andImageNameAsKeyAndImageAsItsValue:dictImages];
    [HMWebService getResponseFromUrl:request onCompletion:completed];
}

+ (void)createRequestForNodeJSAndGetResponse:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters onCompletion:(HMRequestCompletion) completed {
    NSMutableURLRequest * request = [HMWebService createRequestForNodeJS:strUrl methodType:method andHeaderDict:dictHeader andParameterDict:dictParameters];
    [HMWebService getResponseFromUrl:request onCompletion:completed];
}

+ (void)getResponseFromUrl:(NSMutableURLRequest *) request onCompletion:(HMRequestCompletion) completed {
    
    //UIApplication.shared.isNetworkActivityIndicatorVisible
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        int success = 0;
        NSString *theReply = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (error == nil) {
            if (data.length > 0 && httpResponse.statusCode == 200) {
                id result = [HMWebService JSON:data];
                if ([HMWebService isObject:result string_1_Array_2_Dictionary_3_Integer_4_Data_5:3] == YES) {
                    NSDictionary *dict = (NSDictionary *) result;
                    success = 1;
                    if (completed) {
                        [HMWebService asynchronousTaskWithCompletion:^{
                            completed(dict, error, theReply);
                        }];
                    }
                }
            }
        }
        if (success == 0) {
            if (completed) {
                [HMWebService asynchronousTaskWithCompletion:^{
                    completed([NSDictionary new], error, theReply);
                }];
            }
        }
    }] resume];
}


+ (NSMutableURLRequest *)createRequest:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters {
    //NSString * strApi = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //let encodedHost = unencodedHost.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
    NSString *strNewApi = strUrl;
    NSData *postData;
    
    if (method == HM_HTTPMethodGET) {
        NSString *strToAdd = @"";
        if (![self containsString:strUrl andStringToFind:@"?"]) {
            strToAdd = @"?";
        }
        NSString *strParamsInString = @"";
        NSString *strAnd = @"&";
        for (NSString *key in dictParameters) {
            strParamsInString = [NSString stringWithFormat:@"%@%@%@%@%@", strParamsInString, strAnd, key, @"=", dictParameters[key]];
        }
        strNewApi = [NSString stringWithFormat:@"%@%@%@", strUrl, strToAdd, strParamsInString];
        NSString *post = [NSString stringWithFormat:@""];
        postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    } else {
        if (dictParameters.count > 0) {
            postData = [HMWebService encodeDictionary:dictParameters];
        } else {
            NSString *post = [NSString stringWithFormat:@""];
            postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        }
    }
    
    //    NSString * strApi = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString * strApi = [strNewApi stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strApi]];
    [request setHTTPMethod:[HMWebService getHttpMethodNameFromHM_HTTPMethod:method]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    if (dictHeader.count > 0) {
        for (NSString *key in dictHeader) {
            [request setValue:[dictHeader objectForKey:key] forHTTPHeaderField:key];
        }
    }
    [request setHTTPBody:postData];
    [request setTimeoutInterval:100.0];
    return request;
}

+ (NSMutableURLRequest *)createRequestForImage:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters andImageNameAsKeyAndImageAsItsValue:(NSDictionary<NSString *, UIImage *> *) dictImages {
    NSString * strApi = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strApi]];
    [request setHTTPMethod:[HMWebService getHttpMethodNameFromHM_HTTPMethod:method]];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary, nil];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    if (dictHeader.count > 0) {
        for (NSString *key in dictHeader) {
            [request setValue:[dictHeader objectForKey:key] forHTTPHeaderField:key];
        }
    }
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *newParams = [NSMutableDictionary new];
    [newParams setObject:@"" forKey:@""];
    [newParams setObject:@"" forKey:@" "];
    [newParams setObject:@"" forKey:@"  "];
    
    for (NSString *key in dictParameters) {
        [newParams setObject:[dictParameters objectForKey:key] forKey:key];
    }
    
    for (NSString *key in newParams) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSASCIIStringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[newParams objectForKey:key]] dataUsingEncoding:NSASCIIStringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSASCIIStringEncoding]];
    }
    if (dictImages.count > 0) {
        for (NSString *key in dictImages) {
            if ([[dictImages objectForKey:key] isKindOfClass:[UIImage class]]) {
                UIImage *img = (UIImage *) [dictImages objectForKey:key];
                NSData *fileData = UIImageJPEGRepresentation([img fixOrientation], 0.6);
                NSString * fileName = @"honey.jpg";
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:fileData];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    if (body.length > 0) {
        [request setHTTPBody:body];
    }
    [request setTimeoutInterval:120.0];
    return request;
}

+ (NSMutableURLRequest *)createRequestForNodeJS:(NSString *) strUrl methodType:(HM_HTTPMethod) method andHeaderDict:(NSDictionary *) dictHeader andParameterDict:(NSDictionary *) dictParameters {
    NSString *strNewUrl = @"";
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictParameters options:NSJSONWritingPrettyPrinted error:&err];
    NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    strNewUrl = [NSString stringWithFormat:@"%@%@", strUrl, datastring];
    NSString *strNewUrl1 = [strNewUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"strNewUrl1 >>>> %@", strNewUrl1);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strNewUrl1]];
    [request setHTTPMethod:[HMWebService getHttpMethodNameFromHM_HTTPMethod:method]];
    if (dictHeader.count > 0) {
        for (NSString *key in dictHeader) {
            [request setValue:[dictHeader objectForKey:key] forHTTPHeaderField:key];
        }
    }
    [request setTimeoutInterval:100.0];
    return request;
}

+ (id)JSON:(NSData *) data {
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
}

+ (NSData *)encodeDictionary:(NSDictionary*) dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
//        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *strObj = [NSString stringWithFormat:@"%@", [dictionary objectForKey:key]];
        NSString *encodedValue = [strObj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

+ (BOOL)isObject:(id) ob string_1_Array_2_Dictionary_3_Integer_4_Data_5:(int) which {
    @try {
        if (ob) {
            if (which == 1) {
                if ([ob isKindOfClass:[NSString class]]) {
                    return YES;
                } else {
                    if ([ob isKindOfClass:[NSMutableString class]])
                        return YES;
                    else
                        return NO;
                }
            } else if (which == 2) {
                if ([ob isKindOfClass:[NSArray class]]) {
                    return YES;
                } else {
                    if ([ob isKindOfClass:[NSMutableArray class]])
                        return YES;
                    else
                        return NO;
                }
            } else if (which == 3) {
                if ([ob isKindOfClass:[NSDictionary class]]) {
                    return YES;
                } else {
                    if ([ob isKindOfClass:[NSMutableDictionary class]])
                        return YES;
                    else
                        return NO;
                }
            } else if (which == 4) {
                if ([ob isKindOfClass:[NSNumber class]]) {
                    return YES;
                } else {
                    return NO;
                }
            } else if (which == 5) {
                if ([ob isKindOfClass:[NSData class]]) {
                    return YES;
                } else {
                    return NO;
                }
            }
        } else {
            return NO;
        }
        return NO;
    } @catch (NSException *exception) {
        return NO;
    }
}

+ (NSString *)getHttpMethodNameFromHM_HTTPMethod:(HM_HTTPMethod) method {
    if (method == HM_HTTPMethodGET) {
        return @"GET";
    } else if (method == HM_HTTPMethodPOST) {
        return @"POST";
    } else if (method == HM_HTTPMethodPUT) {
        return @"PUT";
    } else {
        return @"POST";
    }
}

+ (void)asynchronousTaskWithCompletion:(void (^)(void))completion; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

+ (BOOL)containsString:(NSString *)mainString andStringToFind:(NSString *) subString {
    NSRange range = [mainString rangeOfString : subString];
    BOOL found = (range.location != NSNotFound);
    return found;
}

+ (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage {
    CIContext *cicontext = [CIContext contextWithOptions:nil];
    // finally!
    UIImage * returnImage;
    
    CGImageRef processedCGImage = [cicontext createCGImage:ciImage fromRect:[ciImage extent]];
    
    returnImage = [UIImage imageWithCGImage:processedCGImage];
    CGImageRelease(processedCGImage);
    return returnImage;
}

+ (UIImage *)UIImageFromCIImage:(CIImage *)ciImage {
    CGSize size = ciImage.extent.size;
    UIGraphicsBeginImageContext(size);
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size   = size;
    UIImage *remImage = [UIImage imageWithCIImage:ciImage];
    [remImage drawInRect:rect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    remImage = nil;
    ciImage = nil;
    //
    return result;
}

+ (NSDictionary<NSString *, id> *)getDictionaryFromResponseObject:(id) responseObject {
    if ([HMWebService isObject:responseObject string_1_Array_2_Dictionary_3_Integer_4_Data_5:3]) {
        NSDictionary *dict = responseObject;
        if (dict) {
            return dict;
        }
    } else if ([HMWebService isObject:responseObject string_1_Array_2_Dictionary_3_Integer_4_Data_5:1]) {
        NSString *str = [NSString stringWithFormat:@"%@", responseObject];
        if (str) {
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * response;
            NSError * err1;
            if(data != nil){
                response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err1];
                if (response != nil) {
                    return response;
                }
            }
        }
    } else if ([HMWebService isObject:responseObject string_1_Array_2_Dictionary_3_Integer_4_Data_5:5]) {
        NSData *data = (NSData *)responseObject;
        NSDictionary * response;
        NSError * err1;
        if(data != nil){
            response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err1];
            if (response != nil) {
                return response;
            }
        }
    }
    
    return [NSDictionary new];
}

@end
