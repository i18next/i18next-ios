//
//  i18nextTests.m
//  i18nextTests
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(I18Next)

describe(@"I18Next", ^{
    
    it(@"should do stuff", ^{
        expect(@"foo").to.equal(@"foo");
    });
});

SpecEnd
