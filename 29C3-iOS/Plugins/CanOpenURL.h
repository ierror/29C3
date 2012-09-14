#import <Cordova/CDVPlugin.h>

@interface CanOpenURL : CDVPlugin

{
    NSString * callbackID;

}

@property (nonatomic,copy) NSString* callbackID;

- (void) check:(NSMutableString*) arguments withDict : (NSMutableDictionary*)options;
@end