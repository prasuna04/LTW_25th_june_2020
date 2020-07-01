#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SBLocalStorage.h"
#import "SBNotificationHubHelper.h"
#import "SBRegistrationParser.h"
#import "SBStaticHandlerResponse.h"
#import "SBStoredRegistrationEntry.h"
#import "SBTokenProvider.h"
#import "SBURLConnection.h"
#import "SBConnectionString.h"
#import "SBNotificationHub.h"
#import "SBRegistration.h"
#import "SBTemplateRegistration.h"
#import "WindowsAzureMessaging.h"

FOUNDATION_EXPORT double WindowsAzureMessagingVersionNumber;
FOUNDATION_EXPORT const unsigned char WindowsAzureMessagingVersionString[];

