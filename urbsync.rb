#!/usr/bin/env ruby

require 'filewatcher'
require 'optparse'
require 'pathname'

def load_config
  require 'yaml'

  config_file = YAML.load_file('_config.yml')

  config = {}

  ships = config_file['ships']
  ships.each do |ship|
    config['pier']           = ship['ship']['pier']
    config['excluded_files'] = ship['ship']['excluded_files']

    config['watch_dirs'] = []
    config['desks']      = []
    config['paths']      = []

    watches = ship['ship']['watch']
    watches.each do |app|
      root = app['app']['root']
      config['watch_dirs'] << app['app']['comp'].map {|a| "#{root}#{a['src']}"}
      config['desks']      << app['app']['comp'].map {|a| "#{a['desk']}"}
      config['paths']      << app['app']['comp'].map {|a| "#{a['path']}"}
    end
  end

  config['watch_dirs'].flatten!
  config['desks'].flatten!
  config['paths'].flatten!

  config
end

def assemble_path(pier, desk, path, rel_path)
  to_path = "#{pier}#{desk}#{path}#{rel_path}"
  if !Dir.exist?(to_path)
    cmd = "mkdir #{to_path}"
    puts "--> #{cmd}"
    system(cmd) if cmd
  end
  to_path
end

def copy(config, index, from_path)
  to_file = from_path.basename.to_s
  unless ('.' == from_path.basename.to_s[0]) || config['excluded_files'].include?(to_file)
    unless Pathname.new(from_path).symlink?
      rel_path = from_path.realpath.sub(config['watch_dirs'][index], '').sub(to_file, '')
      to_path = assemble_path(config['pier'], config['desks'][index], config['paths'][index], rel_path)
      cmd = "cp -af #{from_path} #{to_path}"
      puts "--> #{cmd}" if config[:verbose]
    end
  else
    puts "Excluded, not copied --> #{to_file}" if config[:verbose]
  end
  system(cmd) if cmd
end

def init(c)
  puts "Initializing all watch directories" if c[:verbose]
  c['watch_dirs'].each do |watch_dir|
    unless watch_dir[-1] == '*'
      index = c['watch_dirs'].index(watch_dir)
      Pathname.new(watch_dir).each_child do |path_to_copy|
        copy(c, index, path_to_copy)
      end
    end
  end
  exit 0
end

def sync(c)
  if c[:verbose]
    puts "Synchronizing all watch directories..."
    c['watch_dirs'].each_with_index {|w, i| puts "#{w} --> #{c['pier']}#{c['desks'][i]}#{c['paths'][i]}"}
  end
  Filewatcher.new(c['watch_dirs'], every: true).watch do |file_events|
    file_events.each_pair do |to_file, event|
      watch_dir_pathname = Pathname.new(to_file)
      watch_dir = c['watch_dirs'].find do |d|
        d.tr!('*', '')
        watch_dir_pathname.realpath.to_s.include?(d)
      end
      index = c['watch_dirs'].index(watch_dir)
      unless event == :deleted
        copy(c, index, watch_dir_pathname)
      end
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
