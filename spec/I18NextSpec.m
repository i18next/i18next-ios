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

#import "I18Next.h"

SpecBegin(I18Next)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block NSDictionary* testStore =
    @{
      @"dev": @{ @"translation": @{ @"simple_dev": @"ok_from_dev" } },
      @"en": @{ @"translation": @{ @"simple_en": @"ok_from_en" } },
      @"en-US": @{ @"translation": @{ @"simple_en-US": @"ok_from_en-US" } },
      };
    
    beforeEach(^{
        i18n = [I18Next new];
    });
    
    describe(@"initialisation", ^{
        
        it(@"should return a shared instance", ^{
            I18Next* sharedI18n = [I18Next sharedInstance];
            expect(sharedI18n).toNot.beNil();
            expect(sharedI18n).to.beIdenticalTo([I18Next sharedInstance]);
        });
        
        describe(@"with passed in resources set", ^{
            
            beforeEach(^{
                i18n.resourcesStore = testStore;
            });
            
            it(@"should provide passed resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_en-US");
                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_en");
                expect([i18n t:@"simple_dev"]).to.equal(@"ok_from_dev");
            
            });
            
        });
        
    });
    
    describe(@"translation", ^{
        
        beforeEach(^{

        });
        
        
    });
    
});

SpecEnd
