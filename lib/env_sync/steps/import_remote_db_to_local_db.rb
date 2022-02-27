module EnvSync
  module Steps
    class ImportRemoteDbToLocalDb < BaseStep
      def run
        return unless settings.run_step?(step_name.to_sym)
        return @message = 'Missing remote DB dump file' unless source_file_valid?

        @success = EnvSync::Command.new(command).execute
        @message = @success ? 'Imported remote DB to local DB.' : 'Remote DB to local DB import failed.'
      end

      private

      def command
        "psql -U #{db_conn_config[:username]} -h #{db_conn_config[:host]} -p #{db_conn_config[:port]} " \
          "#{db_conn_config[:database]} < #{source_file_path}"
      end

      def db_conn_config
        ActiveRecord::Base.connection_db_config
      end

      def source_file_path
        step_settings[:remote_db_dump_file_path]
      end

      def source_file_valid?
        source_file_path && File.exist?(source_file_path)
      end
    end
  end
end