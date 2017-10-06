#!/usr/bin/env ruby

require 'filewatcher'
require 'optparse'
require 'pathname'

def load_config
  require 'yaml'

  config_file = YAML.load_file('_config.yml')

  config = {}
  config['desks']          = config_file['desks']
  config['excluded_files'] = config_file['excluded_files']
  config['paths']          = config_file['paths']
  config['pier']           = config_file['pier']
  config['watch_dirs']     = config_file['watch_dirs']
  config
end

def copy(config, index, from_path)
  to_file = from_path.basename.to_s
  unless ('.' == from_path.basename.to_s[0]) || config['excluded_files'].include?(to_file)
    rel_path = from_path.realpath.sub(config['watch_dirs'][index], '').sub(to_file, '')
    cmd = "cp -af #{from_path} #{config['pier']}#{config['desks'][index]}#{config['paths'][index]}#{rel_path}"
    puts "--> #{cmd}" if config[:verbose]
  else
    puts "Excluded, not copied --> #{to_file}" if config[:verbose]
  end
  system(cmd) if cmd
end

def init(c)
  puts "Initializing all watch directories" if c[:verbose]
  c['watch_dirs'].each do |watch_dir|
    index = c['watch_dirs'].index(watch_dir)
    Pathname.new(watch_dir).each_child do |path_to_copy|
      copy(c, index, path_to_copy)
    end
  end
  exit 0
end

def sync(c)
  puts "Synchronizing all watch directories..." if c[:verbose]
  Filewatcher.new(c['watch_dirs'], every: true).watch do |to_file, event|
    watch_dir_pathname = Pathname.new(to_file)
    watch_dir = c['watch_dirs'].find {|d| watch_dir_pathname.realpath.to_s.include?(d)}
    index = c['watch_dirs'].index(watch_dir)
    unless event == :deleted
      copy(c, index, watch_dir_pathname)
    end
  end
end


c = load_config
unless (c.empty?)
  OptionParser.new do |opt|
    opt.on('-i', '--init', 'Initialize all watch directories and exit') { |o| c[:init] = true }
    opt.on('-v', '--verbose', 'Prints all operations to the console.') { |o| c[:verbose] = true }
  end.parse!

  c[:init] ? init(c) : sync(c)
end
