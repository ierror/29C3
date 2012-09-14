#import "CanOpenURL.h"

@implementation CanOpenURL
@synthesize callbackID;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) check:(NSMutableString *)arguments withDict:(NSMutableDictionary *)options
{
    self.callbackID = [arguments pop];
    
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"StringReceived:"];
    //Append the received string to the string we plan to send out        
    [stringToReturn appendString: stringObtainedFromJavascript];
    //Create Plugin Result 
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: [stringToReturn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *appUrl = [NSURL URLWithString:stringObtainedFromJavascript ];
    
    if([[UIApplication sharedApplication] canOpenURL:appUrl])
    {
         [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    }
    else
    {
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
    
}
@end