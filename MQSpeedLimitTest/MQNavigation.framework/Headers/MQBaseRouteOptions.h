//
//  MQBaseRouteOptions.h
//  MapQuest
//
//  Copyright (c) 2018 MapQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQNavigation/MQNavigationUnits.h>

/**
 Route Type being requested
 */
typedef NS_ENUM(NSUInteger, MQRouteType) {
    
    /// The route will be calculated for the fastest driving time; default
    MQRouteTypeDrivingFastest,
    
    /// The route will be calculated for the shortest route
    MQRouteTypeDrivingShortest,
    
    /// The route will be designed for pedestrian traffic
    MQRouteTypePedestrian
};

/**
 An foundational object that describes the route options. Currently used to support both the super MQRouteOptions and as a parameter for the RouteSummary service, as we support more options in the RouteSummary service we will transfer properties here.
 */
@interface MQBaseRouteOptions : NSObject
/**
 The route type defines the mode of transportation used for this specific route. Acceptable values include Driving (Fastest/Shortest), pedestrian (for walking directions)
 */
@property (nonatomic) MQRouteType routeType;

@end
