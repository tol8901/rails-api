class ArticlesController < ApplicationController
  include Paginable

  def index
    paginated = paginate(Article.recent)
    render_collection(paginated)
  end

  def serializer
    ArticleSerializer
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

  def pagination_params
    params.permit![:page]
  end
end