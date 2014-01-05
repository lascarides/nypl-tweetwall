class BiblioCommonsTitleContentItem < ActiveRecord::Base
  include Expirable

  has_many :biblio_commons_title_content_matches, :dependent => :destroy
  has_many :tweets, :through => :biblio_commons_title_content_matches
  belongs_to :thumbnail, :class_name => RemoteImage, :dependent => :destroy, :autosave => true

  attr_accessible :title_id,
                  :title

  validates :title_id,
            :title,
            :thumbnail,
            :format,
            :presence => true
  validates :title, :length => {:maximum => 510}

  before_validation :fetch_metadata

  expires_in 1.day

  # Fetches additional metadata associated with the item.
  def fetch_metadata
    self.title ||= biblio_commons.title
    self.thumbnail ||= RemoteImage.new(:url => biblio_commons.thumbnail_url)
    self.format ||= biblio_commons.format
  end

  def url
    biblio_commons.url
  end

  def biblio_commons
    @biblio_commons ||= BiblioCommons::Title.new(title_id)
  end

  def glyphicon
    case self.format
    when 'EBOOK'    then 'ipad'
    when 'DVD'      then 'film'
    when 'MUSIC_CD' then 'music'
    else                 'book-open'
    end
  end

  def category
    'books'
  end
end
