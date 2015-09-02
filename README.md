# i18next-ios

[![Build Status](https://travis-ci.org/i18next/i18next-ios.svg)](https://travis-ci.org/i18next/i18next-ios)
[![Coverage Status](https://coveralls.io/repos/i18next/i18next-ios/badge.svg?service=github)](https://coveralls.io/github/i18next/i18next-ios)

i18next-ios is a native iOS port of [i18next](http://i18next.com/).

## Why?

In order to use the same translated strings for the Web, Android and iOS, we decided to use the i18next features and data formats.

This library is our implementation for iOS.
We've been using it in production for a few years.

## Features

- [x] Support for variables 
- [x] Support for nesting 
- [x] Support for context 
- [x] Support for multiple plural forms 
- [x] [Gettext support](http://i18next.com/pages/ext_i18next-conv.html)
- [x] Sprintf supported 
- [ ] Detect language 
- [x] Graceful translation lookup 
- [x] Get string or object tree 
- [x] Get resourcefiles from server 
- [x] Resource caching
- [ ] Post missing resources to server 
- [x] Highly configurable 
- [ ] Custom post processing 
- [x] Comprehensive unit test coverage

## Requirements

- iOS 7.0+
- Xcode 6.4

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation with [CocoaPods](http://cocoapods.org)

```ruby
platform :ios, '7.0'
pod 'i18next'
```

## Usage

### Initialization

#### Instance

Create a new instance:

```objc
I18Next *i18n = [[I18Next alloc] init];
```

or get a shared instance:

```objc
I18Next *i18n = [I18Next sharedInstance];
```

If you use the shared instance you can use the handy `I18NEXT` helper macro for getting translated values.

### Resource Loading

#### Basic options

##### Set language

```objc
I18NextOptions* options = [I18NextOptions new];
options.lang = @"en-US";
```

Resources will be resolved in this order:

1. try languageCode plus countryCode, eg. 'en-US'
1. alternative look it up in languageCode only, eg. 'en'
1. finally look it up in defined fallback language, default: 'dev'

##### Additional namespaces

```objc
I18NextOptions* options = [I18NextOptions new];
options.namespace = @"myNamespace";
// or multiple
options.namespaces = @[ @"myNamespace1", @"myNamespace2" ];
```

The additional namespace(s) will be loaded.

Specify the default namespace with `options.defaultNamespace = @"myNamespace"`.

##### Unset/Set fallback language

```objc
I18NextOptions* options = [I18NextOptions new];
options.fallbackLang = @"en";
```

If not set it will default to 'dev'. If turned on, all missing key/values will be sent to this language.

Production Hint: set fallback language to some meaningful language, eg. 'en'

###### TURN FALLBACK LANGUAGE FEATURE OFF

```objc
options.fallbackLang = nil;
```

As the fallbackLang will default to 'dev' you can turn it off by setting the option value to nil. This will prevent loading the fallbacks resource file and any futher look up of missing value inside a fallback file.

##### Unset/Set fallback namespace(s)

###### WITH DEFAULT NAMESPACE

```javascript
// given resourcesfile namespace1.en.json (default ns)
{ 
   key1: 'value of key 1' 
}
 
// given additional resourcesfile namespace2.en.json
{ 
  keys: { 
    2: 'value of key 2',
    3: 'value of key 3'
  }
}
```

```objc
options.fallbackToDefaultNamespace = YES;
...
I18NEXT(@"namespace2:key1"); // -> value of key 1
```

###### WITH ONE OR MORE NAMESPACE(S)

```javascript
// given resourcesfile namespace1.en.json
{ 
   key1: 'value of key 1 - ns1' 
}
 
// given resourcesfile namespace2.en.json
{ 
   key1: 'value of key 1 - ns2' 
   key2: 'value of key 2 - ns2' 
}
 
// given resourcesfile namespace3.en.json
{ 
  keys: { 
    2: 'value of key 2',
    3: 'value of key 3'
  }
}
```

```objc
options.fallbackNamespace = @"namespace2";
...
I18NEXT("namespace3:key1"); // -> value of key 1 - ns2
```

```objc
// array
options.fallbackNamespaces = @[ @"namespace1", @"namespace2" ]; // order matters
...
I18NEXT("namespace3:key1"); // -> value of key 1 - ns1
I18NEXT("namespace3:key2"); // -> value of key 2 - ns2
```

If a resource can't be found in namespace it will be looked up in default namespace. By
default this option is turned off.

##### Specify which locales to load

###### ONLY LOAD CURRENT RESOURCE FILE

```objc
I18NextOptions* options = [I18NextOptions new];
options.langLoadType = I18NextLangLoadTypeCurrent;
```

If langLoadType option is set to current i18next will load the current set language (this could be a specific (en-US) or unspecific (en) resource file).

Hint: to prevent loading the fallbackLang's resource file set `fallbackLang` to `nil`.

###### ONLY LOAD UNSPECIFIC RESOURCE FILE

```objc
I18NextOptions* options = [I18NextOptions new];
options.langLoadType = I18NextLangLoadTypeUnspecific;
```

If set to unspecific i18next will always load the unspecific resource file (eg. en instead of en-US).

Hint: to prevent loading the fallbackLang's resource file set `fallbackLang` to `nil`.

##### Handling of null values

```javascript
// given resourcesfile namespace1.dev.json (fallback lang)
{ 
   key1: 'fallback' 
}
// given resourcesfile namespace1.en.json
{ 
   key1: null 
}
```

```objc
options.fallbackOnNull = YES;
...
I18NEXT("key1"); // -> 'fallback'

options.fallbackOnNull = NO;
...
I18NEXT("key1"); // -> ''
```

Default is YES.

##### Handling of empty string values

```javascript
// given resourcesfile namespace1.dev.json (fallback lang)
{ 
   key1: 'fallback' 
}
// given resourcesfile namespace1.en.json
{ 
   key1: '' 
}
```

**This feature is not implemented in the iOS library**

#### Options to load resources

##### Pass in resource store

```objc
I18NextOptions* options = [I18NextOptions new];

// tree: lng -> namespace -> key -> nested key
options.resourcesStore = @{
  @"dev": @{ @"translation": @{ @"key": @"value" } },
  @"en": @{ @"translation": @{ @"key": @"value" } },
  @"en-US": @{ @"translation": @{ @"key": @"value" } },
};

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];
```

As you provide the resources, the completion block will fire immediatly and no external resources will be loaded!

##### Set static route to load resources from

```objc
I18NextOptions* options = [I18NextOptions new];

options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
options.resourcesGetPathTemplate = @"locales/__lng__/__ns__.json";

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];
```

Will load 'http://example.com/locales/en-US/translation.json'.

If language is set to 'en-US' following resource files will be loaded one-by-one:
- en-US
- en
- dev (default fallback language)

Hints: 
- to keep the fetched resources in the local cache, set option `updateLocalCache = YES`
- to lowercase countryCode in requests, eg. to 'en-us', set option `lowercaseLang = YES`

##### Load resource dynamically generated on server

```objc
I18NextOptions* options = [I18NextOptions new];

options.resourcesBaseURL = [NSURL URLWithString:@"http://example.com"];
options.resourcesGetPathTemplate = @"resources.json?lng=__lng__&ns=__ns__";
options.dynamicLoad = YES;

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];
```

Will request 'http://example.com/resources.json?lng=en-US+en+dev&ns=translation'.

If language is set to 'en-US' following resources will be loaded in one request:
- en-US
- en
- dev (default fallback language)

Hint: to keep the fetched resources in the local cache, set option `updateLocalCache = YES`

##### Load resource from language bundles (lproj directory)

```objc
I18NextOptions* options = [I18NextOptions new];

options.loadFromLanguageBundles = YES;

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];
```

Will load resources from the app bundle lproj folders: `en.lproj/i18next.json`

This can be combined with the `loadFromLocalCache` option. 
In that case the local cache will be loaded first
and the language bundles will only be used if the cache is empty.

Hint: to use another filename, eg. 'myFile' set option `filenameInLanguageBundles = @"myFile"`

##### Load resource from the local cache

```objc
I18NextOptions* options = [I18NextOptions new];

options.loadFromLocalCache = YES;

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];
```

Will load resources from the local cache.

The local cache is updated whenever you load new resource from a remote server while `updateLocalCache = YES` is set.

Hint: to use a custom cache path, set the `localCachePath` option.

##### Synchronous local load

```objc
I18NextOptions* options = [I18NextOptions new];

options.loadFromLanguageBundles = YES;
options.loadFromLocalCache = YES;
options.synchronousLocalLoad = YES;

[i18n loadWithOptions:[options asDictionary] completion:^(NSError *error) {
    // new resources are successfully loaded if error == nil
}];

I18NEXT("key"); // -> "value"
```

Will load local resources synchronously (only for language bundles or the local cache).
This is useful at app initialization so the next call to translate a key
can succeed (if it exists in the language bundle or local cache).

### Translation features

Not all features of the javascript implementation of i18next are currently supported.
Here is the list from [the i18next website](http://i18next.com/pages/doc_features.html) and how to use them with this library.

#### Accessing resources

##### With default namespace

```javascript
// given resourcefile translation.en.json
{
  key1: 'value of key 1'
}
```

```objc
I18NEXT(@"key1"); // -> value of key 1
```

##### With namespace set

```javascript
// given resourcesfile namespace1.en.json (default ns)
{
   key1: 'value of key 1'
}

// given additional resourcesfile namespace2.en.json
{
  keys: {
    2: 'value of key 2',
    3: 'value of key 3'
  }
}
```

```objc
I18NEXT(@"key1"); // -> value of key 1
I18NEXT(@"namespace1.key1"); // -> value of key 1
I18NEXT(@"keys.2"); // -> missing key
I18NEXT(@"namespace2:keys.2"); // -> value of key 2
I18NEXT(@"namespace2:keys.3"); // -> value of key 3
```

##### Using multiple keys (first found will be translated)

```javascript
// given resourcefile translation.en.json
{
  key1: 'value of key 1'
}
```

```objc
I18NEXT(@[ @"notExists", @"key1" ]); // -> value of key 1
```

#### Multiline in json

```javascript
// given resources in arabic
{
  'en-US': {
    translation: {
      key: [
        "line1",
        "line2",
        "line3"
      ]
    }
  }
};
```

The translation will be joined with '\n'.

#### Arrays in json

```javascript
// given resources in arabic
{
  'en-US': {
    translation: {
      people: [
        { name: "tom" },
        { name: "steve" }
      ]
    }
  }
};
```

**This feature is not implemented in the iOS library**

#### Providing a default value

```javascript
// given resources
{
  'en-US': { translation: { // key not found } }
};
```

To get a default value if not found:

```objc
I18NEXT(@"key" defaultValue:@"my text"); // -> my text
```

#### Nested resources

```javascript
// given resources
{
  dev: { translation: { nesting1: '1 $t(nesting2)' } },
  en: { translation: { nesting2: '2 $t(nesting3)' } },
  'en-US': { translation: {  nesting3: '3' } }
};
```

```objc
I18NEXT(@"nesting1"); // -> 1 2 3
```

#### Nested resources with option replace

```javascript
// given resources
{
  en: { translation: {
    girlsAndBoys: '$t(girls, {"count": __girls__}) and __count__ boy',
    girlsAndBoys_plural: '$t(girls, {"count": __girls__}) and __count__ boys' },
    girls: '__count__ girl',
    girls_plural: '__count__ girls' } }
};
```

```objc
I18NEXT(@"girlsAndBoys" count:2 variables:@{ @"girls": @"3"}); // -> 3 girls and 2 boys
```

#### Replacing variables

```javascript
// given resources
{
  'en-US': { translation: {  key: '__myVar__ are important' } }
};
```

```objc
I18NEXT(@"key" variables:@{ @"myVar": @"variables"}); // -> variables are important
```

#### Sprintf support

```javascript
// given resources
{
  'en-US': { translation: {
    key1: 'The first 4 letters of the english alphabet are: %s, %s, %s and %s'
  }}
};
```

```objc
[[I18Next sharedInstance] tf:@"key1", "a", "b", "c", "d"];
```

#### Simple plural

```javascript
// given resources
{
  'en-US': {
    translation: {
      key: '__count__ child',
      key_plural: '__count__ children'
    }
  }
};
```

```objc
I18NEXT(@"key" count:0); // -> 0 children
I18NEXT(@"key" count:1); // -> 1 child
I18NEXT(@"key" count:5); // -> 5 children
```

#### Indefinite plural

```javascript
// given resources
{
  'en-US': {
    translation: {
      key: '__count__  child',
      key_plural: '__count__  children',
      key_indefinite: 'a child',
      key_plural_indefinite: 'some children'
    }
  }
};
```

**This feature is not implemented in the iOS library**

#### Multiple plural forms

```javascript
// given resources in arabic
{
  'ar': {
    translation: {
      key: 'singular',
      key_plural_0: 'zero',
      key_plural_2: 'two',
      key_plural_3: 'few',
      key_plural_11: 'many',
      key_plural_100: 'plural'
    }
  }
};
```

```objc
I18NEXT(@"key" count:   0); // -> zero
I18NEXT(@"key" count:   1); // -> singular
I18NEXT(@"key" count:   2); // -> two
I18NEXT(@"key" count:   3); // -> few
I18NEXT(@"key" count:   4); // -> few
I18NEXT(@"key" count: 104); // -> few
I18NEXT(@"key" count:  11); // -> many
I18NEXT(@"key" count:  99); // -> many
I18NEXT(@"key" count: 199); // -> many
I18NEXT(@"key" count: 100); // -> plural
```

What did you expect ;).

Hint: i18next provides the functionality for all languages.

#### Use translation contexts

```javascript
// given resources
{
  'en-US': {
    translation: {
      friend: 'A friend',
      friend_male: 'A boyfriend',
      friend_female: 'A girlfriend'
    }
  }
};
```

```java
I18NEXT(@"friend" count:0); // -> A friend
I18NEXT(@"friend" context:@"male"); // -> A boyfriend
I18NEXT(@"friend" context@"female"); // -> A girlfriend
```

## Credits

[i18next](http://i18next.com/) and all its contributors.
