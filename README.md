# Asciidoctor::I18n

No more [po4a](https://po4a.org/)!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'asciidoctor-i18n'
```

And then execute:

```sh
$ bundle
```

## Usage

```
$ cat index.adoc
Hello, world!
$ bundle exec asciidoctor -r asciidoctor-i18n -a language=ja -a po-directory=locales index.adoc
...

$ cat locales/ja.po
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"

msgid "Hello, world!"
msgstr ""

$ edit locales/ja.po

$ cat locales/ja.po
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"

msgid "Hello, world!"
msgstr "こんにちは、世界！"

$ bundle exec asciidoctor -r asciidoctor-i18n -a language=ja -a po-directory=locales index.adoc
... 
$ # and open index.html (translated HTML).
```

## Development

After checking out the repo, run `bundle install` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, 
which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/seikichi/asciidoctor-i18n. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Asciidoctor::I18n project’s codebases, issue trackers, chat rooms and mailing lists is
expected to follow the [code of conduct](https://github.com/seikichi/asciidoctor-i18n/blob/master/CODE_OF_CONDUCT.md).
