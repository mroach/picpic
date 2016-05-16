module Autoface
  class Processor
    attr_accessor :logger, :path, :output_options
    attr_accessor :mini_image, :image_properties

    def initialize(path, output_options = {})
      self.path = path
      self.output_options = default_output_options.merge(output_options)
      self.logger = Rails.logger

      # Do auto-orientation once. It's slow on larger images but if the image
      # has multiple faces we don't want to be doing this over and over again
      MiniMagick::Image.new(path) do |img|
        img.auto_orient
      end
    end

    def extract_faces
      faces = detect_faces

      raise "No faces found. So sad." if faces.empty?

      logger.info "Found #{faces.length} faces "

      face_number = 1
      outdir = output_options.fetch(:dir, File.dirname(path))
      basename = output_options.fetch(:basename, File.basename(path, '.*'))
      results = []

      faces.each do |region|
        im_image = MiniMagick::Image.open(path)

        # Figure out the factor by which the image was resized from its original to
        # the sample size used in OpenCV detection
        diff_w = im_image.width / mini_image.width.to_f
        diff_h = im_image.height / mini_image.height.to_f

        logger.debug "Size difference: W x#{diff_w} H x#{diff_h}"

        # Figure out the height and width of the crop area after scaling back to
        # the source image size
        width = ((region.bottom_right.x - region.top_left.x) * diff_w).to_i
        height = ((region.bottom_right.y - region.top_left.y) * diff_h).to_i
        off_x = (region.top_left.x * diff_w).to_i
        off_y = (region.top_left.y * diff_h).to_i

        # Quick and dirty adjustment of the image ratio
        # A square is returned by OpenCV and we want a 3:4 image, so we adjust the
        # height of the crop area and then move the area "up" by half the height added
        ratio = (4.0 / 3.0)
        height_change = (height * (ratio - 1)).to_i
        y_change = height_change / -2

        height += height_change
        off_y += y_change
        logger.debug "Adjusting ratio: ∆h: #{height_change}, ∆y #{y_change}"

        off_x, off_y, width, height = self.class.zoom(-0.25, off_x, off_y, width, height).values

        crop_spec = "#{width}x#{height}+#{off_x}+#{off_y}"

        logger.debug "Zoomed crop spec #{crop_spec}"

        outpath = File.join(outdir, "#{basename}_#{face_number}.jpg")

        logger.info "Saving face #{face_number} to #{outpath}"

        im_image.crop crop_spec
        im_image.resize output_options[:size]
        im_image.auto_level if output_options[:auto_level?]
        im_image.quality output_options[:quality]
        im_image.write outpath

        results << outpath

        face_number += 1
      end

      results
    end

    def detect_faces
      load_mini_image!

      face_data_path = '/Users/mroach/Desktop/haarcascade_frontalface_alt.xml.1'
      detector = OpenCV::CvHaarClassifierCascade::load(face_data_path)

      # Ue IM path as it will be a path to the temporary image created
      cv_image = OpenCV::CvMat.load(mini_image.path, OpenCV::CV_LOAD_IMAGE_COLOR)

      detector.detect_objects(cv_image)
    end

    def self.zoom(factor, x, y, width, height)
      change_w = (width * (factor * -1)).to_i
      change_h = (height * (factor * -1)).to_i
      x -= change_w / 2
      y -= change_h / 2
      width += change_w
      height += change_h
      { x: x, y: y, width: width, height: height }
    end

    def load_mini_image!
      im_image = MiniMagick::Image.open(path)
      im_image.resize '600x600'
      self.mini_image = im_image
    end

    def default_output_options
      {
        quality: '80%',     # JPEG output quality
        size: '900x900>',   # > means denotes maximum dimensions so DON'T scale UP
        auto_level?: true,  # Automatically fix colour and contrast levels
        basename: nil
      }
    end
  end

end
