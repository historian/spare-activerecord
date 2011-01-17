module Spare::ActiveRecord
  module DatabaseLoader

    def self.load(options={})
      Spare::ActiveRecord::SchemaLoader.load(options.dup)
      Spare::ActiveRecord::ContentLoader.load(options.dup)
    end

  end
end
