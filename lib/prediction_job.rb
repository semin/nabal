require 'fileutils'
require 'narray'

class PredictionJob < Struct.new(:prediction_id)

  def perform

    # * Fetch a prediction object from the queue
    pred            = Prediction.find(prediction_id)
    pred.started_at = Time.now
    pred.save!

    # * Run PSI-BLAST to get PSSMs
    pred.status = 'Running PSI-BLAST to generate PSSMs'
    pred.save!

    stem        = pred.id
    blast_dir   = Rails.root.join('tmp/blast')
    #blast_db    = Rails.root.join('db/blastdb/uniref100_20100826.fasta')
    blast_db    = Rails.root.join('db/blastdb/uniref90_20101006.fasta')
    blast_bin   = 'blastpgp'
    blast_out   = blast_dir.join("#{stem}.blast")
    blast_pssm  = blast_dir.join("#{stem}.pssm")
    blast_in    = blast_dir.join("#{stem}.fa")
    blast_in.open('w') { |f| f.puts pred.fasta }
    blast_cmd   = "#{blast_bin} -i #{blast_in} -o #{blast_out} -d #{blast_db} -a 4 -j 3 -s T -u 1 -J T -Q #{blast_pssm}"
    system blast_cmd

    # * Create a libsvm compatible input file
    pred.status = 'Creating LibSVM input feature file'
    pred.save!

    esst      = Rails.root.join("db/essts/essts-#{pred.mode.downcase}.mat")
    esst_obj  = Essts.new(esst)

    pssm_ress = []
    pssm_vecs = []

    IO.foreach(blast_pssm) do |line|
      line.chomp!.strip!
      if line =~ /^\d+\s+\w+/
        columns   = line.split(/\s+/)
        pssm_ress << columns[1]
        pssm_vecs << NVector[*columns[2..21].map { |c| Float(c) }]
      end
    end

    win = 9
    rad = win / 2

    svm_in = Rails.root.join("tmp/svm/#{stem}.svm_in")
    svm_in.open('w') do |file|
      ress = Bio::FastaFormat.new(pred.fasta).aaseq.split('')
      ress.each_with_index do |res, ri|

        seq_features = (-rad..rad).map { |dist|
          if (ri + dist) >= 0 && ress[ri + dist]
            AminoAcid.array20(ress[ri + dist])
          else
            AminoAcid::ZeroArray20
          end
        }.flatten

        pssm_features = (-rad..rad).map { |dist|
          if (ri + dist) >= 0 && pssm_vecs[ri + dist]
            pssm_vecs[ri + dist].to_a
          else
            AminoAcid::ZeroArray20
          end
        }.flatten

        dist_features = esst_obj.essts.map { |esst|
          esst_col  = NVector[*esst.scores_from(res).transpose.to_a[0]]
          NMath::sqrt((esst_col - pssm_vecs[ri])**2)
        }.flatten

        file.puts [1, (seq_features + pssm_features + dist_features).map.with_index { |f, i| "#{i+1}:#{f}" }].join(' ')
      end
    end

    # * Scale the input file
    pred.status = 'Scaling LibSVM input feature file'
    pred.save!

    svm_range     = Rails.root.join("db/svm/svm-#{pred.mode.downcase}.range")
    svm_in_scale  = Rails.root.join("tmp/svm/#{stem}.svm_in.scale")
    svm_scale_cmd = "svm-scale -r #{svm_range} #{svm_in} > #{svm_in_scale}"
    system svm_scale_cmd

    # * Predict NA-binding sites using prebuilt SVM model
    pred.status = "Predicting #{pred.mode}-binding sites"
    pred.save!

    svm_model     = Rails.root.join("db/svm/svm-#{pred.mode.downcase}.model")
    svm_pred      = Rails.root.join("tmp/svm/#{stem}.svm_pred")
    svm_pred_cmd  = "svm-predict -b 1 #{svm_in_scale} #{svm_model} #{svm_pred}"
    system svm_pred_cmd

    pred.prediction = File.read(svm_pred)
    pred.save!

    # * Finalize pred procedure with time stamping and changing status
    pred.finished_at  = Time.now
    pred.elapsed_time = pred.finished_at - pred.started_at
    pred.status       = 'Finished'
    pred.save!

  end
end
