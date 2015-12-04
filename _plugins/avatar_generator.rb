require "open-uri"

module Jekyll

  class AvatarGenerator < Generator
    safe true

    def generate(site)
      if @context.registers[:site].config["refresh_avatars"]
        profiles = JSON.parse(File.read("_data/users.json"))
        FileUtils.mkdir_p("assets/avatars")
        profiles.each do |p|
          user_id = p["id"]
          img_url = p["profile"]["image_32"]
          filename = "assets/avatars/#{user_id}.png"
          open(filename, "wb") do |f|
            f << open(img_url).read
          end
        end
      end
    end
  end

end
