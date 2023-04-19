# nf-core/dragen: Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## RHReynolds/nf-dragen - [19/04/2023]

### `Added`

- Add option to run either DNA or RNA DRAGEN workflow ([#51a9998](https://github.com/RHReynolds/nf-dragen/commit/51a9998352956d02e443c323f6065b8097bb2d18))
- Add stub runs for testing of DRAGEN logic ([#a980cb4](https://github.com/RHReynolds/nf-dragen/commit/a980cb4e391d7bba2f3c90e761f6bd87401987d6))
- Include additional outputs provided by DRAGEN ([#fdc0c8c](https://github.com/RHReynolds/nf-dragen/commit/fdc0c8ca833ecca41ee8b91552ea40a103cfa190)) and update  stub run ([#455ad9d](https://github.com/RHReynolds/nf-dragen/commit/455ad9d6cb9b8e5fc5db88b10007bda7b85b2a74))
- Add `tumor_only` parameter, which permits somatic calling straight from FASTQs for SNVs and SVs ([#ab44938](https://github.com/RHReynolds/nf-dragen/commit/ab44938adea575d67be5458c04a680a6ec9e1644) and [#9d12fac](https://github.com/RHReynolds/nf-dragen/commit/9d12fac589e951f06486be27d3a9bec87212e0c9))

### `Fixed`

- Add `dragen_index = null` to nextflow.config params
- Update MultiQC module and ensure DRAGEN multiqc outputs are registered

## v1.0dev - [date]

Initial release of nf-core/dragen, created with the [nf-core](https://nf-co.re/) template.

### `Added`

### `Fixed`

- Fixed error `Access to 'FASTQC.out' is undefined since the workflow 'FASTQC' has not been invoked before accessing the output attribute` when `-skip_fastqc` enabled by adjusting channel generation

### `Dependencies`

### `Deprecated`
