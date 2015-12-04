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

    # Retrieve user name from ID string
    def user_name(id)
      if(id == "USLACKBOT")
        return "SlackBot"
      else
        return @context.registers[:site].data["users"].find {|user| user["id"] == id}["name"]
      end
    end

    # Retrieve user image from ID string
    def user_img(id)
      if(id == "USLACKBOT")
        return "https://slack.global.ssl.fastly.net/66f9/img/slackbot_32.png"
      else
        return "/assets/avatars/#{id}.png"
      end
    end

    # Retrieve channel name from ID string
    def channel_name(id)
      return @context.registers[:site].data["channels"].find {|channel| channel["id"] == id}["name"]
    end

    # Retrieve channel purpose from channel name
    def channel_purpose(name)
      return @context.registers[:site].data["channels"].find {|channel| channel["name"] == name}["purpose"]["value"]
    end

    # Replace user IDs with usernames by searching users.json
    def slack_user(text)
      parsed_msg = text
      # Loop through each mentioned user id, search for its replacement user
      # name, and make the swap
      parsed_msg.scan(/<@(.{9}).*?>/).flatten.each do |uid|
        username = user_name(uid)
        parsed_msg = parsed_msg.gsub(/<@#{uid}.*?>/, "<strong>@#{username}</strong>")
      end
      return parsed_msg
    end

    # Replace channel IDs with channel names and links by searching
    # channels.json
    def slack_channel(text)
      parsed_msg = text
      # Loop through each mentioned user id, search for its replacement user
      # name, and make the swap
      parsed_msg.scan(/<#(.{9})>/).flatten.each do |chid|
        chname = channel_name(chid)
        parsed_msg = parsed_msg.gsub(/<##{chid}>/, "<strong><a href='#{@context.registers[:site].baseurl}/#{chname}'>##{chname}</a></strong>")
      end
      return parsed_msg
    end

    # When a user submits a URL like <google.com> to Slack, it gets translated
    # into a usable url like <http://www.google.com>, but archived as
    # <http://www.google.com|google.com>. We want to keep the usable part to
    # render as markdown, and remove the troublesome pipe, which markdown
    # interprets as a table
    def slack_url(text)
      text.scan(/<(\S+)\|/).flatten.each do |url|
        text = text.gsub(/<#{url}\|\S+>/, "<#{url}>")
      end
      return text
    end

    # Escape pipe characters so that they don't trigger table rendering in
    # markdown. This method ought to be called AFTER slack_url
    def escape_pipes(input)
      input.gsub(/\|/, "\\|")
    end

    def slack_message(input)
      return escape_pipes(slack_url(slack_channel(slack_user(input))))
    end

  end
end

Liquid::Template.register_filter(Jekyll::SlackMessageFilter)
