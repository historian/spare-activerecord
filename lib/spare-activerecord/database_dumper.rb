module Spare::ActiveRecord
  module DatabaseDumper

    def self.dump(options={})
      Spare::ActiveRecord::SchemaDumper.dump(options.dup)
      Spare::ActiveRecord::ContentDumper.dump(options.dup)
    end

  end
end
