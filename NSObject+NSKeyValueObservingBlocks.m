//
//  NSObject+NSKeyValueObservingBlocks.m
//
//  Created by Julian Weinert on 06/01/16.
//  Copyright © 2016 Julian Weinert. All rights granted.
//

#import "NSObject+NSKeyValueObservingBlocks.h"
#import <objc/runtime.h>

@implementation NSObject (NSKeyValueObservingBlocks)

- (NSMutableDictionary *)observers {
    NSMutableDictionary *observers = objc_getAssociatedObject(self, "observers");
    
    if (!observers) {
        observers = [NSMutableDictionary dictionary];
        [self setObservers:observers];
    }
    
    return observers;
}

- (void)setObservers:(NSMutableDictionary *)observers {
    objc_setAssociatedObject(self, "observers", observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSKeyValueObservingBlock> *)observersForName:(NSString *)name {
    return [[self observers] objectForKey:name];
}

- (void)addObserverBlock:(NSKeyValueObservingBlock)observer forKeyPath:(nonnull NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    NSMutableArray *observersForKeyPath = [[self observers] objectForKey:keyPath];
    
    if (!observersForKeyPath) {
        observersForKeyPath = [NSMutableArray array];
        [[self observers] setObject:observersForKeyPath forKey:keyPath];
    }
    
    [observersForKeyPath addObject:observer];
    
    @try {
        [self removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {}
    
    [self addObserver:self forKeyPath:keyPath options:options context:context];
}

- (void)removeObserverBlock:(NSKeyValueObservingBlock)observer forKeyPath:(NSString *)keyPath {
    NSMutableArray *oberversForKeyPath = [[self observers] objectForKey:keyPath];
    
    for (NSUInteger i = [oberversForKeyPath count] - 1; i + 1 > 0; i--) {
        if ([[oberversForKeyPath objectAtIndex:i] isEqual:observer]) {
            [[[self observers] objectForKey:keyPath] removeObjectAtIndex:i];
        }
    }
}

- (void)removeObserverBlocksForKeyPath:(NSString *)keyPath {
    [[self observers] removeObjectForKey:keyPath];
    
    @try {
        [self removeObserver:self forKeyPath:keyPath];
    }
    @catch (NSException *exception) {}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    for (NSKeyValueObservingBlock observer in [[self observers] objectForKey:keyPath]) {
        observer(object, change, context);
    }
}

@end
