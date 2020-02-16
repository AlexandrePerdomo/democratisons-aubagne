module NavbarHelper
  def active_class(action)
    params[:action] == action.to_s ? 'active' : ''
  end

  def active_span(action)
    params[:action] == action.to_s ? sanitize('<span class="sr-only">(current)</span>') : ''
  end
end