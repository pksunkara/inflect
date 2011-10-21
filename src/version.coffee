# The `Version` class defines the version of this package

MAJOR = '1'
MINOR = '0'
TINY = '0'
PRE = 'rc1'

module.exports =

    # _Major_ - Major version for major changes
    MAJOR: MAJOR

    # _Minor_ - Minor version for new features
    MINOR: MINOR

    # _Tiny_ - Tiny version for bug fixes
    TINY: TINY

    # _Pre_ - Pre version for development
    PRE: PRE

    # Module __version__
    VERSION: [MAJOR, MINOR, TINY].join('.') + '-' + PRE
