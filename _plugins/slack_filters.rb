# Convert Slack's Unix-style timestamps into a usable date format
module Jekyll
  module TimestampFilter
    def slack_timestamp(input)
      Time.at(input.to_i)
    end
  end
end

Liquid::Template.register_filter(Jekyll::TimestampFilter)

# Methods for parsing Slack's messages
module Jekyll

  module SlackMessageFilter

    # Replace user IDs with usernames by searching users.json
    def slack_user(text)

      username_regex = /<@(.{9})>/

      # If there are no mentioned usernames, return the unaltered text
      if username_regex.match(text).nil?
        return text
      # Otherwise, loop through each mentioned user id, search for its
      # replacement user name, and make the swap
      else
        parsed_msg = text
        matched_userids = username_regex.match(parsed_msg).captures
        matched_userids.each do |uid|
          username = @context.registers[:site].data["users"].find {|user| user["id"] == uid}["name"]
          parsed_msg = parsed_msg.gsub(/<@#{uid}>/, "<strong>#{username}</strong>")
        end
        return parsed_msg
      end
    end

    # When a user submits a URL like <google.com> to Slack, it gets translated
    # into a usable url like <http://www.google.com>, but archived as
    # <http://www.google.com|google.com>. We want to keep the usable part to
    # render as markdown, and remove the troublesome pipe, which markdown
    # interprets as a table
    def slack_url(text)
      text.gsub(/<(.+?)\|/, '<\1>')
    end

    def slack_message(input)
      return slack_url(slack_user(input))
    end

  end
end

Liquid::Template.register_filter(Jekyll::SlackMessageFilter)
