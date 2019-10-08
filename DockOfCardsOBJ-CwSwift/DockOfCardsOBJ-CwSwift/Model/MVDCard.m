//
//  MVDCard.m
//  DockOfCardsOBJ-CwSwift
//
//  Created by Michael Di Cesare on 10/8/19.
//  Copyright © 2019 Michael Di Cesare. All rights reserved.
//

#import "MVDCard.h"

@implementation MVDCard
// creating a instance type function, we start by defining what we want returned, exturnal parameter name/ function name, followed by: of type string and pointer in memory. then this is followed by our internal name for each parameter and then we open the scope.
- (instancetype)initWithCardSuit:(NSString *)suit image:(NSString *)image
{
    // almost everything in object-c is a class
    // when creating your own class. it is a subclass of nsobject, so we need to initialize the superclass first
    self = [super init];
    
    //if self exists, then initialize with our properties
    if (self)
    {
        //self.suit = suit
        _suit = suit;
        _image = image;
    }
    return self;
}

@end


// extention on MVDCard
@implementation MVDCard (JSONConvertable)
/*
 1: "-" instance Method
 2: "()" what we are returning with
 3: "initWithDictionary" is our exturnal name and our first parameter
 4: "NSDictionary<id, id> *" = type declaration
    -"NSDictionary<NSString*, id>" = define the types for the key "NSString" and value ""id aka any" of our dictionary
 5: "*" pointer of memory
 6: "dictionary" = internal name for our parameter
 
*/
- (MVDCard *)initWIthDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    NSString * suit = dictionary[@"suit"];
    NSString * image = dictionary[@"image"];
    
    return [self initWithCardSuit:suit image:image];
    
}

@end
