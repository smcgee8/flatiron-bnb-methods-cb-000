class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_save :set_host_to_true
  before_destroy :set_host_to_false

  def set_host_to_true
    self.host.host = true
    self.host.save
  end

  def set_host_to_false
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    self.reviews.to_ary.sum{|r| r.rating}.to_f / self.reviews.count.to_f
  end

end
