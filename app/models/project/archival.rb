# -*- encoding : utf-8 -*-
class Project

  scope :archived, :conditions => {:archived => true}
  scope :unarchived, :conditions => {:archived => false}

  def archive!
    update_attribute(:archived, true)
    update_attribute(:date_end, Time.now)
  end

end
