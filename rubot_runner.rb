require 'http'
require 'json'
require 'faye/websocket'
require 'eventmachine'
require 'dotenv'
Dotenv.load

# load `lib` folder
Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each {|file| require file }

rubot = Rubot.start

EM.run do
  ws = Faye::WebSocket::Client.new(Rubot.url)

  ws.on :message do |event|
    data = JSON.parse(event.data) if event && event.data
    p [:message, data]

    if data && response = Rubot.process_command(data)
      ws.send({
        type: 'message',
        text: response,
        channel: data['channel']
      }.to_json)
    end
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
end
