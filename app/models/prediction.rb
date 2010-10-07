class FastaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'must be in FASTA format' unless value =~ /^> *\S+.*$\n\S+/
  end
end

class Prediction < ActiveRecord::Base

  include ActiveModel::Validations

  validates :uuid,  :presence => true, :uniqueness => true
  validates :fasta, :presence => true, :fasta => true

  after_validation :sanitize_fasta

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
    @aaseq ||= Bio::FastaFormat.new(fasta).aaseq
  end

  private

  def sanitize_fasta
    if fasta =~ /^>(.*?)$(.*)/
      code  = $1
      seq   = $2
      code  = code.chomp
      seq   = seq.chomp.gsub('-', '').gsub('.', '').gsub(/\s+/, '')
    else
      raise "Invalid FASTA format"
    end
  end

end
