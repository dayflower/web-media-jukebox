#!ruby

require 'optparse'
require 'pathname'
require 'uri'
require 'json'
require 'mp4info'

params = ARGV.getopts('b:')
base = params['b'] || '/'

dir = ARGV.shift || '.'

items = Dir::glob(File.join(dir, '*.{mp4}')).map { |f|
  basename = File.basename(f, '.*')

  url = ([ base ] + Pathname.new(f).each_filename.to_a.map { |c| URI.encode_www_form_component(c).gsub('+', '%20') }).select { |c| ! c.empty? }.join('/').gsub(%r{/{2,}}, '/')

  begin
    [ MP4Info.open(f) ].map { |x|
      {
        title: x.NAM ? x.NAM.force_encoding('UTF-8') : basename,
        album: (x.ALB || "").force_encoding('UTF-8'),
        url:   url,
      }
    }[0]
  rescue
    {
      title: basename,
      album: "",
      url:   url,
    }
  end
}.sort { |a, b| (a[:album] <=> b[:album]).nonzero? || a[:title] <=> b[:title] }

puts JSON.pretty_generate(items)
