class SearchController < ApplicationController

  def emails
    @search = search_solr
    if params[:download] && @search.total > 0
      generate_zip do |zipname, zip_path|
        send_file zip_path, :type => 'application/zip', :disposition => 'attachment', :filename => zipname
      end
    else
      @emails = @search.try(:results) || []
    end
  end


  def show
    @email = Email.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def download
    @email = Email.find(params[:id])
    send_data @email.full_body, :filename => @email.file_name_with_extension
  end

  private

  def search_solr
    if params[:query].present?
      Email.search do
        fulltext params[:query] do
          fields *params[:fields] if params[:fields]
        end
        with(:received).greater_than(params[:date_from]) if params[:date_from].present?
        with(:received).less_than(params[:date_to]) if params[:date_to].present?
        paginate :page => params[:page] || 1, per_page: params[:per_page] || 20
        order_by :received, :asc
      end
    else
      nil
    end
  end

  def generate_zip(&block)
    export_file_name = "emails-export.zip"
    page = 0
    params[:per_page] = 100
    temp_dir = Dir.mktmpdir
    zip_path = File.join(temp_dir, export_file_name)
    Rails.logger.info("zip file location is #{zip_path}")
    Zip::ZipFile::open(zip_path, true) do |zipfile|
      begin
        page += 1
        params[:page] = page
        search = search_solr
        search.results.each do |email|
          Rails.logger.info("adding file #{email.file_name_with_extension}")
          zipfile.get_output_stream(email.file_name_with_extension) do |io|
            io.write email.full_body
          end
        end
      end while page < search.results.total_pages
    end
    block.call export_file_name, zip_path
  ensure
    FileUtils.rm_rf temp_dir if temp_dir rescue nil
  end

end
