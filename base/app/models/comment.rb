class Comment < ActiveRecord::Base
  include SocialStream::Models::Object

  attr_accessor :source_page
  
  alias_attribute :text, :description
  validates_presence_of :text

  after_create :increment_comment_count_and_touch
  before_destroy :decrement_comment_count

  #define_index do
    #activity_object_index
  #end

  def parent_post
    self.post_activity.parent.direct_object
  end

  def title
    description.truncate(30, :separator =>' ')
  end

  def header
    return "commented on #{self.parent_post.title}" if self.parent_post
    "" #fallback...
  end


  private

  # after_create callback 
  # 
  # Increment comment counter in parent's activity_object with a comment
  def increment_comment_count_and_touch
    return if self.post_activity.parent.blank?
 
    self.post_activity.parent.direct_activity_object.increment!(:comment_count) 
    self.post_activity.parent.direct_object.touch unless self.post_activity.parent.direct_object.blank?
    self.post_activity.parent.direct_activity_object.touch unless self.post_activity.parent.direct_activity_object.blank?
    self.post_activity.parent.touch
  end 
 
  # before_destroy callback 
  # 
  # Decrement comment counter in parent's activity_object when comment is destroyed 
  def decrement_comment_count 
    return if self.post_activity.blank? or self.post_activity.parent.blank? or self.post_activity.parent.direct_activity_object.blank?
 
    self.post_activity.parent.direct_activity_object.decrement!(:comment_count) 
  end 

end
