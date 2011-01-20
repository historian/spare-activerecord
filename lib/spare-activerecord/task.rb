module Spare::ActiveRecord
  class Task < Spare::Task

    def initialize(base_name, &block)
      super(base_name) do
        instance_eval(&block) if block

        include_files 'db/backup/_schema.rb'
        include_files FileList['db/backup/*/*.yml']

        before_backup  'environment'
        before_restore 'environment'

        backup do
          Spare::ActiveRecord::DatabaseDumper.dump
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
