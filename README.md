# Spree/MailChimp Integration

[![Build Status](https://secure.travis-ci.org/futhr/spree_chimpy.png?branch=2-0-stable)](http://travis-ci.org/futhr/spree_chimpy)
[![Dependency Status](https://gemnasium.com/futhr/spree_chimpy.png)](https://gemnasium.com/futhr/spree_chimpy)
[![Coverage Status](https://coveralls.io/repos/futhr/spree_chimpy/badge.png?branch=2-0-stable)](https://coveralls.io/r/futhr/spree_chimpy)

Makes it easy to integrate your [Spree][1] app with [MailChimp][2].

- List synchronization: Automatically syncs Spree's user list with MailChimp. The user can subscribe/unsubscribe via the registration and account pages.
- Order synchronoization: Fully supports MailChimp's [eCommerce360][3] API. Allows you to create targeted campaigns in MailChimp based on a user's purchase history. We'll even update MailChimp if the order changes after the sale (i.e. order modification, cancelation, return).
- Campaign Revenue Tracking: Notifies MailChimp when an order originates from a campaign email.
- Custom User Data: Easily add your own custom merge vars. We'll only sync them when data changes
- Existing Stores: Provides a handy rake task `rake spree_chimpy:orders:sync` is included to sync up all your existing order data with mail chimp. Run this after installing spree_chimpy to an existing store.
- Deferred Processing: Communication between Spree and MailChimp is synchronous by default. If you have `delayed_job` in your bundle, the communication is queued up and deferred to one of your workers. (`sidekiq` support also planned)

## Installing

Add spree_chimpy to your `Gemfile`

```ruby
gem 'spree_chimpy'
```

Alternatively you can use the git repo directly:

```ruby
gem 'spree_chimpy', github: 'futhr/spree_chimpy', branch: '2-0-stable'
```

Run bundler

    bundle

Install migrations & initializer file

    bundle exec rails g spree_chimpy:install

### MailChimp Setup

If you don't already have an account, you can [create one here][4] for free.

Make sure to create a list if you don't already have one. Use any name you like, just dont forget to update the `Spree::Chimpy::Config#list_name` setting

### Spree Setup

Edit the initializer created by the `spree_chimpy:install` generator. Only the API key is required

```ruby
# config/initializers/spree_chimpy.rb
Spree::Chimpy.config do |config|
  # your API key provided by MailChimp
  config.key = 'your-api-key'
end
```

If you'd like, you can add additional options:

```ruby
# config/initializers/spree_chimpy.rb
Spree::Chimpy.config do |config|
  # your API key as provided by MailChimp
  config.key = 'your-api-key'

  # name of your list, defaults to "Members"
  config.list_name = 'peeps'

  # change the double-opt-in behavior
  config.double_opt_in = false

  # id of your store. max 10 letters. defaults to "spree"
  config.store_id = 'acme'

  # define a list of merge vars:
  # - key: a unique name that mail chimp uses. 10 letters max
  # - value: the name of any method on the user class.
  # default is {'EMAIL' => :email}
  config.merge_vars = {
    'EMAIL' => :email,
    'HAIRCOLOR' => :hair_color
  }
end
```

For deployment on Heroku, you can configure the API key with environment variables:

```ruby
# config/initializers/spree_chimpy.rb
Spree::Chimpy.config do |config|
  config.key = ENV['MAILCHIMP_API_KEY']
end
```

### Segmenting

By default spree_chimpy will try to segment customers. The segment name can be configured using the `segment_name` setting.
Spree_chimpy will use an existing segment if it exists. If no segment can be found it will be created for you automatically.

#### Note about double-opt-in & segmenting

Mailchimp does not allow you to segment emails that have not confirmed their subscription. This means that if you use the
double-opt-in setting users will not get segmented by default. To work around this there is a rake task to segment all currently subscribed users.

`rake spree_chimpy:users:segment`

The output of this command will look something like this:

    Segmenting all subscribed users
    Error 215 with email: user@example.com
     msg: The email address "user@example" does not belong to this list
    segmented 2 out of 3
    done

You can run this task recurring by setting up a cron using [whenever](https://github.com/javan/whenever) or by using [clockwork](https://github.com/tomykaira/clockwork). Alternatively when you host on Heroku you can use [Heroku Scheduler](https://addons.heroku.com/scheduler)

### Adding a Guest subscription form

spree_chimpy comes with a default subscription form for users who are not logged in, just add the following deface override:

```ruby
Deface::Override.new(:virtual_path  => "spree/shared/_footer",
                     :name          => "spree_chimpy_subscription_form",
                     :insert_bottom => "#footer-right",
                     :partial       => "spree/shared/guest_subscription_form")
```

The selector and virtual path can be changed to taste.

## Contributing

In the spirit of [free software][5], **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using prerelease versions
* by reporting [bugs][6]
* by suggesting new features
* by writing [translations][8]
* by writing or editing documentation
* by writing specifications
* by writing code (*no patch is too small*: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by resolving [issues][6]
* by reviewing patches

Starting point:

* Fork the repo
* Clone your repo
* Run `bundle install`
* Run `bundle exec rake test_app` to create the test application in `spec/test_app`
* Make your changes
* Ensure specs pass by running `bundle exec rspec spec`
* Submit your pull request

Copyright (c) 2013 [Joshua Nussbaum][9] and [contributors][10], released under the [New BSD License][7]

[1]: http://spreecommerce.com
[2]: http://www.mailchimp.com
[3]: http://kb.mailchimp.com/article/what-is-ecommerce360-and-how-does-it-work-with-mailchimp
[4]: https://login.mailchimp.com/signup
[5]: http://www.fsf.org/licensing/essays/free-sw.html
[6]: https://github.com/futhr/spree_chimpy/issues
[7]: https://github.com/futhr/spree_chimpy/blob/2-0-stable/LICENSE.md
[8]: http://www.localeapp.com/projects/5151
[9]: https://github.com/joshnuss
[10]: https://github.com/futhr/spree_chimpy/contributors
