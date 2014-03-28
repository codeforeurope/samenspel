# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)

    # Comment & commentable permissions

    can :update, Comment do |comment|
      comment.user_id == user.id and
        Time.now < 15.minutes.since(comment.created_at)
    end

    can :destroy, Comment do |comment|
      comment.project.admin?(user) or
        ( comment.user_id == user.id and
          Time.now < 15.minutes.since(comment.created_at) )
    end

    can :comment, [Task, Conversation, Reflection] do |object, project|
      project ||= object.project
      project.commentable?(user)
    end

    can :watch, [Task, Conversation, Reflection] do |object|
      object.project.commentable?(user)
    end

    # Core object permissions

    can :update, [Conversation, Task, TaskList, Page, Upload, Reflection] do |object|
      object.editable?(user)
    end

    can :destroy, [Conversation, Task, TaskList, Page, Upload, Reflection] do |object|
      object.owner?(user) or object.project.admin?(user)
    end

    # Person permissions

    can :update, Person do |person|
      person.project.admin?(user) and !person.project.owner?(person.user)
    end

    can :destroy, Person do |person|
      !person.project.owner?(person.user) and (person.user == user or person.project.admin?(user))
    end

    # Invite permissions

    can :update, Invitation do |invitation|
      invitation.editable?(user)
    end

    can :destroy, Invitation do |invitation|
      invitation.editable?(user)
    end

    # Contact permissions

    can :create, Contact do |contact|
      true
    end

    can :destroy, Contact do |contact, user|
      #Contact can be deleted only if it belongs to an Organization accessible to the user
      contact.organization.is_admin?(user) || contact.organization.is_participant?(user)
    end

    can :update, Contact do |contact, user|
      #Contact can be updated only if it belongs to an Organization accessible to the user
      contact.organization.is_admin?(user)|| contact.organization.is_participant?(user)
    end

    # Timeline permissions

    can :view_all_timelines, User do |the_user|
      the_user.admin?
    end

    can :view_timeline, Organization do |organization|
      organization.is_admin?(user)
    end

    # Project permissions

    can :converse, Project do |project|
      project.commentable?(user)
    end

    can :reflect, Project do |project|
      project.reflectable?(user)
    end

    can :make_tasks, Project do |project|
      project.editable?(user)
    end

    can :make_task_lists, Project do |project|
      project.editable?(user)
    end

    can :make_pages, Project do |project|
      project.editable?(user)
    end

    can :upload_files, Project do |project|
      project.editable?(user)
    end

    can :reorder_objects, Project do |project|
      project.editable?(user)
    end

    # TODO: remove, this should be consolidated into the organization
    can :transfer, Project do |project|
      project.admin?(user)
    end

    can :update, Project do |project|
      project.owner?(user) or project.admin?(user)
    end

    can :destroy, Project do |project|
      project.owner?(user)
    end

    can :admin, Project do |project|
      project.owner?(user) or project.admin?(user)
    end

    # Organization permissions

    can :admin, Organization do |organization|
      organization.is_admin?(user)
    end

    #Principles permissions

    can :create_principle, Organization do |organization|
      organization.is_admin?(user)
    end

    can [:update, :destroy], Principle do |principle|
      principle.organization.is_admin?(user)
    end

    can [:add_principle_to_project, :remove_principle_from_project], Project do |project|
      can? :admin, project || project.organization.is_admin?(user)
    end

    # User permissions

    can :create_project, User do |the_user|
      the_user.can_create_project? && the_user.is_team_leader?
    end

    can :create_organization, User do |the_user|
      Teambox.config.user_can_create_organization? or the_user.supervisor?
    end

    can :admin, User do |the_user|
      user.id == the_user.id
    end

    can :observe, User do |the_user|
      user.observable?(the_user)
    end

    can :view, :all do |the_user|
      the_user.global_observer?
    end

    # Admin pages permissions, non-RESTful actions
    # authorize! requires 2 arguments, although the second used here is only a "placeholder"  //GM

    can :supervise, :all if user.supervisor?

  end
end
