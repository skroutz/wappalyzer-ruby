require "wappalyzer_rb/version"
require "wappalyzer_rb/apps"

module WappalyzerRb
  class Detector
    attr_reader :analysis

    def initialize(url)
      @url = url
      analyze!
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

    def response
      @response ||= begin
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        http.request(request)
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
