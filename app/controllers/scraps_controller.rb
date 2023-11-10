class ScrapsController < ApplicationController
  before_action :set_scrap, only: %i[ show edit update destroy ]

  # GET /scraps or /scraps.json
  def index
    @scraps = Scrap.all
  end

  # GET /scraps/1 or /scraps/1.json
  def show
  end

  # GET /scraps/new
  def new
    @scrap = Scrap.new
  end

  # GET /scraps/1/edit
  def edit
  end

  # POST /scraps or /scraps.json
  def create
    urls = scrap_params[:urls].split(',')
    keywords = scrap_params[:keywords].split(',')
    response = scrap_data(urls, keywords)
    @scrap = Scrap.new(scrap_params)
    respond_to do |format|
      if @scrap.save
        @scrap.results = response
        @scrap.save
        format.html { redirect_to scrap_url(@scrap), notice: "Scrap was successfully created." }
        format.json { render :show, status: :created, location: @scrap }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scrap.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /scraps/1 or /scraps/1.json
  def update
    respond_to do |format|
      if @scrap.update(scrap_params)
        format.html { redirect_to scrap_url(@scrap), notice: "Scrap was successfully updated." }
        format.json { render :show, status: :ok, location: @scrap }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scrap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scraps/1 or /scraps/1.json
  def destroy
    @scrap.destroy

    respond_to do |format|
      format.html { redirect_to scraps_url, notice: "Scrap was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scrap
      @scrap = Scrap.find(params[:id])
    end

    def scrap_data(urls, keywords)
      results = []
    
      for url in urls
        found_categories = {}
    
        for keyword in keywords
          query = "#{url} #{keyword}"
          search_url = "https://www.bing.com/search?q=#{URI.encode_www_form_component(query)}"
          
          begin
            page = Nokogiri::HTML(URI.open(search_url))
            found_links = page.css('a').map { |a| a['href'] }.select { |link| link =~ /^http/ }.first(5)
            found_categories[keyword] = found_links
          rescue StandardError => e
            puts "Error: #{e.message}"
            next
          end
        end
    
        results.append({ 'URL' => url, 'Found Categories' => found_categories })
      end
    
      return results
    end

    # Only allow a list of trusted parameters through.
    def scrap_params
      params.require(:scrap).permit(:keywords, :urls)
    end
end
