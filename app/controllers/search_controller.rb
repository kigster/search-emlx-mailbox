class SearchController < ApplicationController

  def emails
    @search = if params[:query].present?
                Email.search do
                  fulltext params[:query]
                  paginate :page => params[:page] || 1, :per_page => 50
                  order_by :received, :asc
                end
              else
                nil
              end
    @emails = @search.try(:results) || []
  end

  def show
    @email = Email.find(params[:id])
  end

end
