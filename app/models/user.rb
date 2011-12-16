require 'digest'
class User < ActiveRecord::Base
  
  attr_accessor :password
  
  has_many :assets, :dependent => :destroy
  
  accepts_nested_attributes_for :assets, :allow_destroy => true

  has_attached_file :avatar,  :styles => { :medium => "150x150", :thumb => "30x40" },
                              :default_url => "/images/missing_:style.gif"
  validates_attachment_size :avatar, :less_than => 4.megabyte, 
                    :if => Proc.new { |m| !m.avatar_file_name.blank? }

  has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
  has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => "friendships.created_at"
  has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => "friendships.created_at"
  has_many :friendships, :dependent => :destroy 
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  name_regex = /\A([a-z]*)/i
  
  validates :email,       :presence     => true,
                          :format       => { :with => email_regex },
                          :uniqueness   => { :case_sensitive => false },
                          :on           => :create
                          
  validates :password,    :presence     => true,
                          :confirmation => true,
                          :length       => { :within => 6..40 },
                          :on           => :create
                       
  validates :first_name,  :presence     => true,
                          :format       => { :with => name_regex },
                          :on           => :create
                          
  validates :last_name,  :presence     => true,
                          :format       => { :with => name_regex },
                          :on           => :create

  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  
  def self.search(search)
    if search
      find(:all, :conditions => ['first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end

    
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end