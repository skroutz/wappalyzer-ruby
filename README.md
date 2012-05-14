wappalyzer-ruby
===============

Analyzes a provided url and returns any services it can detect.

Usage:

    url = 'http://some.url.com'
    WappalyzerRb.new(url).analysis #=> ['Ruby', 'nginx', ...]

It is a fork of https://github.com/ElbertF/Wappalyzer (commit 7431c5e1e1).

TODO
----

* Write a script to automatically translate apps.js to a ruby config file

DONE
----

* Turn this into a gem
* Break off wappalyzer.rb config into some other file

LINKS
-----

* Rubygems (the gem): https://rubygems.org/gems/wappalyzer_rb
* Github (source): https://github.com/vrinek/wappalyzer-ruby
