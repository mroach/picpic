require 'autoface'
require 'rails_helper'

module Autoface
  describe Processor do
    describe '.zoom' do
      it "zooms out" do
        args = [ -0.1, 100, 100, 100, 100 ]
        expected = { x: 95, y: 95, width: 110, height: 110 }
        expect(Processor.zoom *args).to eq expected
      end
    end

    describe '#detect_faces' do
      it "finds four faces in sample file four_faces.jpg" do
        sample_path = File.join(Rails.root, 'spec/fixtures/files/four_faces.jpg')
        processor = Processor.new(sample_path)

        expect(processor.detect_faces.length).to eq 4
      end
    end

    describe '#extract_faces' do
      outpath = Dir.tmpdir
      sample_path = File.join(Rails.root, 'spec/fixtures/files/four_faces.jpg')
      processor = Processor.new(sample_path, { dir: outpath })
      results = processor.extract_faces

      it "should return four file paths" do
        expect(results).to be_an Array
        expect(results.count).to eq 4
      end

      it "should create four face files" do
        files = Dir.glob(File.join(outpath, '/four_faces_*.jpg'))
        expect(files.count).to eq 4

        # Cleanup the extracted face files
        files.each { |f| File.unlink f }
      end
    end
  end
end
