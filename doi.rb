require 'typhoeus'
require 'json'

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

    @citation = JSON.parse(response.response_body)
  end
end
