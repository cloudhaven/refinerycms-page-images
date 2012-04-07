module Refinery
  module PageImages
    include ActiveSupport::Configurable

    config_accessor :captions
    config_accessor :mountings

    self.captions = false
    self.mountings = ["Refinery::Blog::Post", "Refinery::Page"]
  end
end
