class DocumentsController < ApplicationController
    before_action :set_document, only: %i[ show edit update destroy ]
    
  
    # GET /documents or /documents.json
    def index
      @documents = Document.all
    end
  
    # GET /documents/1 or /documents/1.json
    def show
    end
  
    # GET /documents/new
    def new
      @document = Document.new
    end
  
    # GET /documents/1/edit
    def edit
    end
  
    # POST /documents or /documents.json
    def create
      @document = Document.new(document_params)
      output = process_xlsx_file(@document, @document.keywords.split(','), "http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--cd49e3a5a6354f9a75bfe25508e5d753ba49062c/urls.xlsx")
      respond_to do |format|
        if @document.save
          format.html { redirect_to document_url(@document), notice: "Document was successfully created." }
          format.json { render :show, status: :created, location: @document }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /documents/1 or /documents/1.json
    def update
      respond_to do |format|
        if @document.update(document_params)
          format.html { redirect_to document_url(@document), notice: "Document was successfully updated." }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /documents/1 or /documents/1.json
    def destroy
      @document.destroy
  
      respond_to do |format|
        format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document
        @document = Document.find(params[:id])
      end
  
      def process_xlsx_file(document, keywords, file)
        results = []
        api_key = 'AIzaSyCxBSDljA4bdL4HIkCSlmmtzsWOdW6ajy8'
        cse_id = '22660612f7fe94f85'
        # xlsx_path = ActiveStorage::Blob.service.path_for(file.key)
        xlsx = Roo::Excelx.new(file)  
  
        xlsx.each_row_streaming(offset: 1) do |row|
          base_url = ensure_https(row[0].value)
          keywords.each do |category|
            url_query = "site:#{base_url} #{category}"
            query_result = google_search(url_query, api_key, cse_id)
            found_links = query_result['items'].to_a.map { |item| item['link'] }
            Result.create(document: document, urls: found_links, keyword: category)
          end
        end
      end
  
      def google_search(query, api_key, cse_id, **kwargs)
        search_url = 'https://www.googleapis.com/customsearch/v1'
        params = {
          'key': api_key,
          'cx': cse_id,
          'q': query,
          **kwargs # Additional parameters
        }
        response = JSON.parse(URI.open("#{search_url}?#{URI.encode_www_form(params)}").read)
        response
      end
  
      def ensure_https(url)
        return nil if url.nil? || url.empty?
        url.start_with?('http://') || url.start_with?('https://') ? url : "https://#{url}"
      end
  
  
      # Only allow a list of trusted parameters through.
      def document_params
        params.require(:document).permit(:xlsx_file, :keywords)
      end
  end
  