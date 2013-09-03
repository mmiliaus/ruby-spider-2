require 'open-uri'

WIKIPEDIA_DOMAIN = 'http://en.wikipedia.org'

class Page
  attr_accessor :heading, :abstract, :links

  def initialize resource
    @resource = resource
  end

  def download
    url = "#{WIKIPEDIA_DOMAIN}/wiki/#{@resource}"
    @source = open(url).read
    self
  end

  def get_data
    @heading = get_heading(@source)
    @abstract = get_abstract(@source)
    @links = get_links(@source)
  end

  def get_heading source_html
    m = source_html.match(/<h1.*>(.+?)<\/h1>/im)
    m[1].gsub(/<\/?.+>/, "")
  end

  def get_abstract source_html
    m = source_html.match /\<table.+?infobox.+?>.+<\/table>\s+(.+)<div.+?id="toc".*?>/im
    m[1]
  end

  def get_links source_html
    source_html.scan(/<a.+?href="(.+?)"/im).flatten
  end

end

args = ARGV
params = {}
while !args.empty?
  flag = args.shift.gsub(/\A-/,'')
  flag_val = args.shift
  params[flag] = flag_val
end

if !params.include?('r')
  puts %Q(Please provide resource name, i.e.: "Spacex", "V_for_vendetta")
  exit
end

wp = Page.new params['r']
wp.download.get_data
puts wp.heading
