# Dashboard

Dashboard is the Kabisa Managed Services monitoring dashboard, used on several
screens in the office.

Dashboard is powered by [Dashing][].

![dashboard](https://s3-eu-west-1.amazonaws.com/kabisa/gh-dashboard.png)

# Benefits

Dashboard gives you a quick overview of the most important data sets for your
company. Currently, three data sets are exposed in different ways:

* **Zendesk** – Get notifications and warnings about the number of tickets in
                a specific view. You can also show a list of Zendesk views and
                the total number of tickets in these views.

* **Nagios** – Get notifications/warnings about the number of services which are
               marked as *warnings* or *criticals*.

* **Project** - This job shows a single card per *company project*. This card
                can then be modified based on the state of the project. Right
                now there is a single sub-job that changes the state of these
                cards, namely **Jenkins**. The Jenkins job shows when a build is
                in progress and displays the status (failed or passed) of the
                project's latest build. It also shows who broke the build.

## Development and deployment

* `git clone`

* `bundle`

* Configuration happens through a set of environment variables. There are three
  files you should rename and modify to your liking:

  * `.env.example`
  * `config/config.yml.example`
  * `config/jenkins.yml.example`

* `dashing start`

* The application can easily be deployed to a free Heroku instance.

### Framework changes compared to Dashing stable:

* The dashboard is built using a YAML config file at `config/config.yml`, no
  dashboard.erb is used (merged
  [PR#95](https://github.com/Shopify/dashing/pull/95) at
  [kabisaict/dashing](https://github.com/kabisaict/dashing).

* HAML parsing enabled, both widgets and templates are built with HAML (merged
  [PR#123](https://github.com/Shopify/dashing/pull/123) at
  [kabisaict/dashing](https://github.com/kabisaict/dashing)).

* Gridster almost completely disabled. Grister is still used to organize the
  layout, but drag & drop has been turned off, and all add-ons are removed.

Check out http://shopify.github.com/dashing for more information.

## Contributing

Please see [CONTRIBUTING.md][] for details.

## Credits

Dashboard was originally written by Jean Mertz (@JeanMertz) and is based on the
[Dashing][] framework.

[![kabisa](http://kabisa.nl/assets/logo-7456ff79fa2f4a5d72514a807733182d.png)](http://www.kabisa.nl)

Dashboard is a Kabisa initiative.

## License

Dashboard is Copyright © 2013 Jean Mertz and Kabisa ICT. It is free software,
and may be redistributed under the terms specified in the [LICENSE.txt][] file.

[Dashing]: http://shopify.github.io/dashing/
[CONTRIBUTING.md]: CONTRIBUTING.md
[LICENSE.txt]: LICENSE.txt
