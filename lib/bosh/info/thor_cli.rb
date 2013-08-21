require "thor"
require "bosh/info"

module Bosh::Info
  class ThorCli < Thor

    desc "specs", "Show job spec file differences between git tags"
    option :from, required: true,  desc: "The tag or sha in history to compare"
    option :to,   required: false, desc: "The tag or sha in future to compare", banner: "HEAD"
    def specs
      require "bosh/info/cli/commands/specs"
      specs_cmd = Bosh::Info::Cli::Commands::Specs.new(options)
      specs_cmd.perform
    end
  end
end
