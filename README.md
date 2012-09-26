# Criteria

> Criteria is a library for creating objective-c command line tools.  A very simple, callback approach to handling arguments and values.
Just include the .h file, in the main or wherever.  Add some options and throw a callback in there that will be executed when Criteria hits the defined flags.

## Usage Example:
```objectivec

#import "Criteria.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {

		[Criteria addOption:@[@"v", @"version"] callback:^(NSString *value) {
			printf("\nVersion: 1.0.0\n");
		}];

		[Criteria run];
	}
	
	return 0;
}

```
## If you need me
* [Github](http://www.github.com/wess)
* [@WessCope](http://www.twitter.com/wess)

## License
Read LICENSE file for more info.