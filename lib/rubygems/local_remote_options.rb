#--
# Copyright 2006 by Chad Fowler, Rich Kilmer, Jim Weirich and others.
# All rights reserved.
# See LICENSE.txt for permissions.
#++

require 'rubygems'

# Mixin methods for handling the local/remote command line options.
module Gem::LocalRemoteOptions

  # Add local/remote options to the command line parser.
  def add_local_remote_options
    add_option(:"Local/Remote", '-l', '--local',
               'Restrict operations to the LOCAL domain') do |value, options|
      options[:domain] = :local
    end

    add_option(:"Local/Remote", '-r', '--remote',
      'Restrict operations to the REMOTE domain') do |value, options|
      options[:domain] = :remote
    end

    add_option(:"Local/Remote", '-b', '--both',
               'Allow LOCAL and REMOTE operations') do |value, options|
      options[:domain] = :both
    end

    add_bulk_threshold_option
    add_source_option
    add_proxy_option
  end

  # Add the --bulk-threshold option
  def add_bulk_threshold_option
    add_option(:"Local/Remote", '-B', '--bulk-threshold COUNT',
               "Threshold for switching to bulk",
               "synchronization (default #{Gem.configuration.bulk_threshold})") do
      |value, options|
      Gem.configuration.bulk_threshold = value.to_i
    end
  end

  # Add the --http-proxy option
  def add_proxy_option
    add_option(:"Local/Remote", '-p', '--[no-]http-proxy [URL]',
               'Use HTTP proxy for remote operations') do |value, options|
      options[:http_proxy] = (value == false) ? :no_proxy : value
      Gem.configuration[:http_proxy] = options[:http_proxy]
    end
  end

  # Add the --source option
  def add_source_option
    add_option(:"Local/Remote", '--source URL',
               'Use URL as the remote source for gems') do |value, options|
      if options[:added_source] then
        Gem.sources << value
      else
        options[:added_source] = true
        Gem.sources.replace [value]
      end
    end
  end

  # Is local fetching enabled?
  def local?
    options[:domain] == :local || options[:domain] == :both
  end

  # Is remote fetching enabled?
  def remote?
    options[:domain] == :remote || options[:domain] == :both
  end

end
