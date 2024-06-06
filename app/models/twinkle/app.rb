module Twinkle
  class App < ApplicationRecord
    include Twinkle::Concerns::Models::App
    include Summarize
  end
end
