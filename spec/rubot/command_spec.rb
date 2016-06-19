require 'spec_helper.rb'

RSpec.describe Rubot::Command do
  describe '#initialize' do
    let(:command) { 'hello world' }
    let(:bot_id) { '1337' }
    let(:bot_name) { 'bot_name' }
    let(:params) { {
      'type' => 'message',
      'text' => command,
      'user' => 'bar'
    } }
    let(:cmd) { Rubot::Command.new(params, bot_id, bot_name) }

    it 'initializes' do
      expect(cmd.instance_variable_get(:@type)).to eq('message')
      expect(cmd.instance_variable_get(:@input_text)).to eq('hello world')
      expect(cmd.instance_variable_get(:@user)).to eq('bar')
    end

    describe 'process_message' do
      context 'commands' do
        let(:command) { "<@#{bot_id}>: commands" }

        it 'returns list of commands' do
          expect(cmd.run).to eq("@#{bot_name}: commands\n" + 
                                "@#{bot_name}: jokeme\n" +
                                "@#{bot_name}: KEYWORD")
        end
      end

      context 'bot_name jokeme' do
        let(:command) { "<@#{bot_id}>: jokeme" }

        it 'returns correct response' do
          expect(File.read('jokes.txt')).to include(cmd.run)
        end
      end

      context 'bot_name Array.first' do
        let(:command) { "<@#{bot_id}>: Array.first" }

        it 'returns correct response' do
          expect(cmd.run).to start_with('# Array.first')
        end
      end

      context 'bot_name fatal' do
        let(:command) { "<@#{bot_id}>: fatal" }

        it 'returns correct response' do
          expect(cmd.run).to start_with('# .fatal')
        end
      end

      context 'bot_name jump' do
        let(:command) { "<@#{bot_id}>: jump" }

        it 'returns unknown command response' do
          expect(cmd.run).to start_with("Sorry, I don't know what `jump` is.")
        end
      end
    end
  end
end
