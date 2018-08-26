class Client < ActiveRecord::Base
  validates :name,         presence: true, uniqueness: { case_sensitive: false }
  validates :companyname,  presence: true
  validates :adress,       presence: true
  validates :postalcode,   presence: true
  validates :otherinfo,    presence: true
  validates :invoiceemail, presence: true
  validates :paymentterms, presence: true 
  
  scope :by_name, -> { order("lower(name)") }
  scope :by_last_updated, -> { order("clients.updated_at DESC") }
  has_many :projects

  has_many :hours, through: :projects
  has_many :mileages, through: :projects
  has_many :expenses, through: :projects

  has_attached_file :logo,
                    styles: { original: "100x100#" },
                    default_url: "",
                    s3_protocol: ""
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def logo_url
    logo.url(:original)
  end
end
