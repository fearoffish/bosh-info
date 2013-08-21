# Requires Ruby language 1.9 and MRI or Rubinius
require "redcard"
RedCard.verify :mri, :ruby, :rubinius, "1.9"


require "bosh/info/version"
require "bundler/setup"

Bundler.require

module Bosh
  module Info
  end
end
