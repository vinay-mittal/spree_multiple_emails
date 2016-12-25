SpreeMultipleEmails
===================

[![Code Climate](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails/badges/gpa.svg)](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails)
[![Issue Count](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails/badges/issue_count.svg)](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails)
[![Test Coverage](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails/badges/coverage.svg)](https://codeclimate.com/github/vinay-mittal/spree_multiple_emails/coverage)
[![Build Status](https://travis-ci.org/vinay-mittal/spree_multiple_emails.svg?branch=master)](https://travis-ci.org/vinay-mittal/spree_multiple_emails)

This extension allows a user to have multiple emails.

Current Features
---------------

1. User can have multiple emails.
2. Emails can be associated to user from both admin and user end.
3. Each email added will receive a verfication email only if `Spree::Auth::Config[:confirmable]` is set to `true`.
4. There will only be one primary email which will be used as user's own email.
5. When user changes his email, his primary email is also changed. But you cannot change or remove primary email.
6. Any email can only be made primary if it is verified in case of verification required.
7. Only user can verify email.
8. There is no option for admin to verify email.

Installation
------------

Add spree_multiple_emails to your Gemfile:

```ruby
gem 'spree_multiple_emails', github: "vinay-mittal/spree_multiple_emails", branch: "x-x-stable"
```

The `branch` option is important: it must match the version of Spree you're using.
For example, use `3-0-stable` if you're using Spree `3-0-stable` or any `3.0.x` version.

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_multiple_emails:install
```

Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_multiple_emails/factories'
```

Copyright (c) 2016 [Vinay Mittal], released under the New BSD License
