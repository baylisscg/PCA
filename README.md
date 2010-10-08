Proxy Credential Auditing
=========================

Developing a system to allow proxy credential usage to be tracked and audited within the NGS grid stack.

Install
-------

1. Checkout PCA.
2. Install a stable version of [MongoDB](http://www.mongodb.org/). 1.6+
3. Install the `bundler` gem.
4. Run `bundle install` in the root of the PCA checkout to install the required gems.

Running
-------

To run the service in test mode:

1. Seed the database using `rake db:seed`
2. Start the service with `rails server`
3. Browse to [http://localhost:3000](http://localhost:3000)

Testing
-------

The application uses RSpec for testing. To run all the tests use.

    rake spec

Ideally do not use JRuby for this as it, as of 1.5.3, is much slower than MRI or YARV for running tests.

Production
----------

The primary focus is on deployment as a WAR via JRuby. If you have not been using JRuby perform the following.

1. Install JRuby
2. Install the bundler gem.
3. Run `bundle install`

Then:

1. Run `rake war` in the root of PCA.
2. Deploy the `pca.war` to your preferred Java application server.

Project Info
------------

This project is funded by [JISC](http://www.jisc.ac.uk/).
