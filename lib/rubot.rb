require_relative 'rubot/command.rb'

module Rubot
  class << self
    # Public: initializes the slack rtm api and stores response in @payload
    #
    # returns [Hash]
    def start
      @payload = JSON.parse(
        HTTP.post(
          "https://slack.com/api/rtm.start",
          params: { token: ENV['SLACK_API_TOKEN'] }
        )
      )
    end

    # Public: returns the bot internal id
    #
    # returns [String]
    def id
      @payload['self']['id']
    end

    # Public: returns the bot internal id
    #
    # returns [String]
    def url
      @payload['url']
    end

    # Public: returns the bot name
    #
    # returns [String]
    def name
      @payload['self']['name']
    end

    # Public: processes command and returns string
    #
    # returns [String]
    def process_command(event_payload)
      Command.new(event_payload, id, name).run
    end
  end
end
