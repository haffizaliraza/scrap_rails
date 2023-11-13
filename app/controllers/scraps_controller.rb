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
    # Initialize a result array
    results = []
    # Set up Selenium
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless') # Use headless mode for invisible browser
    driver = Selenium::WebDriver.for :chrome, options: options

    for url in urls
      # Initialize a hash to store found categories and URLs for this website
      found_categories = {}

      for keyword in keywords
        # Search Google for the "site:website_url category" query
        query = "site:#{url} #{keyword}"
        search_url = "https://www.google.com/search?q=#{query}"

        # Open the search results page
        driver.get(search_url)

        # Initialize an array to collect found URLs for the current category
        found_links = []

        # Locate and interact with the search results
        for i in 0..4  # Limiting to the top 5 results for each URL
          begin
            result = driver.find_element(css: ".g:nth-child(#{i+1})")
            link = result.find_element(tag_name: 'a').attribute('href')
            found_links.append(link)
          rescue Selenium::WebDriver::Error::NoSuchElementError
            next
          end
        end

        # Add the array of found URLs to the hash for the current category
        found_categories[keyword] = found_links
      end

      # Add the found categories and URLs to the results for this website
      results.append({ 'URL' => url, 'Found Categories' => found_categories })
    end

    # Close the WebDriver
    driver.quit

    return results
    # # Print the results
    # results.each do |result|
    #   puts "URL: #{result['URL']}"
    #   result['Found Categories'].each do |category, links|
    #     puts "#{category}:"
    #     links.each { |link| puts "    #{link}" }
    #   end
    #   puts "\n"
    # end
    end

    # Only allow a list of trusted parameters through.
    def scrap_params
      params.require(:scrap).permit(:keywords, :urls)
    end
end
