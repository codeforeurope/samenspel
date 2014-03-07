rss_feed :root_url => project_reflections_url(@current_project) do |feed|
  feed.title t('.rss.title', :name => @current_project.name)
  feed.description t('.rss.description', :name => @current_project.name)
  
  for reflection in @reflections
    feed.entry reflection, :url => polymorphic_url([@current_project, reflection]) do |item|
      item.title reflection.name
      item.description reflection_comment(reflection)
      item.author reflection.user.name
    end
  end
end
