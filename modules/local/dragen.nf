process DRAGEN {
    tag "$meta.id"
    label 'dragen'

    secret 'DRAGEN_USERNAME'
    secret 'DRAGEN_PASSWORD'

    input:
    tuple val(meta), path(files_in)
    path index

    output:
    tuple val(meta), path('*.bam')                              , emit: bam         , optional:true
    tuple val(meta), path('*.bai')                              , emit: bai         , optional:true
    tuple val(meta), path('*.cram')                             , emit: cram        , optional:true
    tuple val(meta), path('*.crai')                             , emit: crai        , optional:true
    tuple val(meta), path('*.bw')                               , emit: bigwig      , optional:true
    tuple val(meta), path('*fastq.gz')                          , emit: fastq       , optional:true
    tuple val(meta), path("${prefix}*.vcf.gz")                  , emit: vcf         , optional:true
    tuple val(meta), path("${prefix}*.vcf.gz.tbi")              , emit: tbi         , optional:true
    tuple val(meta), path("${prefix}*.hard-filtered.vcf.gz")    , emit: vcf_filtered, optional:true
    tuple val(meta), path("${prefix}*.hard-filtered.vcf.gz.tbi"), emit: tbi_filtered, optional:true
    tuple val(meta), path("${prefix}.cnv*")                     , emit: cnv         , optional:true
    tuple val(meta), path("${prefix}.sv*")                      , emit: sv          , optional:true
    tuple val(meta), path("sv/*")                               , emit: sv_extra    , optional:true
    tuple val(meta), path("${prefix}.*.csv")                    , emit: csv         , optional:true
    path  "versions.yml"                                        , emit: versions

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"

    def ref = index ? "-r $index" : ''

    // Generate appropriate parameter for input files
    def input = ''
    def rgid = ''
    def rgdm = ''
    def file_list = files_in.collect { it.toString() }
    if (file_list[0].endsWith('.bam')) {
        input = "-b ${files_in}"
    } else {
        input = meta.single_end ? "--tumor-fastq1 ${files_in}" : "--tumor-fastq1 ${files_in[0]} --tumor-fastq2 ${files_in[1]}"
        rgid = meta.rgid ? "--RGID ${meta.rgid}" : "--RGID ${meta.id}"
        rgsm = meta.rgsm ? "--RGSM ${meta.rgsm}" : "--RGSM ${meta.id}"
    }
    """
    /opt/edico/bin/dragen \\
        $ref \\
        --output-directory ./ \\
        --output-file-prefix $prefix \\
        --lic-server=\$DRAGEN_USERNAME:\$DRAGEN_PASSWORD@license.edicogenome.com \\
        $input \\
        $rgid \\
        $rgsm \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dragen: \$(echo \$(/opt/edico/bin/dragen --version 2>&1) | sed -e "s/dragen Version //g")
    END_VERSIONS
    """

    stub:
    prefix = task.ext.prefix ?: "${meta.id}"
    // Generate stub files
    // Haven't included all possible .csv files, just examples
    """
    touch ${prefix}.bam
    touch ${prefix}.bam.bai
    touch ${prefix}.cram
    touch ${prefix}.cram.crai
    touch ${prefix}.vcf.gz
    touch ${prefix}.cnv.vcf.gz
    touch ${prefix}.sv.vcf.gz
    touch ${prefix}.vcf.gz.tbi
    touch ${prefix}.cnv.vcf.gz.tbi
    touch ${prefix}.sv.vcf.gz.tbi
    touch ${prefix}.hard-filtered.vcf.gz
    touch ${prefix}.hard-filtered.vcf.gz.tbi
    touch ${prefix}.seg
    touch ${prefix}.seg.bw
    touch ${prefix}.seg.called
    touch ${prefix}.seg.called.merged
    touch ${prefix}.seg.called.merged.bw
    touch ${prefix}.cnv.gff3
    touch ${prefix}.cnv_metrics.csv
    touch ${prefix}.fastqc_metrics.csv
    touch ${prefix}.mapping_metrics.csv
    touch ${prefix}.wgs_coverage_metrics.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        dragen: \$(echo "vSTUB")
    END_VERSIONS
    """
}
