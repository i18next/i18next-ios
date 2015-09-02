//
//  I18NextPluralsSpec.m
//  i18next
//
//  Created by Jean Regisser on 02/09/15.
//  Copyright (c) 2015 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "I18NextPlurals.h"

SpecBegin(I18NextPlurals)

describe(@"I18NextPlurals", ^{
    __block I18NextPlurals* plurals = nil;

    NSOrderedSet *allLangs =
    [NSOrderedSet orderedSetWithArray:
     @[
       @"ach", @"af", @"ak", @"am", @"an", @"ar", @"arn", @"ast", @"ay", @"az", @"be", @"bg", @"bn", @"bo", @"br",
       @"bs", @"ca", @"cgg", @"cs", @"csb", @"cy", @"da", @"de", @"dz", @"el", @"en", @"eo", @"es", @"es_ar", @"et",
       @"eu", @"fa", @"fi", @"fil", @"fo", @"fr", @"fur", @"fy", @"ga", @"gd", @"gl", @"gu", @"gun", @"ha", @"he",
       @"hi", @"hr", @"hu", @"hy", @"ia", @"id", @"is", @"it", @"ja", @"jbo", @"jv", @"ka", @"kk", @"km", @"kn",
       @"ko", @"ku", @"kw", @"ky", @"lb", @"ln", @"lo", @"lt", @"lv", @"mai", @"mfe", @"mg", @"mi", @"mk", @"ml",
       @"mn", @"mnk", @"mr", @"ms", @"mt", @"nah", @"nap", @"nb", @"ne", @"nl", @"nn", @"no", @"nso", @"oc", @"or",
       @"pl", @"pa", @"pap", @"pms", @"ps", @"pt", @"pt_br", @"rm", @"ro", @"ru", @"sah", @"sco", @"se", @"si",
       @"sk", @"sl", @"so", @"son", @"sq", @"sr", @"su", @"sv", @"sw", @"ta", @"te", @"tg", @"th", @"ti", @"tk",
       @"tr", @"tt", @"ug", @"uk", @"ur", @"uz", @"vi", @"wa", @"wo", @"yo", @"zh",
       ]];

    beforeEach(^{
        plurals = [I18NextPlurals new];
    });

    it(@"should have rules for all languages", ^{
        NSSet *langs = [NSSet setWithArray:plurals.rules.allKeys];
        expect(langs).to.equal(allLangs.set);
    });

    it(@"should have valid rules for all languages", ^{
        for(NSString *lang in allLangs) {
            I18NextPluralRule *rule = plurals.rules[lang];
            expect(rule.name).notTo.beEmpty();
            expect(rule.pluralBlock).notTo.beNil();
            expect(rule.pluralBlock(0)).to.beGreaterThanOrEqualTo(0);
        }
    });

});

SpecEnd

