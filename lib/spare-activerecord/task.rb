module Spare::ActiveRecord
  class Task < Spare::Task

    def initialize(base_name, &block)
      super(base_name) do
        instance_eval(&block) if block

        before_backup  'environment'
        before_restore 'environment'

        backup do |t|
          Spare::ActiveRecord::DatabaseDumper.dump
          t.include 'db/backup/_schema.rb'
          t.include FileList['db/backup/*/*.yml']
        end

        after_backup do
          FileUtils.rm_rf('db/backup')
        end

        restore do
          Spare::ActiveRecord::DatabaseLoader.load
        end

        after_restore do
          FileUtils.rm_rf('db/backup')
        end
      end
    end

  end
end
