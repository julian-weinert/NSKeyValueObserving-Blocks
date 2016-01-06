//
//  NSObject+NSKeyValueObservingBlocks.h
//
//  Created by Julian Weinert on 06/01/16.
//  Copyright © 2016 Julian Weinert. All rights granted.
//

#import <Foundation/Foundation.h>

typedef void (^NSKeyValueObservingBlock)(_Nonnull id object, NSDictionary<NSString *, id> *_Nonnull change,  void *_Nullable context);

@interface NSObject (NSKeyValueObservingBlocks)

- (void)addObserverBlock:(nonnull NSKeyValueObservingBlock)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
- (void)removeObserverBlock:(nonnull NSKeyValueObservingBlock)observer forKeyPath:(nonnull NSString *)keyPath;
- (void)removeObserverBlocksForKeyPath:(nonnull NSString *)keyPath;

@end
