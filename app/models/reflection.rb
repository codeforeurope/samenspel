class Reflection  < RoleRecord
  include Immortal

  # needed for `truncate`
  include ActionView::Helpers::TextHelper

  include Watchable

  concerned_with :conversions

  attr_accessor :is_importing, :updating_user

  has_one  :first_comment, :class_name => 'Comment', :as => :target, :order => 'created_at ASC'
  has_many :recent_comments, :class_name => 'Comment', :as => :target, :order => 'created_at DESC', :limit => 2

  has_many :uploads
  has_many :comments, :as => :target, :order => 'created_at DESC', :dependent => :destroy

  accepts_nested_attributes_for :comments, :allow_destroy => false,
                                :reject_if => lambda { |comment| comment['body'].blank? }

  attr_accessible :name, :body, :comments_attributes

  validates_presence_of :name, :message => :no_title

  validate :check_comments_presence, :on => :create, :unless => :is_importing

  scope :recent, lambda { |num| { :limit => num, :order => 'updated_at desc' } }

  before_save :set_comments_author, :if => :updating_user
  after_create :log_create
  after_destroy :clear_targets

  def log_create
    project.log_activity(self,'create')
  end

  def clear_targets
    Activity.destroy_all :target_id => self.id, :target_type => self.class.to_s
  end

  def refs_comments
    [first_comment, first_comment.try(:user)] +
        recent_comments + recent_comments.map(&:user)
  end

  def owner?(u)
    user == u
  end

  def name=(value)
    value = nil if value.blank?
    self[:name] = value
  end

  def body=(value)
    self.comments_attributes = [{ :body => value }] unless value.nil?
  end

  def to_s
    name || ""
  end

  define_index do
    where Reflection.undeleted_clause_sql

    indexes name, :sortable => true

    indexes comments.body, :as => :body
    indexes comments.user.first_name, :as => :user_first_name
    indexes comments.user.last_name, :as => :user_last_name
    indexes comments.uploads(:asset_file_name), :as => :upload_name

    has project_id, created_at, updated_at
  end

  protected

  def check_comments_presence
    unless comments.any?
      errors.add :comments, :must_have_one
    end
  end

  def set_comments_author # before_save
    comments.select(&:new_record?).each do |comment|
      comment.user = updating_user
    end
    true
  end

end
