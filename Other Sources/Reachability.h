#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Reachability;

@interface Reachability : NSObject
{
    
@private
	BOOL _networkStatusNotificationsEnabled;
	
	NSString *_hostName;
	NSString *_address;
    
	NSMutableDictionary *_reachabilityQueries;
}

typedef enum
{
	NotReachable = 0,
	ReachableViaCarrierDataNetwork,
	ReachableViaWiFiNetwork
} NetworkStatus;

@property BOOL networkStatusNotificationsEnabled;
@property (nonatomic, retain) NSString *hostName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) NSMutableDictionary *reachabilityQueries;

+ (Reachability *)sharedReachability;
- (BOOL)checkInternetConnectionAndDisplayAlert:(NSString *)errorTitle errorMsg:(NSString *)errorMsg;
- (NetworkStatus)remoteHostStatus;
- (NetworkStatus)internetConnectionStatus;
- (NetworkStatus)localWiFiConnectionStatus;

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);

@end

@interface ReachabilityQuery : NSObject
{
@private
	SCNetworkReachabilityRef _reachabilityRef;
	CFMutableArrayRef _runLoops;
	NSString *_hostNameOrAddress;
}

@property (nonatomic) SCNetworkReachabilityRef reachabilityRef;
@property (nonatomic, retain) NSString *hostNameOrAddress;
@property (nonatomic) CFMutableArrayRef runLoops;

- (void)scheduleOnRunLoop:(NSRunLoop *)inRunLoop;

@end

