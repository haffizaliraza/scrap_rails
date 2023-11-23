class Document < ApplicationRecord
    has_many :results
    has_one_attached :xlsx_file
    validates :xlsx_file, presence: true
end
