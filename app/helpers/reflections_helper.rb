module ReflectionsHelper
  def reflections_primer(project)
    if project.editable?(current_user)
      render 'reflections/primer', :project => project
    end
  end

  def new_reflection_link(project)
    link_to content_tag(:span, t('.new_reflection')), new_project_reflection_path(project),
            :class => 'add_button', :title => 'new_reflection_link'
  end

  def the_reflection_link(reflection)
    link_to h(reflection.name), project_reflection_path(reflection.project,reflection), :class => 'reflection_link'
  end

  def reflection_comment(reflection)
    if comment = reflection.comments.first
      render 'comments/comment', :comment => comment
    end
  end

  def reflection_comments_count(reflection)
    pluralize(reflection.comments.size, t('.message'), t('.messages'))
  end

  def reflection_column(project,reflections,options={})
    options[:reflection] ||= nil
    options[:show_reflection_settings] ||= false

    render 'reflections/column',
           :project => project,
           :reflections => reflections,
           :reflection => options[:reflection],
           :show_reflection_settings =>  options[:show_reflection_settings]
  end

end
