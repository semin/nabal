class FastaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'must be in FASTA format' unless value =~ /^> *\S+.*$\n\S+/
  end
end

class Prediction < ActiveRecord::Base

  include ActiveModel::Validations

  validates :uuid,      :presence => true, :uniqueness  => true
  validates :sequence,  :presence => true, :fasta       => true

  def to_param
    self.uuid
  end

  def binding_sites
    sites = []
    prediction.each_line do |line|
      if line !~ /labels/
        sites << line.chomp.split(/\s+/)
      end
    end
    sites
  end

  def aaseq
    @aaseq ||= Bio::FastaFormat.new(sequence).aaseq
  end

end
