class Employee < ApplicationRecord
  self.primary_key = "employee_id"
  has_many :attendances, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true
  validates :department, presence: true
  validates :position, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  # validates :created_by, presence: true
  # validates :updated_by, presence: true
  def as_json(options = {})
    super(options).merge(
      "created_at" => created_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z"),
      "updated_at" => updated_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z")
    )
  end
end
