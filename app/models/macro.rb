class Macro < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :on => :create, :message => "can't be blank"
  validates_presence_of :user_id, :on => :create, :message => "can't be blank"
  validates_presence_of :description, :on => :create, :message => "can't be blank"
  validates_format_of       :title,
                            :with => /^[\w-]*$/,  
                            :message => " must not include spaces and must be alphanumeric, as it'll be used in the URL of your macro. You may use dashes and underscores.",
                            :on => :create                  
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

end
