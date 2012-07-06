#!/usr/bin/env ruby
require "wappalyzer_rb"

argument_url = ARGV[0]

if not argument_url.nil?
  puts WappalyzerRb::Detector.new(argument_url).analysis
else
  puts "Usage #{__FILE__} example.com"
end
