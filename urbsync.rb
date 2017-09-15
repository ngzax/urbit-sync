#!/usr/bin/env ruby

require 'filewatcher'
require 'pathname'

# From
watch_dirs = [
  '/Users/ngzax/Code/urbit-docs',
  '/Users/ngzax/Code/urbit-examples',
]

# To
pier = '~/urbits/socbud_fallen'
desks = [
  '/sandbox',
  '/examples'
]

paths = [
  '/web',
  ''
]


FileWatcher.new(watch_dirs).watch do |fn, ev|
  p = Pathname.new(fn)
  watch_dir = watch_dirs.find {|d| p.realpath.to_s.include?(d)}
  index = watch_dirs.index(watch_dir)

  if(ev == :changed)
    rel_path = p.realpath.sub(watch_dirs[index], '').sub(fn, '')
    cmd = "cp -af #{fn} #{pier}#{desks[index]}#{paths[index]}#{rel_path}"
  end
  p "--> #{cmd}"
  system(cmd)
end



# fn, ev = f.shift
# puts "f: #{fn}"
# puts "e: #{ev}"

# puts "Basename         : #{p.basename}"
# puts "Relative filename: #{File.join('.', p)}"
# puts "Absolute filename: #{p.realpath}"

# This is the old watchr stuff, just haven't deleted it yet.
# ENV["WATCHR"] = "1"

# watch( 'urbit-docs/docs.md' ) {|f| system("cp -f #{f[0]} ../../urbits/socbud_fallen/home/web/")}
# watch( 'urbit-docs/(.*).md' ) {|f| puts "#{f[0]} -- #{f[1]}"}
# watch( 'urbit-docs/(.*).md' ) {|f| system("cp -f #{f[0]} ../urbits/socbud_fallen/home/web/#{f[1]}.md")}
