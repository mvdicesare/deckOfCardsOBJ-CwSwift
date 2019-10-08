//
//  MVDCardController.m
//  DockOfCardsOBJ-CwSwift
//
//  Created by Michael Di Cesare on 10/8/19.
//  Copyright © 2019 Michael Di Cesare. All rights reserved.
//

#import "MVDCardController.h"

@implementation MVDCardController
// singleton for obj-c
// "+" = to static "class method"
//return with our card controller
// * pointer in memory for our internal parameter
+ (MVDCardController *)sharedController
{
    // making share controller does not exist
    static MVDCardController * sharedController = nil;
    // creating a token on the backround thread to keep track how many times the token is run
    static dispatch_once_t onceToken;
    // method that takes in our once token from above, runs a completion to, allocate and initialze a MVDCardController
    dispatch_once(&onceToken, ^{
        sharedController = [MVDCardController new];
    });
    return sharedController;
}
// defines a constant for our base URL with a string
static NSString * const baseURLString = @"https://deckofcardsapi.com/api/deck/new";


- (void)drawNewCard:(NSInteger)numberOfCards completion:(void (^)(NSArray<MVDCard *> *))completion
{
    // defines var for our url (uses bracket syntax vs dot syntax like in swift
    NSURL * url = [NSURL URLWithString:baseURLString];
    NSString * cardCount = [@(numberOfCards) stringValue];
    NSURL * drawURL = [url URLByAppendingPathComponent:@"draw/"];
    
    NSURLComponents * urlComponents = [NSURLComponents componentsWithURL:drawURL resolvingAgainstBaseURL:true];
    
    NSURLQueryItem * queryItem = [NSURLQueryItem queryItemWithName:@"count" value:cardCount];
    
    urlComponents.queryItems = @[queryItem];
    NSURL * finalURL = urlComponents.URL;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"there was an error in %s: %@, %@", __PRETTY_FUNCTION__, error, [error localizedDescription]);
        }
        if (response)
        {
            NSLog(@"%@", response);
        }
        if (data)
        {
            // decoding var and allocation memory for our top level dictionary, calling our JSON Serializarion method with get an object
            // the options2 means ""NSJSONreadingAllowFragments"
            //&error means same spot in memory as error from data task.
            NSDictionary * topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&error];
            if (!topLevelDictionary)
            {
                NSLog(@"Error parsing the JSON %@", error);
                completion(nil);
                return;
            }
            // define a var for our cards array at the key "cards" from the top level dictionary
            // needed because dict is 2 levels deep in jason data
            NSArray * cardsArray = topLevelDictionary[@"cards"];
            //defining a placehilder variable that is declared as mutable so that we can later append to it
            NSMutableArray * cardPlaceholder = [NSMutableArray new];
            
            for (NSDictionary * dictionary in cardsArray)
            {
                MVDCard * card = [[MVDCard alloc] initWIthDictionary:dictionary];
                [cardPlaceholder addObject:card];
            }
            completion(cardPlaceholder);
        }
    }]resume];
}
- (void)fetchImageFromCard:(MVDCard *)card completion:(void (^)(UIImage *))completion
{
    NSURL * imageURL = [NSURL URLWithString:card.image];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Error %@, %@", error, [error localizedDescription]);
            completion(nil);
            return;
        }
        if (response)
        {
            NSLog(@"%@", response);
        }
        if (data)
        {
            UIImage * image = [UIImage imageWithData:data];
            completion(image);
        }
    }] resume];
}
@end

