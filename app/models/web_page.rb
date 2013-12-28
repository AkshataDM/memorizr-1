require "#{Rails.root}/app/models/concerns/url_validator"

class WebPage < ActiveRecord::Base
  require 'uri/http'

  # Setup accessible (or protected) attributes for your model
#  attr_accessible :url, :title

  belongs_to :note
  belongs_to :user

  validates :url, url: true

  def parsed_url
    URI.parse(url)
  end

  def dirname
    File.dirname(url)
  end

  def root
    "#{scheme}://#{host}"
  end

  %w(scheme host port path query).each do |name|
    define_method(name) do
      parsed_url.send(name.to_sym)
    end
  end
end