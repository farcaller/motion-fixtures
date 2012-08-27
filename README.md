# Motion::Fixtures

This gem adds support for simple fixtures installation to simulator

## Usage

1. Require `'motion-fixtures'` in your `Rakefile` (or use Bundler)
2. Place your fixture files into `spec/fixtures/`
3. There's no step 3!

## Customization

By default, fixtures are taken from `spec/fixtures/` and are copied to `Documents`
directory of your application. To customize the behaviour use `app.fixtures` property.
It's **an Array of Arrays**, where each fixture is a pair of *file name* and destination
directory name (see NSSearchPathDirectory in Cocoa docs).

Example:

```ruby
app.fixtures = [
  ['./spec/fixtures/test.db', :NSDocumentDirectory], # notice the Symbol
  ['./spec/fixtures/stub_cache', :NSCachesDirectory]
]
```

Note: subdirectories are not [yet] supported. Patches are welcome.
