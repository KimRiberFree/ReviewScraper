#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>

#import "Reachability.h"
#import <SystemConfiguration/SCNetworkReachability.h>

static NSString *kLinkLocalAddressKey = @"169.254.0.0";
static NSString *kDefaultRouteKey = @"0.0.0.0";

static Reachability *_sharedReachability;

@interface Reachability(Private)
- (BOOL)isAdHocWiFiNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags;
- (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags;
- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags;
- (SCNetworkReachabilityRef)reachabilityRefForHostName:(NSString *)hostName;
- (SCNetworkReachabilityRef)reachabilityRefForAddress:(NSString *)address;
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)outAddress;
- (void)stopListeningForReachabilityChanges;
@end

@implementation Reachability

@synthesize networkStatusNotificationsEnabled = _networkStatusNotificationsEnabled;
@synthesize hostName = _hostName;
@synthesize address = _address;
@synthesize reachabilityQueries = _reachabilityQueries;

- (BOOL)checkInternetConnectionAndDisplayAlert:(NSString *)errorTitle errorMsg:(NSString *)errorMsg
{
	NetworkStatus connectionStatus = [self internetConnectionStatus];
	
	if(connectionStatus == NotReachable)
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] autorelease];
		[alert show];
		
		return NO;
	}
	
	return YES;
}

+ (Reachability *)sharedReachability
{
	if(!_sharedReachability)
	{
		_sharedReachability = [[Reachability alloc] init];
        _sharedReachability.hostName = nil;
		_sharedReachability.address = nil;
		_sharedReachability.networkStatusNotificationsEnabled = NO;
		_sharedReachability.reachabilityQueries = [[NSMutableDictionary alloc] init];
	}
	
	return _sharedReachability;
}

- (void)dealloc
{	
    [self stopListeningForReachabilityChanges];
    
	[_sharedReachability.reachabilityQueries release];
	[_sharedReachability release];
	
	[super dealloc];
}

- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags
{
	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	
	BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
	
	if((flags & kSCNetworkReachabilityFlagsIsWWAN))
	{
		noConnectionRequired = YES;
	}
	
	return (isReachable && noConnectionRequired) ? YES : NO;
}

- (BOOL)isHostReachable:(NSString *)host
{
    if(!host || ![host length])
	{
        return NO;
    }
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
	BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    
	CFRelease(reachability);
    
    if(!gotFlags)
	{
        return NO;
    }
    
	return [self isReachableWithoutRequiringConnection:flags];
}

- (BOOL)isAdHocWiFiNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags
{		
	ReachabilityQuery *query = [self.reachabilityQueries objectForKey:kLinkLocalAddressKey];
	SCNetworkReachabilityRef adHocWiFiNetworkReachability = query.reachabilityRef;
	
    if(!adHocWiFiNetworkReachability)
	{
        struct sockaddr_in sin;
        
        bzero(&sin, sizeof(sin));
        sin.sin_len = sizeof(sin);
        sin.sin_family = AF_INET;
        sin.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
        
        adHocWiFiNetworkReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&sin);
		
		query = [[[ReachabilityQuery alloc] init] autorelease];
		query.hostNameOrAddress = kLinkLocalAddressKey;
		query.reachabilityRef = adHocWiFiNetworkReachability;
		
		[self.reachabilityQueries setObject:query forKey:kLinkLocalAddressKey];
    }
	
	[query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    SCNetworkReachabilityFlags addressReachabilityFlags;
    BOOL gotFlags = SCNetworkReachabilityGetFlags(adHocWiFiNetworkReachability, &addressReachabilityFlags);
	
    if(!gotFlags)
	{
        return NO;
    }
    
    if(outFlags)
	{
        *outFlags = addressReachabilityFlags;
    }
    
    return [self isReachableWithoutRequiringConnection:addressReachabilityFlags];
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetworkReachabilityChangedNotification" object:nil];
	
	[pool release];
}

- (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags
{
	ReachabilityQuery *query = [self.reachabilityQueries objectForKey:kDefaultRouteKey];
	SCNetworkReachabilityRef defaultRouteReachability = query.reachabilityRef;
	
    if(!defaultRouteReachability)
	{
        struct sockaddr_in zeroAddress;
        bzero(&zeroAddress, sizeof(zeroAddress));
        zeroAddress.sin_len = sizeof(zeroAddress);
        zeroAddress.sin_family = AF_INET;
        
        defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
		
		ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
		query.hostNameOrAddress = kDefaultRouteKey;
		query.reachabilityRef = defaultRouteReachability;
		
		[self.reachabilityQueries setObject:query forKey:kDefaultRouteKey];
    }
	
	[query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
	
	SCNetworkReachabilityFlags flags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	
	if(!gotFlags)
	{
        return NO;
    }
    
	BOOL isReachable = [self isReachableWithoutRequiringConnection:flags];
	
	if(outFlags)
	{
		*outFlags = flags;
	}
	
	return isReachable;
}

- (void)stopListeningForReachabilityChanges
{
	NSEnumerator *enumerator = [self.reachabilityQueries objectEnumerator];
	ReachabilityQuery *reachabilityQuery;
    
	while(reachabilityQuery = [enumerator nextObject])
	{
		CFArrayRef runLoops = reachabilityQuery.runLoops;
		NSUInteger runLoopCounter, maxRunLoops = CFArrayGetCount(runLoops);
        
		for(runLoopCounter = 0; runLoopCounter < maxRunLoops; runLoopCounter++)
		{
			CFRunLoopRef nextRunLoop = (CFRunLoopRef)CFArrayGetValueAtIndex(runLoops, runLoopCounter);
			
			SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityQuery.reachabilityRef, nextRunLoop, kCFRunLoopDefaultMode);
		}
        
        CFArrayRemoveAllValues(reachabilityQuery.runLoops);
	}
}

- (SCNetworkReachabilityRef)reachabilityRefForHostName:(NSString *)hostName
{
	if(!hostName || ![hostName length])
	{
		return NULL;
	}
	
	ReachabilityQuery *cachedQuery = [self.reachabilityQueries objectForKey:hostName];
	SCNetworkReachabilityRef reachabilityRefForHostName = cachedQuery.reachabilityRef;
	
	if(reachabilityRefForHostName)
	{
		return reachabilityRefForHostName;
	}
	
	reachabilityRefForHostName = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [hostName UTF8String]);
    
    NSAssert1(reachabilityRefForHostName != NULL, @"Failed to create SCNetworkReachabilityRef for host: %@", hostName);
    
	ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
	query.hostNameOrAddress = hostName;
	query.reachabilityRef = reachabilityRefForHostName;
	 
    [query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    [self.reachabilityQueries setObject:query forKey:hostName];
	
    return reachabilityRefForHostName;
}

- (SCNetworkReachabilityRef)reachabilityRefForAddress:(NSString *)addressString
{
	if(!addressString || ![addressString length])
	{
		return NULL;
	}
	
	struct sockaddr_in address;
	
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if(!gotAddress)
	{
        NSAssert1(gotAddress != NO, @"Failed to convert an IP address string to a sockaddr_in: %@", addressString);
		return NULL;
	}
	
	ReachabilityQuery *cachedQuery = [self.reachabilityQueries objectForKey:addressString];
	SCNetworkReachabilityRef reachabilityRefForAddress = cachedQuery.reachabilityRef;
	
	if(reachabilityRefForAddress)
	{
		return reachabilityRefForAddress;
	}
	
	reachabilityRefForAddress = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&address);
    
    NSAssert1(reachabilityRefForAddress != NULL, @"Failed to create SCNetworkReachabilityRef for address: %@", addressString);
    
	ReachabilityQuery *query = [[[ReachabilityQuery alloc] init] autorelease];
	query.hostNameOrAddress = addressString;
	query.reachabilityRef = reachabilityRefForAddress;
    
    [query scheduleOnRunLoop:[NSRunLoop currentRunLoop]];
    
    [self.reachabilityQueries setObject:query forKey:addressString];
	
    return reachabilityRefForAddress;
}

- (NetworkStatus)remoteHostStatus
{
	SCNetworkReachabilityRef reachabilityRef = nil;
	
	if(self.hostName)
	{
		reachabilityRef = [self reachabilityRefForHostName:self.hostName];
	}
	else if(self.address)
	{
		reachabilityRef = [self reachabilityRefForAddress:self.address];
	}
	else
	{
		NSAssert(self.hostName != nil && self.address != nil, @"No hostName or address specified. Cannot determine reachability.");
		return NotReachable;
	}
	
	if(!reachabilityRef)
	{
		return NotReachable;
	}
	
	SCNetworkReachabilityFlags reachabilityFlags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(reachabilityRef, &reachabilityFlags);
	
    if(!gotFlags)
	{
        return NotReachable;
    }
    
	BOOL reachable = [self isReachableWithoutRequiringConnection:reachabilityFlags];
	
	if(!reachable)
	{
		return NotReachable;
	}
	
	if(reachabilityFlags & ReachableViaCarrierDataNetwork)
	{
		return ReachableViaCarrierDataNetwork;
	}
	
	return ReachableViaWiFiNetwork;
}

- (NetworkStatus)internetConnectionStatus
{	
	SCNetworkReachabilityFlags defaultRouteFlags;
	BOOL defaultRouteIsAvailable = [self isNetworkAvailableFlags:&defaultRouteFlags];
	
	if(defaultRouteIsAvailable)
	{
		if(defaultRouteFlags & kSCNetworkReachabilityFlagsIsDirect)
		{
			return NotReachable;
		}
		else if(defaultRouteFlags & ReachableViaCarrierDataNetwork)
		{
			return ReachableViaCarrierDataNetwork;
		}
		
		return ReachableViaWiFiNetwork;
	}
	
	return NotReachable;
}

- (NetworkStatus)localWiFiConnectionStatus
{
	SCNetworkReachabilityFlags selfAssignedAddressFlags;
	
	BOOL hasLinkLocalNetworkAccess = [self isAdHocWiFiNetworkAvailableFlags:&selfAssignedAddressFlags];
    
	if(hasLinkLocalNetworkAccess && (selfAssignedAddressFlags & kSCNetworkReachabilityFlagsIsDirect))
	{
		return ReachableViaWiFiNetwork;
	}
	
	return NotReachable;
}

- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if(!IPAddress || ![IPAddress length])
	{
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	
	if(conversionResult == 0)
	{
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		
		return NO;
	}
	
	return YES;
}

@end

@interface ReachabilityQuery ()
- (CFRunLoopRef)startListeningForReachabilityChanges:(SCNetworkReachabilityRef)reachability onRunLoop:(CFRunLoopRef)runLoop;
@end

@implementation ReachabilityQuery

@synthesize reachabilityRef = _reachabilityRef;
@synthesize runLoops = _runLoops;
@synthesize hostNameOrAddress = _hostNameOrAddress;

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		self.runLoops = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
	}
	
	return self;
}

- (void)dealloc
{
	CFRelease(self.runLoops);
	[super dealloc];
}

- (BOOL)isScheduledOnRunLoop:(CFRunLoopRef)runLoop
{
	NSUInteger runLoopCounter, maxRunLoops = CFArrayGetCount(self.runLoops);
	
	for(runLoopCounter = 0; runLoopCounter < maxRunLoops; runLoopCounter++)
	{
		CFRunLoopRef nextRunLoop = (CFRunLoopRef)CFArrayGetValueAtIndex(self.runLoops, runLoopCounter);
		
		if(nextRunLoop == runLoop)
		{
			return YES;
		}
	}
	
	return NO;
}

- (void)scheduleOnRunLoop:(NSRunLoop *)inRunLoop
{
	if([[Reachability sharedReachability] networkStatusNotificationsEnabled] == NO)
	{
		return;
	}
	
	if(!inRunLoop)
	{
		return;
	}
	
	CFRunLoopRef runLoop = [inRunLoop getCFRunLoop];
	
	if(![self isScheduledOnRunLoop:runLoop])
	{
		CFRunLoopRef notificationRunLoop = [self startListeningForReachabilityChanges:self.reachabilityRef onRunLoop:runLoop];
		
		if(notificationRunLoop)
		{
			CFArrayAppendValue(self.runLoops, notificationRunLoop);
		}
	}
}

- (CFRunLoopRef)startListeningForReachabilityChanges:(SCNetworkReachabilityRef)reachability onRunLoop:(CFRunLoopRef)runLoop
{	
	if(!reachability)
	{
		return NULL;
	}
	
	if(!runLoop)
	{
		return NULL;
	}
    
	SCNetworkReachabilityContext	context = {0, self, NULL, NULL, NULL};
	SCNetworkReachabilitySetCallback(reachability, ReachabilityCallback, &context);
	SCNetworkReachabilityScheduleWithRunLoop(reachability, runLoop, kCFRunLoopDefaultMode);
	
	return runLoop;
}


@end
