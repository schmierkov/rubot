require 'spec_helper.rb'

RSpec.describe Rubot do
  describe '.start' do
    it 'rubot start' do
      expect(JSON).to receive(:parse)
      expect(HTTP).to receive(:post)
        .with("https://slack.com/api/rtm.start", {:params=>{:token=>nil}})
          .and_return({})

      Rubot.start
    end
  end

  context 'with payload' do
    let(:payload) { {
      'url' => 'abc',
      'self' => {
        'id' => 'fooID',
        'name' => 'foo'
      }
    } }

    before do
      expect(HTTP).to receive(:post)
      expect(JSON).to receive(:parse).and_return(payload)
      Rubot.start
    end

    describe '.id' do
      it 'uses url from payload' do
        expect(Rubot.id).to eq('fooID')
      end
    end

    describe '.url' do
      it 'uses url from payload' do
        expect(Rubot.url).to eq('abc')
      end
    end

    describe '.name' do
      it 'uses url from payload' do
        expect(Rubot.name).to eq('foo')
      end
    end

    describe '.process_command' do
      let(:params) { { foo: :bar } }

      it 'calls Command class with params' do
        expect(Rubot::Command).to receive(:new).with(params, 'fooID', 'foo')
          .and_call_original

        Rubot.process_command(params)
      end
    end
  end
end
