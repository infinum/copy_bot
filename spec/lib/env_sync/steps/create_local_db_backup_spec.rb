RSpec.describe EnvSync::Steps::CreateLocalDbBackup do
  subject(:step) { described_class.new(settings) }

  let(:settings) { EnvSync::Settings.new }

  before do
    settings.load_settings_file('spec/support/settings_with_all_steps.yml')
  end

  it 'does not execute the command if the step should not be run' do
    settings.steps.delete(:create_local_db_backup)
    command = successful_command_stub

    step.run

    expect(command).not_to have_received(:execute)
  end

  context 'when the step should be run' do
    before { db_conn_config_stub }

    it 'executes the command' do
      command = successful_command_stub

      step.run

      expect(command).to have_received(:execute)
    end

    context 'when the command is successfully executed' do
      it 'sets the message' do
        successful_command_stub

        step.run

        expect(step.message).to eq('Created backup of local DB.')
      end

      it 'sets the success variable' do
        successful_command_stub

        step.run

        expect(step.success).to be true
      end
    end

    context 'when the command execution fails' do
      it 'sets the message' do
        failed_successful_command_stub

        step.run

        expect(step.message).to eq('Local DB backup creation failed.')
      end

      it 'does not update the success variable' do
        failed_successful_command_stub

        step.run

        expect(step.success).to be false
      end
    end
  end
end