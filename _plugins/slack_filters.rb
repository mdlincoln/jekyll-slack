module Jekyll
  module SlackFilters

    def slack_timestamp(input)
      Time.at(input.to_i)
    end

    def slack_user(input)
      userid = /<@(.{9})>/.match(input)
      if userid.nil?
        input
      else
        parsed_msg = input
        userid.captures.to_a.each do |uid|
          username = @context.registers[:site].data["users"].find {|user| user["id"] == uid}["name"]
          parsed_msg = parsed_msg.gsub(/<@#{uid}>/, username)
        end
        parsed_msg
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::SlackFilters)
