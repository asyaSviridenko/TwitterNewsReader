//
//  RemoteImage.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "RemoteImage.h"

@interface  RemoteImage ()
@property (nonatomic, assign) BOOL isLoad;
@end

@implementation RemoteImage {
    NSURLConnection *_activeConnection;
	NSMutableData *_connectionData;
    int64_t _expectedSize;
    NSData *_imageData;
}

+ (RemoteImage*)remoteImageWithURL:(NSURL*)url
{
    return [[self alloc] initWithURL:url];
}

- (id)initWithURL:(NSURL*)url
{
	if (self = [super init]) {
        _imageUrl = url;
    }
	return self;
}

- (id)initWithImage:(UIImage*)image
{
	if (self = [super init]) {
        _image = image;
    }
	return self;
}

- (NSData*)imageData
{
    if (_imageData == nil && _image != nil) {
        _imageData = UIImagePNGRepresentation(_image);
    }
    return _imageData;
}

- (void)startLoading
{
	if (_image || _imageData || _activeConnection || !_imageUrl) return;
    
    _isLoading = YES;
    
	NSURLRequest *request = [NSURLRequest requestWithURL:_imageUrl];
    _activeConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	[_activeConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[_activeConnection start];
}

- (void)stopLoading
{
	[_activeConnection cancel];
	_activeConnection = nil;
	_connectionData = nil;
    _isLoading = NO;
}

- (void)clear:(BOOL)full
{
	_image = nil;
	if (full) {
		_imageData = nil;
	}
}

#pragma mark URL Connection Delegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _expectedSize = response.expectedContentLength;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
	if (_connectionData == nil) {
		_connectionData = [[NSMutableData alloc] initWithData:data];
	} else {
		[_connectionData appendData:data];
	}
    
    self.progress = _expectedSize > 0 ? (float)_connectionData.length / (float)_expectedSize : 0;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	_imageData = _connectionData;
	[self stopLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [[UIImage alloc] initWithData:_imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _image = img;
            self.isLoad = YES;
            [_delegate remoteImageDidFinishLoading:self];
        });
    });
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self stopLoading];
	[_delegate remoteImage:self loadingFailedWithError:error];
}

@end
