#!ruby

require 'optparse'
require 'pathname'
require 'uri'
require 'json'
require 'audioinfo'

def force_utf8(str)
  s = str.respond_to?(:encoding) ?
      str.encoding == Encoding::ASCII_8BIT ? str.force_encoding('UTF-8') : str
      : str

  !s.nil? && s.empty? ? nil : s
end

def media_info(filename)
  basename = File.basename(filename, '.*')

  AudioInfo.open(filename) do |info|
    type = case info.extension
    when 'mp4'
      :video
    else
      :audio
    end

    {
      title: force_utf8(info.title) || basename,
      album: force_utf8(info.album) || '',
      type:  type,
    }
  end
end

params = ARGV.getopts('b:')
base = params['b'] || '/'

dir = ARGV.shift || '.'

items = Dir::glob(File.join(dir, '*.{mp3,mp4}')).map { |f|
  basename = File.basename(f, '.*')

  url = ([ base ] + Pathname.new(f).each_filename.to_a.map { |c| URI.encode_www_form_component(c).gsub('+', '%20') }).select { |c| ! c.empty? }.join('/').gsub(%r{/{2,}}, '/')

  media_info(f).merge({
    url: url
  })
}.sort { |a, b| (a[:album] <=> b[:album]).nonzero? || a[:title] <=> b[:title] }

puts JSON.pretty_generate(items)
