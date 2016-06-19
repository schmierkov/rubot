module Rubot
  class Command
    # Public: command constructor
    #
    # data     - data hash from event payload
    # bot_id   - id of bot for further identification
    # bot_name - name of bot for possible command identification
    def initialize(data, bot_id, bot_name)
      @type       = data['type']
      @input_text = data['text']
      @user       = data['user']
      @bot_id     = bot_id
      @bot_name   = bot_name
    end

    # Public: runs the command processing
    #
    # returns [nil, String]
    def run
      send(process_type) if allowed_to_process?
    end

    private

    # Private: Represents the processing type
    #
    # Comment: maybe useful if bot should react on events
    #
    # returns [String]
    def process_type
      "process_#{@type}"
    end

    # Private: indicates if input is processable
    #
    # returns [Boolean]
    def allowed_to_process?
      respond_to?(process_type, true) && @bot_id != @user
    end

    # Private: Represents the command processing logic
    #
    # returns [String]
    def process_message
      if @input_text.start_with?("<@#{@bot_id}>: commands")
        "@#{@bot_name}: commands\n" +
        "@#{@bot_name}: jokeme\n" +
        "@#{@bot_name}: KEYWORD"
      elsif @input_text.start_with?("<@#{@bot_id}>: jokeme")
        result = nil
        File.foreach("jokes.txt").each_with_index do |line, number|
          result = line if rand < 1.0/(number+1)
        end
        result
      # this else block is the default if other commands do not match
      elsif @input_text.start_with?("<@#{@bot_id}>: ")
        rdoc_cmd = @input_text.gsub(/<@#{@bot_id}>[:\s]+/,'')
        result = `ri #{rdoc_cmd} --format=markdown`
        if result.empty?
          "Sorry, I don't know what `#{rdoc_cmd}` is."
        else
          result
        end
      elsif @input_text.downcase.include?(@bot_name.downcase)
        "Sorry, I did not understand that. ☹️"
      end
    end
  end
end
