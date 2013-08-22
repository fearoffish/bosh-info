module Bosh; module Info; module Cli; module Commands; end; end; end; end

require 'easy_diff'
require 'yaml'
require "bosh/info/cli/helpers"

# Runs SSH to the microbosh server
class Bosh::Info::Cli::Commands::Specs
  include Bosh::Info::Cli::Helpers

  def initialize(options)
    puts "OPTIONS: #{options}"
    @options = options
  end

  def perform
    spec_diff(@options[:from], @options[:to] || 'HEAD')
  end

  protected

  def spec_diff(from, to="HEAD")
    # yeah, not sure if this is the best way but it will do for now
    spec_string = `cd #{@options[:cf_release]}; PAGER='' git diff --unified=1000000 #{from} #{to || 'HEAD'} -- jobs/\*/spec 2> /dev/null`
    if spec_string == ""
      puts "Did you specify your cf-release folder? This one looks empty or wrong."
      exit
    end
    specs = find_diffs(spec_string, from, to)
    output_diff(specs)
  end

  def find_diffs(spec_string, from, to)
    specs = {}
    spec_string.split("\n").each do |spec_string|
      if new_file = spec_string.match(/^diff --git (.*) .*/)
        full_filename = new_file[1].split("/")[1..-1].join("/")
        job = new_file[1].split("/")[-2]
        removed, added = file_as_hash(full_filename, from, to)
        specs[job] = {
          full_filename: full_filename,
          job: job,
          removed: removed,
          added: added
        }
      end
    end
    specs
  end

  def file_as_hash(file, from, to)
    before = YAML.load `cd #{@options[:cf_release]}; PAGER='' git show #{from}:#{file} 2> /dev/null`
    after  = YAML.load `cd #{@options[:cf_release]}; PAGER='' git show #{to}:#{file} 2> /dev/null`
    begin
      removed, added = before.easy_diff after
    rescue => x
      return [before || {}, after || {}]
    end
    [remove_empties(removed), remove_empties(added)]
  end

  def remove_empties(hash)
    if hash.kind_of?(Hash)
      hash.each do |key, value|
        if value.is_a?(Enumerable)
          remove_empties(value)
          if value.empty?
            hash.delete(key)
          end
        end
      end
    end
  end

  def output_diff(specs)
    specs.each do |file, values|
      puts "------------------------------------"
      puts "Job: #{values[:job]}".blue
      puts "Removed:"
      puts
      puts values[:removed].to_yaml.red
      puts "Added:"
      puts
      puts values[:added].to_yaml.green
    end
  end
end
