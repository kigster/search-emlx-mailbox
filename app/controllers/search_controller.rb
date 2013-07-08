class SearchController < ApplicationController

  def emails
    @search = if params[:query].present?
                Email.search do
                  fulltext params[:query] do
                    fields *params[:fields] if params[:fields]
                  end
                  with(:received).greater_than(params[:date_from]) if params[:date_from].present?
                  with(:received).less_than(params[:date_to]) if params[:date_to].present?
                  paginate :page => params[:page] || 1, per_page: 15
                  order_by :received, :asc
                end
              else
                nil
              end
    @emails = @search.try(:results) || []
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
    send_data @email.header + "\n\n" + @email.body, :filename => @email.file_name_with_extension
  end

end
