#import "OneginiConfigModel.h"

@implementation OneginiConfigModel

+ (NSArray *)certificates
{
    return @[@""]; //Base64Certificates
}

+ (NSDictionary *)configuration
{
    return @{
             @"ONGAppIdentifier" : @"ExampleApp",
             @"ONGAppPlatform" : @"ios",
             @"ONGAppVersion" : @"5.1.0",
             @"ONGAppBaseURL" : @"",
             @"ONGResourceBaseURL" : @"",
             @"ONGRedirectURL" : @"",
             };
}

@end
