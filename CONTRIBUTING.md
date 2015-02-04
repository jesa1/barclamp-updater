# Contributing

We are glad you want to contribute to Crowbar! We utilize Github
Issues for issue tracking and contributions. You can contribute
in two ways:

* Reporting an issue or making a feature request [here](#issue-tracking)
* Adding features or fixing bugs yourself and contributing your code


## Contribution Process

We have a 3 step process that utilizes Github Issues:

* Sign the [Contributor License Agreement](#contributor-license-agreement)
* Create a Github Pull Request
* Get [code reviews](#review-process) by core maintainers


## Pull Requests

We strive to ensure high quality throughout the Crowbar experience. In
order to ensure this, we require a couple of things for all pull requests:

1.  Tests: To ensure high quality code and protect against future
    regressions, we require all the code in Crowbar to have at least
    unit test coverage. See the spec/unit directory for the existing
    tests and use ```bundle exec rake spec``` to run them.

2.  Green Travis Run: We use [Travis CI](https://travis-ci.org/) in
    order to run our tests continuously on all the pull requests. We
    require the Travis runs to succeed on every pull request before being
    merged.

In addition to this it would be nice to include the description of
the problem you are solving with your change. You can use Crowbar Issue
Template in the description section of the pull request.


## Review Process

The review process happens on Github pull requests. Once you create
a pull request, the Crowbar core maintainers will review your code
and respond to you with any feedback they might have. The process at
this point is as follows:

1.  1 thumbs-ups are required from the Crowbar core maintainers team
    for all merges
2.  When ready, your pull request will be tagged with label Merge
3.  Your patch will be merged into master including necessary documentation
    updates and you will be included in ```CHANGELOG.md```. Our goal
    is to have patches merged in 2 weeks after they are marked to be
    merged.

If you would like to learn about when your code will be available in a
release of Crowbar, read more about [Release Process](#release-process).


## Obvious Fixes

Small contributions such as fixing spelling errors, where the content
is small enough to not be considered intellectual property, can be
submitted by a contributor as a patch, without a CLA.

As a rule of thumb, changes are obvious fixes if they do not introduce
any new functionality or creative thinking. As long as the change
does not affect functionality, some likely examples include the
following:

* Spelling / grammar fixes
* Typo correction, white space and formatting changes
* Comment clean up
* Bug fixes that change default return values or error codes
* Adding logging messages or debugging output
* Changes to ‘metadata’ files like Gemfile, .gitignore, etc.
* Moving source files from one directory or package to another


## Issue Tracking

Issue Tracking is handled using Github Issues. If you are familiar
with Crowbar and know the component that is causing you a problem
or if you have a feature request on a specific component you can
file an issue in the corresponding Github project. All of our
Open Source Software can be found in our Github organization.

Otherwise you can file your issue in the Crowbar project and we
will make sure it gets filed against the appropriate project.

In order to decrease the back and forth an issues and help us get
to the bottom of them quickly we use below issue template. You can
copy paste this code into the issue you are opening and edit it
accordingly.

```
### Version:
[Version of the project installed]


### Environment:
[Details about the environment]


### Scenario:
[What you are trying to achieve?]


### Steps to Reproduce:
[What are the things we need to do for your problem?]


### Expected Result:
[What are you expecting to happen as the consequence?]


### Actual Result:
[What actually happens after the reproduction steps?]
```


## Release Process

Our primary shipping vehicle is operating system specific packages
that includes all the requirements of Crowbar. We also release our
software as gems to [Rubygems](https://rubygems.org) but we strongly
recommend using packages since they are the only combination of native
libraries & gems required by Crowbar that we test throughly.

Our version numbering closely follows Semantic Versioning standard.
Our standard version numbers look like X.Y.Z which mean:

* X is a major release, which may not be fully compatible with prior
  major releases
* Y is a minor release, which adds both new features and bug fixes
* Z is a patch release, which adds just bug fixes

Currently there are no fixed intervals for releasing new major or
minor versions and patch versions are released on a when-needed
basis for regressions, significant bugs, and security issues.


## Contributor License Agreement

To get started, [sign the Contributor License Agreement](https://www.clahub.com/agreements/crowbar/crowbar).
