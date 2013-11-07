//
//  I18NextSpec.m
//  i18nextspec
//
//  Created by Jean Regisser on 28/10/13.
//  Copyright (c) 2013 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18Next)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"initialisation", ^{
        
        it(@"should return a shared instance", ^{
            I18Next* sharedI18n = [I18Next sharedInstance];
            expect(sharedI18n).toNot.beNil();
            expect(sharedI18n).to.beIdenticalTo([I18Next sharedInstance]);
        });
            
    });
    
});

SpecEnd
