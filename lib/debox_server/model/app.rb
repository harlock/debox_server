class App < ActiveRecord::Base

  # associations
  #----------------------------------------------------------------------

  has_many :recipes

  # validations
  #----------------------------------------------------------------------

  validates_presence_of :name
  validates_uniqueness_of :name

end
