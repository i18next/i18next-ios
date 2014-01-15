//
//  I18NextLanguageBundles.m
//  i18next
//
//  Created by Jean Regisser on 06/01/14.
//  Copyright (c) 2014 PrePlay, Inc. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Nocilla.h"

#import "I18Next.h"

#import "I18NextSpecHelper.h"

SpecBegin(I18NextLanguageBundles)

describe(@"I18Next", ^{
    __block I18Next* i18n = nil;
    __block I18NextOptions* options = nil;
    
    beforeEach(^{
        i18n = createDefaultI18NextTestInstance();
        options = [I18NextOptions optionsFromDict:i18n.options];
    });
    
    describe(@"using language bundles", ^{
        
        beforeEach(^AsyncBlock {
            options.loadFromLanguageBundles = YES;
            [i18n loadWithOptions:options.asDictionary completion:^(NSError *error) {
                done();
            }];
        });
        
        it(@"should provide bundled resources for translation", ^{
            expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_bundled_en-US");
            expect([i18n t:@"simple_en"]).to.equal(@"ok_from_bundled_en");
            
            // Only en-US and en lproj are present in this spec, so the dev one just returns the default
            expect([i18n t:@"simple_dev"]).to.equal(@"simple_dev");
        });
        
        describe(@"using synchronous load", ^{
            
            beforeEach(^{
                options.loadFromLanguageBundles = YES;
                options.synchronousLocalLoad = YES;
                [i18n loadWithOptions:options.asDictionary completion:nil];
            });
            
            it(@"should provide bundled resources for translation", ^{
                expect([i18n t:@"simple_en-US"]).to.equal(@"ok_from_bundled_en-US");
                expect([i18n t:@"simple_en"]).to.equal(@"ok_from_bundled_en");
                
                // Only en-US and en lproj are present in this spec, so the dev one just returns the default
                expect([i18n t:@"simple_dev"]).to.equal(@"simple_dev");
            });
            
        });
        
    });
    
});

SpecEnd
