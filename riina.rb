require 'mikunyan'
require 'mikunyan/decoders'
require 'rmagick'
require 'fileutils'
require 'logger'

logger = Logger.new(STDOUT)

ARGV.each {|arg|
  Dir.glob(arg) {|v|
    path = Pathname(v)

    logger.info(path.to_s)

    bundle = Mikunyan::AssetBundle.file(v)
    bundle.assets.each {|asset|
      asset.path_ids.each {|path_id|
        obj = asset.parse_object(path_id)
        img = Mikunyan::ImageDecoder.decode_object(obj)
        if !img.nil?
            name = path.dirname.to_s + "/" + obj.m_Name.value+".png"
            img.save(name)
            rmg = Magick::Image.read(name).first
            rmg = rmg.flop
            rmg = rmg.rotate(180)
            rmg.write(name)
        elsif obj.type == "TextAsset"
            name = path.dirname.to_s + "/" + obj.m_Name.value + ".txt"
            File.write(name, obj.m_Script.value)
        end
      }
    }
  }
}

logger.info("done")
