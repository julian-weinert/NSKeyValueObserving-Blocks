NSKeyValueObserving-Blocks
==================

***Category on NSObject that implements block support for NSKeyValueObserving***

This category adds block support for `NSObject<NSKeyValueObserving>` which makes it easy to quickly write observers right where you theed them.

##Example usage
``` objective-c
- (void)doSomeAwesomeShit {
  // anonymous observing
  [[self awesomeShit] addObserverBlock:^(id object, NSDictionary *change, void *context) {
    NSLog(@"%@ changed in context %@: %@", object, (__bridge id)context, change);
  } forKeyPath:@"awesomeProperty" options:0 context:NULL];
  
  // explicit observing
  [self setObserverBlock:^(id object, NSDictionary *change, void *context) {
    NSLog(@"%@ changed in context %@: %@", object, (__bridge id)context, change);
  }];
  [[self awesomeShit] addObserverBlock:[self observerBlock] forKeyPath:@"evenMoreAwesomeProperty" options:0 context:NULL];
}
- (void)someAwesomeShitIsNotSoAwesomeAnymore {
  // anonymous ignoring
  [[self awesomeShit] removeObserverBlocksForKeyPath:@"awesomeProperty"];
  
  // explicit ignoring
  [[self awesomeShit] removeObserverBlock:[self observerBlock] forKeyPath:@"evenMoreAwesomeProperty"];
  [self setOberverBlock:nil];
}
```
