module Support
  module StubHelpers
    def s3_object_stub # rubocop:disable Metrics/AbcSize
      s3_resource = instance_double('Aws::S3::Resource')
      s3_bucket = instance_double('Aws::S3::Bucket')
      s3_object = instance_double('Aws::S3::Object')
      allow(Aws::S3::Resource).to receive(:new).and_return(s3_resource)
      allow(s3_resource).to receive(:bucket).and_return(s3_bucket)
      allow(s3_bucket).to receive(:object).and_return(s3_object)
      allow(s3_object).to receive(:download_file).and_return(true)
      s3_object
    end

    def successful_command_stub
      command = instance_double('EnvSync::Command')
      allow(EnvSync::Command).to receive(:new).and_return(command)
      allow(command).to receive(:execute).and_return(true)
      command
    end

    def failed_successful_command_stub
      command = instance_double('EnvSync::Command')
      allow(EnvSync::Command).to receive(:new).and_return(command)
      allow(command).to receive(:execute).and_return(false)
      command
    end

    def db_conn_config_stub
      db_conn_data = {
        username: 'user',
        host: 'localhost',
        port: '5432',
        database: 'db_name'
      }
      allow(ActiveRecord::Base).to receive(:connection_db_config).and_return(db_conn_data)
    end

    def schema_load_task_stub
      task = instance_double('Rake::Task')
      allow(Rake::Task).to receive(:[]).with('db:schema:load').and_return(task)
      allow(task).to receive(:invoke)
      task
    end

    def migrate_task_stub
      task = instance_double('Rake::Task')
      allow(Rake::Task).to receive(:[]).with('db:migrate').and_return(task)
      allow(task).to receive(:invoke)
      task
    end
  end
end