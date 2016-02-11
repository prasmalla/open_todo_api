class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  validates_presence_of :name, on: [:create, :update]
  validates :permissions, inclusion: {
    in: %w(public private),
    message: '%{value} not valid. Must be public or private'
  }

  scope :publicly_viewable,  -> { where(permissions: 'public') }
  scope :privately_viewable, -> { where(permissions: 'private') }

  scope :visible_to, -> (user) { user ? all : publicly_viewable }
end
