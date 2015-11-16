module Jekyll

  class ChannelPage < Page
    def initialize(site, base, dir, channel)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'channel.html')
      self.data['channel'] = channel
      self.data['title'] = channel
      self.data['layout'] = "channel"
    end
  end

  class ChannelPageGenerator < Generator
    safe true

    def generate(site)
      channels = Dir.glob('_data/slack_export/*').select { |f| File.directory? f }
      channels.each do |channel|
        site.pages << ChannelPage.new(site, site.source, channel, channel)
      end
    end
  end

end
