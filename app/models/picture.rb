class Picture < ActiveRecord::Base
  belongs_to :article

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  do_not_validate_attachment_file_type :image
end
