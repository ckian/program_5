class Asset < ActiveRecord::Base
  belongs_to :user

#  accepts_nested_attributes_for :recharge_assets, :allow_destroy => true

  has_attached_file :image,
      :styles => {
        :medium => "160x160",
        :large => "600x600"
          }
      
  validates_attachment_size :image, :less_than => 4.megabyte, 
                    :if => Proc.new { |m| !m.image_file_name.blank? }
  

end


