require "open-uri"

module Jekyll

  class AssetGenerator < Generator
    safe true

    def generate(site)
      Dir.glob('_data/**/*.json') do |j|
        messages = JSON.parse(File.read(j))
        # Find every message that shares a file
        attachment = messages.find {|msg| msg["subtype"] == "file_share"}
        next if attachment.nil?
        # Download the file to the assets/attachments/ directory
        url = attachment["file"]["url_download"]
        next if url.nil?
        FileUtils.mkdir_p("assets/attachments")
        filename = "assets/attachments/#{attachment['file']['id']}.#{attachment['file']['filetype']}"
        open(filename, "wb") do |f|
          f << open(url).read
        end
      end
    end
  end

end
