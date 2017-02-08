class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    #we need to see if :artist_id is set and if artist_id is valid artist
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      #artist_id exists but is not valid
      redirect_to artists_path, alert: "Artist not found."
    else
      #this would set artist_id to nil if not exists but still works in this instance
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    if params[:artist_id]
      @nested = true
      #find and validate the artist
      artist = Artist.find_by(id: params[:artist_id])
      if artist.nil?
        #no artist is found
        redirect_to artists_path, alert: "Artist not found."
      else
        #we limit scope to only songs by artist_id
        @song = artist.songs.find_by(id: params[:id])
        #redirect to artists/:artist_id/songs and alert if no song is found
        redirect_to artist_songs_path(artist), alert: "Song not found." if @song.nil?
      end
    else
      #no artist_id so we are /songs/:id/edit
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

