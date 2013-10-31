//
//  I18NextPlurals.h
//  i18next
//
//  Created by Jean Regisser on 31/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface I18NextPlurals : NSObject

+ (instancetype)sharedInstance;
+ (void)setSharedInstance:(I18NextPlurals*)instance;

@property (nonatomic, strong, readonly) NSDictionary* rules;

- (NSInteger)numberForLang:(NSString*)lang count:(NSUInteger)count;

@end

@interface I18NextPluralRule : NSObject

@property (nonatomic, copy, readonly) NSString* name;
@property (nonatomic, copy, readonly) NSArray* numbers;
@property (nonatomic, copy, readonly) NSUInteger (^pluralBlock)(NSUInteger n);

+ (instancetype)ruleWithName:(NSString*)name numbers:(NSArray*)numbers
                       pluralBlock:(NSUInteger (^)(NSUInteger n))pluralBlock;

@end
