class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all.order(id: :desc)
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    photo_io = photo_params[:file]
    original_description = photo_io.original_filename
    # Creates the original photo
    @photo = Photo.create({ description: original_description }.merge(photo_params))

    # Now lets try to find some faces and do magic
    Rails.logger.debug photo_io
    processor = ::Autoface::Processor.new(photo_io.tempfile.path, basename: File.basename(photo_io.original_filename, '.*'))
    processor.extract_faces.each do |path|
      Photo.create(
        file: File.new(path),
        description: "Auto from #{original_description}",
        generated: true
      )
    end


    respond_to do |format|
      if @photo.save
        format.html { redirect_to photos_url, notice: 'Photo was successfully created.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to photos_url, notice: 'Photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.fetch(:photo, {}).permit(:description, :comments, :file, :owner_person)
    end
end
