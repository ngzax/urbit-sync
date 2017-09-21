#!/usr/bin/env ruby

require 'filewatcher'
require 'pathname'

def load_config
  require 'yaml'

  config_file = YAML.load_file('_config.yml')

  config = {}
  config['desks']      = config_file['desks']
  config['paths']      = config_file['paths']
  config['pier']       = config_file['pier']
  config['watch_dirs'] = config_file['watch_dirs']
  config
end

c = load_config
unless (c.empty?)
  FileWatcher.new(c['watch_dirs']).watch do |fn, ev|
    p = Pathname.new(fn)
    watch_dir = c['watch_dirs'].find {|d| p.realpath.to_s.include?(d)}
    index = c['watch_dirs'].index(watch_dir)

    if(ev == :changed)
      rel_path = p.realpath.sub(c['watch_dirs'][index], '').sub(fn, '')
      cmd = "cp -af #{fn} #{c['pier']}#{c['desks'][index]}#{c['paths'][index]}#{rel_path}"
    end
    p "--> #{cmd}"
    system(cmd)
  end
end
