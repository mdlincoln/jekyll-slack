module Jekyll

  class AssetGenerator < Generator
    safe true

    def generate(site)
      files = @contexts.site.glob('_data/*').select { |f| File.directory? f }
      channels.each do |channel|
        channel_name = File.basename(channel)
        site.pages << ChannelPage.new(site, site.source, channel_name, channel_name)
      end
    end
  end

end
