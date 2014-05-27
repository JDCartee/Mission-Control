//
//  ConnectionManager.m
//  Mission-Control
//
//  Created by JEREMY CARTEE on 9/5/13.
//  Copyright (c) 2013 JEREMY CARTEE. All rights reserved.
//

#import "ConnectionManager.h"

const float defaultTimeout =        10.0f;

@implementation ConnectionManager

- (id)initWithURL:(NSString *)initURL
{
    self = [super init];

    if (self)
    {
        self.url = [NSURL URLWithString:initURL];
        self.connectionTimeout = defaultTimeout;
    }
    
    return self;
}

- (id)init
{
    return [self initWithURL:@""];
}

#pragma mark - Connection builders

- (NSMutableURLRequest *)buildGetRequestWithHeaders:(NSMutableDictionary *)headers
                                        andHttpBody:(NSString  *)body
{
    if (self.url)
    {
        NSMutableURLRequest *request =
            [NSMutableURLRequest requestWithURL:self.url
                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                timeoutInterval:self.connectionTimeout];
        NSEnumerator *enumerator = [headers keyEnumerator];
        for(NSString *aKey in enumerator)
        {
            NSString *header = [headers objectForKey:aKey];
            [request addValue:header
           forHTTPHeaderField:aKey];
        }
        enumerator = nil;
        NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody:bodyData];
        [request setHTTPShouldHandleCookies:NO];
        bodyData = nil;
        return request;
    }
    else
    {
        return nil;
    }
}

- (void)connectGetWithHeaders:(NSMutableDictionary *)headers
                  andHttpBody:(NSString *)body
{
    NSURLConnection *connection;
    NSMutableURLRequest *request = [self buildGetRequestWithHeaders:headers
                                                        andHttpBody:body];
    
    if (request)
    {
        connection = [[NSURLConnection alloc] initWithRequest:request
                                                     delegate:self
                                             startImmediately:YES];
    }
    request = nil;
}

- (void)connectWithGetByAppendingToURL:(NSString *)urlSuffix
{
    NSString *urlString =[self.url absoluteString];
    urlString = [urlString stringByAppendingString:urlSuffix];
    self.url = [NSURL URLWithString:urlString];
    [self connectGetWithHeaders:nil
                    andHttpBody:nil];
}

- (void)connectWithGetToURL:(NSString *)URL
                byAppending:(NSString *)urlSuffix
{
    NSString *urlString = [URL stringByAppendingString:urlSuffix];
    self.url = [NSURL URLWithString:urlString];
    [self connectGetWithHeaders:nil
                    andHttpBody:nil];
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection *)conn
    didReceiveData:(NSData *)data
{
    if (!self.returnData)
    {
        self.returnData = [[NSMutableData alloc] init];
    }
    
    // Append data as it comes in from the server
    [self.returnData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Process_Connection_Data
                                                        object:self
                                                      userInfo:nil];
    conn = nil;
}

- (void)connection:(NSURLConnection *)conn
  didFailWithError:(NSError *)error
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:Connection_Error
                                                        object:self
                                                      userInfo:nil];
    self.returnData = nil;
    conn = nil;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = (int)[((NSHTTPURLResponse *)response) statusCode];
        if (statusCode == 404)
        {
            // stop the connection
            [connection cancel];
            connection = nil;
            self.returnData = nil;
        }
    }
}


@end
