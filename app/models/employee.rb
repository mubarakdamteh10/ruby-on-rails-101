class Employee < ApplicationRecord
  validates :employee_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  
  def as_json(options = {})
    super(options).merge(
      "created_at" => created_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z"),
      "updated_at" => updated_at&.utc&.strftime("%Y-%m-%dT%H:%M:%S%:z")
    )
  end
end
