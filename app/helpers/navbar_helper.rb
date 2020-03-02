module NavbarHelper
  def active_class(controller, action)
  	return '' if params[:controller] != controller.to_s

    params[:action] == action.to_s ? 'active' : ''
  end

  def active_span(controller, action)
  	return '' if params[:controller] == controller.to_s

    params[:action] == action.to_s ? sanitize('<span class="sr-only">(current)</span>') : ''
  end
end