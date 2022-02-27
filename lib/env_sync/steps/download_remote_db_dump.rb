module EnvSync
  module Steps
    class DownloadRemoteDbDump < BaseStep
      def run
        return unless settings.run_step?(step_name.to_sym)
        return @message = 'Missing S3 credentials in config' unless s3_credentials

        @success = source_object.download_file(destination_file_path)
        @message = successful_download_message
      end

      private

      # @return [Aws::S3::Object]
      def source_object
        s3_resource.bucket(s3_credentials[:bucket]).object(source_file_path)
      end

      # @return [Aws::S3::Resource]
      def s3_resource
        Aws::S3::Resource.new(client: s3_client)
      end

      # @return [Aws::S3::Client]
      def s3_client
        Aws::S3::Client.new(region: s3_credentials[:region], credentials: aws_credentials)
      end

      # @return [Aws::Credentials]
      def aws_credentials
        Aws::Credentials.new(s3_credentials[:access_key_id], s3_credentials[:access_key])
      end

      def s3_credentials
        settings.s3_credentials
      end

      def successful_download_message
        "s3://#{s3_credentials[:bucket]}/#{source_file_path} has been downloaded to #{destination_file_path}"
      end

      # @return [String]
      def source_file_path
        step_settings.dig(:remote_db_dump_download, :source_file_path)
      end

      # @return [String]
      def destination_file_path
        step_settings.dig(:remote_db_dump_download, :destination_file_path)
      end
    end
  end
end