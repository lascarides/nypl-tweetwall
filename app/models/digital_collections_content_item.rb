class DigitalCollectionsContentItem < ActiveRecord::Base
  include Expirable

  has_many :digital_collections_content_matches, :dependent => :destroy
  has_many :tweets, :through => :digital_collections_content_matches
  belongs_to :thumbnail, :class_name => RemoteImage, :dependent => :destroy, :autosave => true

  attr_accessible :mods_uuid

  validates :mods_uuid,
            :title,
            :thumbnail,
            :presence => true
  validates :mods_uuid, :length => {:maximum => 36}
  validates :title, :length => {:maximum => 510}

  before_validation :fetch_metadata

  expires_in 1.day

  # Fetches additional metadata associated with the item.
  def fetch_metadata
    self.title ||= mods.title
    self.thumbnail ||= RemoteImage.new(:url => mods.thumbnail_uri.to_s)
  end

  def url
    mods.url
  end

  def mods
    @mods ||= DigitalCollections::MODS.new(mods_uuid)
  end

  def glyphicon
    "camera"
  end

  def category
    'images'
  end
end
