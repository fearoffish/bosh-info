module Bosh; module Info; module Cli; module Commands; end; end; end; end

require "bosh/info/cli/helpers"

# Runs SSH to the microbosh server
class Bosh::Info::Cli::Commands::Specs
  include Bosh::Info::Cli::Helpers

  def initialize(options)
    @options = options
  end

  def perform
    spec_diff(@options[:from], @options[:to])
  end

  protected

  def spec_diff(from, to="HEAD")
    # yeah, not sure if this is the best way but it will do for now
    spec_string = `cd /a/fearoffish/cf-release; PAGER='' git diff --unified=1000000 #{from} #{to || 'HEAD'} -- jobs/\*/spec`
    specs = split_specs(spec_string)
  end

  def split_specs(spec_string)
    specs = {}
    file = nil
    spec_string.split("\n").each do |spec_string|
      case
      when new_file = spec_string.match(/^diff --git (.*) .*/)
        file = new_file[1].split("/")[-2]
      when index = spec_string.match(/^index (.*)\.\.(.*)/)
        index = index[1]
        specs[file][:index] = index if file
      when ignore = spec_string.match(/^--- a.*/)
        # puts "ignore #{spec_string}"
      when ignore = spec_string.match(/^\+\+\+ b.*/)
        # puts "ignore #{spec_string}"
      when removed = spec_string.match(/^- (.*)/)
        removed = removed[1]
        specs[file][:removed] << removed if file
      when added = spec_string.match(/^\+ (.*)/)
        added = added[1]
        specs[file][:added] << added if file
      else
        # puts "nothing"
      end
      if file
        specs[file] ||= {}
        specs[file][:added] ||= []
        specs[file][:removed] ||= []
      end
    end
    puts specs
  end

end
