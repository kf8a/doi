require 'typhoeus'
require 'json'
require 'nokogiri'

class Doi
  attr_reader :citation

  def initialize(doi_uri)
    get(doi_uri)
  end

  def method_missing(method)
    key = method.to_s.gsub(/_/,'-')
    @citation.fetch(key)
  end

  def get(doi_uri)
    # create a request 
    response = Typhoeus.get("dx.doi.org/" + doi_uri, 
                          headers: {'Accept': 'application/vnd.citationstyles.csl+json'},
                          followlocation: true)

    if response.response_code == 404
      # try google scholar
      get_with_google_scholar(doi_uri)
    else
      begin
        @citation = JSON.parse(response.response_body)
      rescue JSON::ParserError
        warn "JSON:ParserError @{citation}"
        @citation = nil
      end
    end
  end

  def get_with_google_scholar(doi_uri)
    response = Typhoeus.get("scholar.google.com/scholar?q="+ doi_uri, followlocation: true)
    data = Nokogiri::HTML(response.response_body)
    result = data.css "h3.gs_rt"
    @citation = {}
    @citation['title'] = result.text
  end
end
