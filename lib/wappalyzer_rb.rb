require "wappalyzer_rb/version"
require "wappalyzer_rb/apps"

require "uri"
require "net/http"

module WappalyzerRb
  class Detector
    attr_reader :analysis

    def initialize(url)
      @url = url
      analyze!
    end

    def self.get(url)
      #TODO We could test with https too
      if url.match(/^http/)
        correct_url = url
      else
        correct_url = "http://#{url}"
      end

      uri = URI.parse(correct_url)

      if uri.respond_to? 'request_uri'
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
      else
        puts "Incorrect URI"
      end
    end

    private

    def hostname
      @hostname ||= URI.parse(@url).host
    end

    def data
      response.body
    end

    def url
      @url
    end

    def scripts
      @scripts ||= begin
        data.scan(/<script[^>]+src=("|')([^"']+)\1/i).transpose[1] || []
      end
    end

    def metas
      @metas ||= begin
        data.scan(/<meta[^>]+>/i).flatten.reduce(Hash.new) do |hash, line|
          name = line[/name=("|')([^"']+)\1/, 2]
          content = line[/content=("|')([^"']+)\1/, 2]

          hash[name] = content
          hash
        end
      end
    end

    def headers
      response
    end

    def response(url = nil)
      @response ||= begin
        url ||= @url
        resp = WappalyzerRb::Detector.get(url)

        if resp.nil?
          Process.exit
        end

        redirects = 0
        while resp.code == "302" && resp["location"] # redirect
          raise 'Too many redirects' if redirects > 10

          url = resp["location"]
          redirects += 1

          resp = WappalyzerRb::Detector.get(url)
        end

        resp
      end
    end

    def analyze!
      @analysis ||= begin
        matched_apps = []

        APPS.each do |app, tells|
          tells.each do |type, matcher|
            next if type == :cats

            case type
            when :url
              matched_apps << app if url =~ matcher
            when :html
              matched_apps << app if data =~ matcher
            when :script
              if scripts.any?{|script| script =~ matcher}
                matched_apps << app
              end
            when :meta
              matcher.each do |name, content_rx|
                if metas[name] =~ content_rx
                  matched_apps << app
                end
              end
            when :headers
              matcher.each do |type, content_rx|
                if headers[type.downcase] =~ content_rx
                  matched_apps << app
                end
              end
            when :env
              # Not way to peer into the page's DOM yet
            end
          end
        end

        matched_apps.uniq
      end
    end
  end
end
